  " Plugins {{{
  call plug#begin(stdpath('data') . '/plugged')
  " Tim Pope plugins {{{
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-sleuth'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-sensible'
    Plug 'tpope/vim-obsession'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-dispatch'
    Plug 'tpope/vim-eunuch'
  " }}}

  " Junegunn Choi plugins {{{
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/goyo.vim'
    Plug 'junegunn/seoul256.vim'
    Plug 'junegunn/limelight.vim'
  " }}}

  " Theme plugins {{{
    Plug 'romainl/flattened'
    Plug 'tomasiser/vim-code-dark'
    Plug 'morhetz/gruvbox'
    Plug 'lifepillar/vim-gruvbox8'
    Plug 'tomasr/molokai'
    Plug 'fmoralesc/molokayo'

    " Rainbow Parentheses Improved
    Plug 'luochen1990/rainbow'

    " A light and configurable statusline/tabline plugin for Vim
    Plug 'itchyny/lightline.vim'
  "}}}

  " Linting and fixing {{{
    "A vim plugin wrapper for prettier, pre-configured with custom default prettier settings
    Plug 'prettier/vim-prettier', { 'do': 'npm install' }

    " Intellisense engine for Vim8 & Neovim, full language server protocol support as VSCode
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    " Check syntax in Vim asynchronously and fix files, with Language Server Protocol (LSP) support
    Plug 'dense-analysis/ale'
  " }}}

  " Syntax {{{
    " Vim plugin for compiling, uploading, and debugging arduino sketches
    Plug 'stevearc/vim-arduino'

    " a Vim plugin that provides support for writing LaTeX documents
    Plug 'lervag/vimtex'

    " A collection of language packs for Vim
    Plug 'sheerun/vim-polyglot'

    " Syntax highlighting for tmux
    Plug 'tmux-plugins/vim-tmux'
  " }}}

  " Make vim easier to work with {{{
    " AutoSave - automatically saves changes to disk without having to use
    Plug '907th/vim-auto-save'

    " Insert or delete brackets, parens, quotes in pair.
    Plug 'jiangmiao/auto-pairs'

    " Automatically clear highlight (|:nohlsearch|) after cursor moved and some other autocmd event.
    Plug 'haya14busa/is.vim'

    " Targets.vim is a Vim plugin that adds various text objects to give you more targets to operate on
    Plug 'wellle/targets.vim'

    " Comment functions so powerful—no comment necessary
    Plug 'preservim/nerdcommenter'

    " An always-on highlight for a unique character in every word on a line to help you use f, F and family
    Plug 'unblevable/quick-scope'

    " Jump to any location specified by two characters.
    Plug 'justinmk/vim-sneak'

  "}}}

  " Make programming easier {{{
    " emmet-vim is a vim plug-in which provides support for expanding abbreviations similar to emmet
    Plug 'mattn/emmet-vim'

    " The fastest (Neo)Vim plugin for asynchronously displaying the colours in the file
    " Plug 'RRethy/vim-hexokinase', { 'do': 'make hexokinase' }
    " Plug 'norcalli/nvim-colorizer.lua'

    " Muliple cursor support
    Plug 'terryma/vim-multiple-cursors'

    " Tagbar is a Vim plugin that provides an easy way to browse the tags of the current file
    Plug 'majutsushi/tagbar'

    " UltiSnips - The ultimate snippet solution for Vim
    Plug 'sirver/UltiSnips'

    " This repository contains snippets files for various programming languages.
    Plug 'honza/vim-snippets'

    " Presumably, your target contains a REPL, maybe Clojure, R or python. If you can type text into it, vim-slime can send text to it
    " (Primarily used to send compile arduino code in a new tmux terminal window)
    Plug 'jpalardy/vim-slime'
  "}}}

  " Other {{{
    " vim-startuptime is a Vim plugin for viewing vim and nvim startup event timing information
    Plug 'dstein64/vim-startuptime'

    " Hardtime helps you break that annoying habit vimmers have of scrolling up and down the page using jjjjj and kkkkk
    Plug 'takac/vim-hardtime'

    " A Personal Wiki For Vim
    Plug 'vimwiki/vimwiki'
  " }}}

  " Testing {{{
    " The interactive scratchpad for hackers. Look @ github for further
    " configuration, seems interesting
    Plug 'metakirby5/codi.vim'

    " For SFTP connections
    Plug 'hesselbom/vim-hsftp'
  " }}}

  call plug#end()
  " }}}

  " Autocommands {{{

    " Enable colorizer for every filetype
    " lua require'colorizer'.setup()
    " autocmd FileType * lua require'colorizer'.setup()

    " Fix tex file type set
    autocmd BufRead, BufNewFile *.tex set filetype=tex

    " Vertically center document when entering insert mode
    autocmd InsertEnter * norm zz

    " Remove trailing whiespace on save
    autocmd BufWritePre * %s/\s\+$//e

    augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
    augroup END

    " start zsh automaticly, when usen :term
    " autocmd VimEnter * ++nested split term://zsh

    " Open help in a split to the right with width 84
    augroup vimrc_help
      autocmd!
      autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | vertical resize 88 | endif
    augroup END

    " Make line numbers relative in active window and standard in others
    augroup numbertoggle
      autocmd!
      autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
      autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    augroup END

    " Return to last edit position when opening files (You want this!).
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    " Dont auto comment when going down a line in a comment with enter or O/o.
    " TODO check if this really needs to be in an autocmd
    autocmd FileType * setlocal formatoptions-=r formatoptions-=o

    " Open non-textbased files in standard external programs
    augroup nonvim
       au!
       au BufRead *.png,*.jpg,*.pdf,*.gif,*.xls*,*.ppt*,*.doc*,*.rtf silent execute "!xdg-open " . shellescape(expand("%:p")) . "&>/dev/null &" | buffer# | bdelete# | redraw! | syntax on | let &ft=&ft
    augroup end

    " Use auocmd to force lightline update.
    autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

    " auto source when writing to init.vm alternatively you can run :source $MYVIMRC
    au! BufWritePost $MYVIMRC source %

  " }}}

