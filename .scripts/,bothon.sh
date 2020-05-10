#!/bin/bash
intern=eDP
extern=DisplayPort-0

xrandr --output "$intern" --auto --dpi 166 --output "$extern" --mode 2560x1440 --dpi 109 --right-of "$intern"
