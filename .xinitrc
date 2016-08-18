#!/bin/sh

# /etc/X11/xinit/xinitrc
#
# global xinitrc file, used by all X sessions started by xinit (startx)

# invoke global X session script
#jackd -R -d alsa -d hw:1,0 -r 44100 -p 256 -S -n 3&
#xinput disable `xinput | grep TouchPad | cut -f 2 | cut -b 4-`
sleep 1
sed -i "s/\([^#{]\+[ \t]\+pcm \"hw:\)./\1`aplay -l | grep USB | cut -d : -f 1 | cut -d ' ' -f 2`/" .asoundrc
setxkbmap -layout pl
xrdb -merge ~/.Xresources
xrandr --output DVI-D-0 --output HDMI-1 --primary --right-of DVI-D-0
xsetroot -cursor_name left_ptr
#xsetroot -solid "#fdf6e3"
xsetroot -solid "#002b36"
xscreensaver -no-splash&
exec xmonad
#exec i3
