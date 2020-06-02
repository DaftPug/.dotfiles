#!/bin/bash
# dmenuscript inspired by https://gitlab.com/dwt1/dotfiles/-/blob/master/.dmenu/dmenu-edit-configs.sh

declare options=("kitty
bspwm
picom
neovim
polybar
qutebrowser
sxhkd
xresources
zsh
quit")

choice=$(echo -e "${options[@]}" | dmenu -i -p 'Edit config file: ')

case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	kitty)
		choice="$HOME/.config/kitty/kitty.conf"
	;;
	bspwm)
		choice="$HOME/.config/bspwm/bspwmrc"
	;;
	picom)
		choice="$HOME/.config/picom/picom.conf"
	;;
    doom.d/config.el)
		choice="$HOME/.doom.d/config.el"
	;;
    doom.d/init.el)
		choice="$HOME/.doom.d/init.el"
	;;
	neovim)
		choice="$HOME/.config/nvim/init.vim"
	;;
	polybar)
		choice="$HOME/.config/polybar/config.ini"
	;;
	qutebrowser)
		choice="$HOME/.config/qutebrowser/config.py"
	;;
	sxhkd)
		choice="$HOME/.config/sxhkd/sxhkdrc"
	;;
	zsh)
		choice="$HOME/.zshrc"
	;;
	*)
		exit 1
	;;
esac
kitty -e nvim "$choice"
