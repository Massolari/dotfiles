#!/bin/bash

if [[ 'xrandr | grep "HDMI.*connected"' ]]; then
    xrandr --output eDP-1-1 --pos 1920x0
    # xrandr --output HDMI-1-1 --rotate right
fi