" Generel settings {{{

set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set iskeyword+=-                      	" treat dash separated words as a word text object"

" Sneak settings
  let g:sneak#label = 1
  let g:sneak#target_labels = ";sftunq/SFGHLTUNRMQZ?0"

" Use system clipboard
set clipboard+=unnamedplus

" Start .vimrc with everything folded
set foldlevelstart=0
set mouse=a
syntax on
set ignorecase
set smartcase
set encoding=utf-8
" 80 characters should be enough in most cases
" set colorcolumn=80

" let g:Hexokinase_highlighters = ['backgroundfull']
" let g:Hexokinase_refreshEvents = ['TextChanged', 'InsertLeave']

" Tab settings
set smarttab
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Search related configurations.
set ignorecase
set smartcase
set incsearch
set hlsearch

set autoindent

if has('linebreak')
  set breakindent
  let &showbreak = '↳ '
  " let &breakat = " \t;:,])}-"
  let &breakat = " ^I!@*-+;:,./?"
  set cpo+=n
end

" make .tex files be recognized as latex files
let g:tex_flavor = "latex"

" A buffer becomes hidden when it is abandoned
set hidden

" Use existing buffers in the current tab if already open.
set switchbuf=useopen


set showmatch           " Show matching brackets.
set number relativenumber
set nu rnu

set cursorline

set nojoinspaces        " Prevents inserting two spaces after punctuation on a join (J)

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

if !&scrolloff
	set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
	set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set nostartofline       " Do not jump to first character with page commands.

" Have a hard time, by default
let g:hardtime_default_on = 0

let g:rainbow_active = 1

let g:qs_enable=0

set nowritebackup
set nocompatible
filetype plugin on
filetype indent on

