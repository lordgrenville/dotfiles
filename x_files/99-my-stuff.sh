#!/bin/sh
# if using sddm, this goes in /etc/X11/xinit/xinitrc.d/99-my-stuff.sh
# since sddm doesn't source ~/.xinitrc like a normal person

xmodmap ~/.Xmodmap&
xsetroot -cursor_name Left_ptr&
xrandr --output LVDS-1 --mode 1366x768 --primary --auto --output VGA-1 --right-of LVDS-1 --auto&
safeeyes&
redshift -l 32:34 &
xscreensaver -nosplash&
