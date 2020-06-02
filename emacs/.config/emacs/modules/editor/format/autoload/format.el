;;; editor/format/autoload.el -*- lexical-binding: t; -*-

(defvar +format-region-p nil
  "Is non-nil if currently reformatting a selected region, rather than the whole
buffer.")

;;;###autoload
(autoload 'format-all--probe "format-all")

(defun +format--delete-whole-line (&optional arg)
  "Delete the current line without putting it in the `kill-ring'.
Derived from function `kill-whole-line'.  ARG is defined as for that
function.

Stolen shamelessly from go-mode"
  (setq arg (or arg 1))
  (if (and (> arg 0)
           (eobp)
           (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0)
           (bobp)
           (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (cond ((zerop arg)
         (delete-region (progn (forward-visible-line 0) (point))
                        (progn (end-of-visible-line) (point))))
        ((< arg 0)
         (delete-region (progn (end-of-visible-line) (point))
                        (progn (forward-visible-line (1+ arg))
                               (unless (bobp)
                                 (backward-char))
                               (point))))
        ((delete-region (progn (forward-visible-line 0) (point))
                        (progn (forward-visible-line arg) (point))))))

;;;###autoload
(defun +format--apply-rcs-patch (patch-buffer)
  "Apply an RCS-formatted diff from PATCH-BUFFER to the current buffer.

Stolen shamelessly from go-mode"
  (let ((target-buffer (current-buffer))
        ;; Relative offset between buffer line numbers and line numbers
        ;; in patch.
        ;;
        ;; Line numbers in the patch are based on the source file, so
        ;; we have to keep an offset when making changes to the
        ;; buffer.
        ;;
        ;; Appending lines decrements the offset (possibly making it
        ;; negative), deleting lines increments it. This order
        ;; simplifies the forward-line invocations.
        (line-offset 0)
        (column (current-column)))
    (save-excursion
      (with-current-buffer patch-buffer
        (goto-char (point-min))
        (while (not (eobp))
          (unless (looking-at "^\\([ad]\\)\\([0-9]+\\) \\([0-9]+\\)")
            (error "Invalid rcs patch or internal error in +format--apply-rcs-patch"))
          (forward-line)
          (let ((action (match-string 1))
                (from (string-to-number (match-string 2)))
                (len  (string-to-number (match-string 3))))
            (cond
             ((equal action "a")
              (let ((start (point)))
                (forward-line len)
                (let ((text (buffer-substring start (point))))
                  (with-current-buffer target-buffer
                    (cl-decf line-offset len)
                    (goto-char (point-min))
                    (forward-line (- from len line-offset))
                    (insert text)))))
             ((equal action "d")
              (with-current-buffer target-buffer
                (goto-char (point-min))
                (forward-line (1- (- from line-offset)))
                (cl-incf line-offset len)
                (+format--delete-whole-line len)))
             ((error "Invalid rcs patch or internal error in +format--apply-rcs-patch")))))))
    (move-to-column column)))

(defun +format--current-indentation ()
  (save-excursion
    (goto-char (point-min))
    (skip-chars-forward " \t\n")
    (current-indentation)))


;;
;; Public library

(defun +format-completing-read ()
  "TODO"
  (require 'format-all)
  (let* ((fmtlist (mapcar #'symbol-name (hash-table-keys format-all--format-table)))
         (fmt (completing-read "Formatter: " fmtlist)))
    (if fmt (intern fmt))))

;;;###autoload
(defun +format-probe-a (orig-fn)
  "Use `+format-with' instead, if it is set.
Prompts for a formatter if universal arg is set."
  (cond (current-prefix-arg
         (list (or (+format-completing-read)
                   (user-error "Aborted"))
               t))
        (+format-with
         (list +format-with t))
        ((funcall orig-fn))))

;;;###autoload
(defun +format-buffer-a (orig-fn formatter mode-result)
  "Advice that extends `format-all-buffer--with' to:

1. Enable partial/region reformatting, while preserving leading indentation,
2. Applies changes via RCS patch, line by line, to protect buffer markers and
   reduce cursor movement or window scrolling.

See `+format/buffer' for the interactive version of this function, and
`+format-buffer-h' to use as a `before-save-hook' hook."
  (let ((f-function (gethash formatter format-all--format-table))
        (executable (format-all--formatter-executable formatter))
        (indent 0)
        (old-line-number (line-number-at-pos))
        (old-column (current-column)))
    (pcase-let*
        ((`(,output ,errput)
          ;; To reliably format regions, rather than the whole buffer, and
          ;; `format-all' (and various formatting functions, like `gofmt') widen
          ;; the buffer, we must copy the region first.
          (let ((output (buffer-substring-no-properties (point-min) (point-max)))
                (origin-buffer (or (buffer-base-buffer) (current-buffer))))
            (with-temp-buffer
              (with-silent-modifications
                (insert output)
                ;; Ensure this temp buffer seems as much like the origin
                ;; buffer as possible, in case the formatter is an elisp
                ;; function, like `gofmt'.
                (cl-loop for (var . val)
                         in (cl-remove-if-not #'listp (buffer-local-variables origin-buffer))
                         ;; Making enable-multibyte-characters buffer-local
                         ;; causes an error.
                         unless (eq var 'enable-multibyte-characters)
                         ;; Using setq-local would quote var.
                         do (set (make-local-variable var) val))
                ;; Since we're piping a region of text to the formatter, remove
                ;; any leading indentation to make it look like a file.
                (setq indent (+format--current-indentation))
                (when (> indent 0)
                  (indent-rigidly (point-min) (point-max) (- indent)))
                (funcall f-function executable mode-result)))))
         (`,status
          (cond ((null output) :error)
                ((eq output t) :already-formatted)
                (t :reformatted))))
      (unwind-protect
          (when (eq status :reformatted)
            (let ((tmpfile (make-temp-file "doom-format"))
                  (patchbuf (get-buffer-create " *doom format patch*"))
                  (coding-system-for-read coding-system-for-read)
                  (coding-system-for-write coding-system-for-write))
              (unless IS-WINDOWS
                (setq coding-system-for-read 'utf-8
                      coding-system-for-write 'utf-8))
              (unwind-protect
                  (progn
                    (with-current-buffer patchbuf
                      (erase-buffer))
                    (with-temp-file tmpfile
                      (erase-buffer)
                      (insert output)
                      (when (> indent 0)
                        ;; restore indentation without affecting new
                        ;; indentation
                        (indent-rigidly (point-min) (point-max)
                                        (max 0 (- indent (+format--current-indentation))))))
                    (if (zerop (call-process-region (point-min) (point-max) "diff" nil patchbuf nil "-n" "-" tmpfile))
                        (setq status :already-formatted)
                      (+format--apply-rcs-patch patchbuf)
                      (list output errput)))
                (kill-buffer patchbuf)
                (delete-file tmpfile))))
        (format-all--show-or-hide-errors errput)
        (goto-char (point-min))
        (forward-line (1- old-line-number))
        (let ((line-length (- (point-at-eol) (point-at-bol))))
          (goto-char (+ (point) (min old-column line-length))))
        (run-hook-with-args 'format-all-after-format-functions formatter status)
        (message (pcase status
                   (:error "Formatting error")
                   (:already-formatted "Already formatted")
                   (:reformatted (format "Reformatted with %s" formatter))))))))


;;
;;; Commands

;;;###autoload
(defun +format/buffer ()
  "Reformat the current buffer using LSP or `format-all-buffer'."
  (interactive)
  (call-interactively
   (if (and (bound-and-true-p lsp-mode)
            (lsp-feature? "textDocument/formatting"))
       #'lsp-format-buffer
     #'format-all-buffer)))

;;;###autoload
(defun +format/region (beg end)
  "Runs the active formatter on the lines within BEG and END.

WARNING: this may not work everywhere. It will throw errors if the region
contains a syntax error in isolation. It is mostly useful for formatting
snippets or single lines."
  (interactive "rP")
  (if (and (bound-and-true-p lsp-mode)
           (lsp-feature? "textDocument/rangeFormatting"))
      #'lsp-format-region
    (save-restriction
      (narrow-to-region beg end)
      (let ((+format-region-p t))
        (+format/buffer)))))

;;;###autoload
(defun +format/region-or-buffer ()
  "Runs the active formatter on the selected region (or whole buffer, if nothing
is selected)."
  (interactive)
  (call-interactively
   (if (doom-region-active-p)
       #'+format/region
     #'+format/buffer)))


;;
;; Hooks

;;;###autoload
(defun +format-enable-on-save-h ()
  "Enables formatting on save."
  (add-hook 'before-save-hook #'+format-buffer-h nil t))

;;;###autoload
(defalias '+format-buffer-h #'+format/buffer
  "Format the source code in the current buffer with minimal feedback.

Meant for `before-save-hook'.")