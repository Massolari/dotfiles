#!/bin/bash

if [[ 'xrandr | grep "HDMI.*connected"' ]]; then
    xrandr --output HDMI-1-1 --rotate right
    xrandr --output eDP-1-1 --pos 1080x420
fi
