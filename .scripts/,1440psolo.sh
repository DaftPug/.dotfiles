#!/bin/bash
intern=eDP
extern=DisplayPort-0

xrandr --output "$intern" --off --output "$extern" --mode 2560x1440 --dpi 109