" For some reason this gets messed up in vim.
if has('nvim')
    nnoremap <silent> <c-[> <esc>:noh<cr>
endif

" Show current position in file
set ruler

" How vim completions work
set completeopt=longest,menuone,preview

set laststatus=2

" Allow undoing changes after reopenning a file.
set undofile
set undolevels=1000
set undoreload=10000

" By default timeoutlen is 1000 ms
set timeoutlen=500

" }}}

" Goyo {{{
  function! s:goyo_enter()
    if executable('tmux') && strlen($TMUX)
      silent !tmux set status off
      silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    endif
    set noshowmode
    set noshowcmd
    set scrolloff=999
    Limelight
    " ...
  endfunction

  function! s:goyo_leave()
    if executable('tmux') && strlen($TMUX)
      silent !tmux set status on
      silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    endif
    set showmode
    set showcmd
    set scrolloff=5
    Limelight!
    " ...
  endfunction

  let g:goyo_width = 100
  autocmd! User GoyoEnter nested call <SID>goyo_enter()
  autocmd! User GoyoLeave nested call <SID>goyo_leave()
" }}}

" Vim-slime {{{
" Set tmux as the default target
let g:slime_target = "neovim"

" arduino:1.2:

" Set where to store slime_paste_file
let g:slime_paste_file = "$HOME/.config/slime/slime_paste"

" }}}

" Arduino {{{

" Compile your project. You may wish to bind this to a key combination. >
nnoremap <leader>ac :ArduinoVerify<CR>

" Compile and upload your project. You may wish to bind this to a key combination. >
nnoremap <leader>au :ArduinoUpload<CR>

" Open a connection to the serial port for debugging. You may wish to bind this to a key combination. >
nnoremap <leader>as :ArduinoSerial<CR>

" Compile and upload your project. If successful, open a connection to the serial port for debugging. You may with to bind this to a key combination.
nnoremap <leader>ad :ArduinoUploadAndSerial<CR>

" let g:arduino_cmd = '/usr/bin/arduino-cli'
" let g:arduino_dir = '~/Arduino'

let g:arduino_use_slime = 1



" }}}

" FZF {{{
" Always enable preview window on the right with 60% width
let g:fzf_preview_window = 'right:60%'

" FZF only in workspace folder
command! -bang Projects call fzf#vim#files('~/Nextcloud/Workspace', fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang Configs call fzf#vim#files('~/.config/', fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)
command! -bang PDFs call fzf#run(fzf#wrap({'source': 'fd --type file --follow --color=always --extension pdf', 'options': '--reverse --info=hidden'}))

command! -bang PDFpath call fzf#run(fzf#wrap({'source': 'fd --type file --follow --color=always --extension pdf', 'options': '--reverse --info=hidden', 'sink': function('FzfPdfPathSink')}))

function! FzfPdfPathSink(pdffile)
  " execute "normal! d$i" . '(' . a:pdffile . ')[' . @@ . ']' . "\<esc>kJx"
  execute "normal! d$"
  execute "normal! a" . '[' . @@ . '](file:~/' . a:pdffile . ')' . "\<esc>"
  " execute 'normal! i)\<esc>'
  " echom fnamemodify('pdffile', ':p')
endfunction
" }}}

" Vim-wiki{{{
" let g:vimwiki_list = [{'path': '~/Nextcloud/Pugwiki/', 'index': 'main'}]
let g:vimwiki_global_ext = 0
let g:vimwiki_folding = 'expr'

let main_wiki = {}
let main_wiki.path = '~/Nextcloud/Pugwiki/'
let main_wiki.index = 'main'
let main_wiki.syntax = 'markdown'
let main_wiki.ext = '.md'
let main_wiki.auto_tags = 1

let project_wiki = {}
let project_wiki.path = '~/Nextcloud/Workspace/'
let project_wiki.index = 'main'
let project_wiki.syntax = 'markdown'
let project_wiki.ext = '.md'
let project_wiki.auto_tags = 1


let g:vimwiki_list = [main_wiki, project_wiki]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
" }}}

" Vimtex {{{
let g:vimtex_enabled=1
" let g:vimtex_syntax_enabled=1
" let g:vimtex_syntax_nested=1
let g:vimtex_view_method='zathura'
let g:vimtex_compiler_progname='nvr'

" nnoremap <localleader>lt :call vimtex#fzf#run()<cr>
" }}}

" wild{menu, mode, char, ignore} {{{

" Set wildmenu (autocompletions in command line)
set wildmenu
set wildmode=longest,list,full
" Command prompt completion keystroke
set wildchar=<tab>
" How to refer to wildchar inside of mappings
set wildcharm=<c-z>

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
endif

" }}}

" Nerdcommenter {{{
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
" }}}

" Theme settings {{{
set termguicolors
set background=dark
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
set t_Co=256            " 256 color support
" highlight Normal ctermbg=NONE
" highlight nonText ctermbg=NONE


" QuickScope settings
augroup qs_colors
  autocmd!
  autocmd ColorScheme seoul256 highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
  autocmd ColorScheme seoul256 highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
augroup END

" let g:seoul256_srgb = 1
let g:seoul256_background = 234
colorscheme seoul256

let g:lightline = {
      \ 'colorscheme': 'seoul256',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'cocstatus', 'readonly', 'filename', 'modified', 'term_jobid' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \	  'cocstatus': 'coc#status',
      \	  'term_jobid': 'LightlineTerminalJobId'
      \ },
      \ }

