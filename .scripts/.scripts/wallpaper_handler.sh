#!/bin/bash


# feh --randomize --auto-zoom --geometry 1920x1080+0+0 --bg-fill ~/Nextcloud/Wallpapers/1080P &

# my_laptop_external_monitor=$(xrandr --query | grep 'DisplayPort-0')
# if [[ $my_laptop_external_monitor = *connected* ]]; then
#   feh --recursive --randomize --auto-zoom --geometry 2560x1440+1920+0 --bg-fill ~/Nextcloud/Wallpapers &
# else
#   feh --recursive --randomize --auto-zoom --geometry 1920x1080+0+0 --bg-fill ~/Nextcloud/Wallpapers &
# fi

feh --recursive --randomize --auto-zoom --geometry 1920x1080+0+0 --bg-fill ~/Nextcloud/Wallpapers &
feh --recursive --randomize --auto-zoom --geometry 2560x1440+1920+0 --bg-fill ~/Nextcloud/Wallpapers &
