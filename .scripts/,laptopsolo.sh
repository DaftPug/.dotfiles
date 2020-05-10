#!/bin/bash
intern=eDP
extern=DisplayPort-0

xrandr --output "$extern" --off --output "$intern" --auto --dpi 166