" :autocmd TermOpen * setlocal statusline=%{b:term_title}

" function to show jobid of :term in lightline
function! LightlineTerminalJobId()
  return &buftype ==# 'terminal' ? '%{b:terminal_job_id}' : ''
endfunction

" }}}

" Mappings {{{
" get ALT to work
" set <m-a>=<press Ctrl-V><press Meta-A>

" Map the leader key to SPACE
let mapleader="\<SPACE>"
let maplocalleader ="-"


" --Buffer-mappings
"  List all buffers
nnoremap <leader>bb :Buffers<CR>
" Delete current buffer
nnoremap <leader>bd :bd<CR>

" --C-mappings
nnoremap <leader>cf :Configs<CR>

" --T-mappings
nnoremap <leader>tf :BTags<CR>

" --F-mappings
"  Space+f+f: Find files
nnoremap <leader>ff :Files<CR>
" Search in git files
nnoremap <leader>fg :GFiles<CR>
" Search in file history
nnoremap <leader>fh :History<CR>
" Search in lines in current file
nnoremap <leader>fl :BLines<CR>
" Create new file
nnoremap <leader>fn :e %:h/
" Space+f+s: Save file
nnoremap <leader>fs :w<CR>
" Edit .vimrc
nnoremap <leader>fp :edit ~/.config/nvim/init.vim<CR>

" --G
" Toggle Goyo on/off
nnoremap <leader>go :Goyo<CR>

" --H
"  Source .vimrc
nnoremap <leader>hrr :source ~/.config/nvim/init.vim<CR>
" Toggle HardTime
nnoremap <leader>ht :HardTimeToggle<CR>

" Open help in a new tab
nnoremap <leader>hh :help<space>
" Close help, if a help-window i open
nnoremap <leader>hq :helpclose<CR>
nnoremap <leader>hc :helpclose<CR>

" --Insert-mappings
inoremap jj <esc>

" --Limelight-mappings
nnoremap <Leader>ll :Limelight!!<CR>

" --Movement-mappings

" --Project-mappings
"  search for files in Nextcloud/Workspace folder
nnoremap <leader>pf :Projects<CR>
" Search for PDF files
nnoremap <leader>pdf :PDFs<CR>
" Open github-page of the plugin-name the cursor is on
nnoremap <silent><leader>pgh :call PlugGithub()<CR>

" --Quit-mappings
nnoremap <leader>qq :qa<CR>
nnoremap <leader>qs :wqa<CR>

" --Terminal mappings
" map <Esc> to exit terminal-mode: >
" tnoremap <Esc> <C-\><C-n>

" close terminal buffer window
tnoremap :q <C-\><C-n>:q!<CR>

" echo b:terminal_job_id
tnoremap :b <C-\><C-n>:echo b:terminal_job_id<CR>

" Open a vertical zsh-term
nnoremap <leader>tv :vs term://zsh<CR>

" Open a horizontal zsh-term
nnoremap <leader>ts :split term://zsh<CR>

" --S-mappings
nnoremap <leader>ss :Snippets<CR>

" QuickScope toggle
nnoremap <leader>sc :QuickScopeToggle<CR>
xnoremap <leader>sc :QuickScopeToggle<CR>

" --Tab-mappings workspace control
" Better tab-indenting
vnoremap <Tab> >gv
vnoremap <S-TAB> <gv
nnoremap <Tab> v>gv<esc>
nnoremap <S-TAB> v<gv<esc>

"  move to next tab
nnoremap <leader><Tab><Tab> :tabn<CR>

nnoremap <leader><Tab>m :tabm<CR>
" create new tab
nnoremap <leader><Tab>n :tabnew<CR>
" close current tab and all its windows
nnoremap <leader><Tab>d :tabclose<CR>
" close all tabs except for current one
nnoremap <leader><Tab>o :tabonly<CR>
" jump to a specific tab by its number
nnoremap <leader><Tab>1 1gt<CR>
nnoremap <leader><Tab>2 2gt<CR>
nnoremap <leader><Tab>3 3gt<CR>
nnoremap <leader><Tab>4 4gt<CR>
nnoremap <leader><Tab>5 5gt<CR>
nnoremap <leader><Tab>6 6gt<CR>
nnoremap <leader><Tab>7 7gt<CR>
nnoremap <leader><Tab>8 8gt<CR>
nnoremap <leader><Tab>9 9gt<CR>

" --Window-mappings
" split current window vertically
nnoremap <leader>wv :vsplit<CR>
" split current window horizontally
nnoremap <leader>ws :split<CR>
" close current window
nnoremap <leader>wd :close<CR>
" close other windows
nnoremap <leader>wo :only<CR>
" Make marked text into a markdown link to a pdf file via fzf
nnoremap <leader>wpp :<C-u>PDFpath<CR>
" Make all windows (almost) equally high and wide
nnoremap <leader>w0 <C-W>=

" Dummy mapping to make error message go away since the Plug doesn't work
nnoremap <leader>wøsdfsdfdsfdssdfdsf <Plug>VimwikiUISelect
" Does the same thing as the Plug, but actualy works
nnoremap <leader>wq :VimwikiUISelect<CR>

""" Windows
" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" nmap <F8> :TagbarToggle<CR>
nnoremap <F8> :TagbarToggle<CR>

" Make Y yank to end of line (much like C and D).
nnoremap Y y$

" Auto expand brackets.
inoremap {<cr> {<cr><c-g>u}<esc>O
inoremap (<cr> (<cr><c-g>u)<esc>O
" }}}

" Snippets {{{
let g:UltiSnipsExpandTrigger       = '<c-t>'
let g:UltiSnipsJumpForwardTrigger  = '<c-e>'
let g:UltiSnipsJumpBackwardTrigger = '<c-a>'
" }}}

" Linting and Fixing {{{
" ALE {{{
let g:ale_fixers = {
      \	'*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'javascript': ['prettier'],
      \ 'css': ['prettier'],
      \ 'html': ['prettier'],
      \}

let g:ale_linters = {'javascript': ['xo']}

let g:ale_fix_on_save = 1

" }}}

" Coc.nvim {{{

let g:coc_global_extensions = ['coc-json', 'coc-tsserver', 'coc-markdownlint', 'coc-python', 'coc-texlab', 'coc-actions']

" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile


" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()

" Remap for do codeAction of selected region
function! s:cocActionsOpenFromSelected(type) abort
  execute 'CocCommand actions.open ' . a:type
endfunction
xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>g@

 inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

let g:coc_snippet_next = '<TAB>'
let g:coc_snippet_prev = '<S-TAB>'

" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)

" Use D to show documentation in preview window
nnoremap <silent> D :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
" autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" }}}

" For vim document highlighting
let g:markdown_fenced_languages = [
      \ 'vim',
      \ 'help'
      \]

" }}}

" Own funtions {{{

  " Open a plugins github page with the cursor on its name
  function! PlugGithub()
    execute "normal! di'u"
    let s:uri = 'https://github.com/' . @@
    echo s:uri
    if s:uri != ""
      silent exec "!xdg-open '".s:uri."'"
    else
      echo "No URI found in line."
    endif
  endfunction
" }}}
