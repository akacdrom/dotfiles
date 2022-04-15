#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto

feh --bg-fill /home/cd-r0m/Pictures/wallpapers/çin.png &
picom &
brightnessctl s 100% &
setxkbmap -layout tr &
/usr/bin/dunst &
/usr/bin/lxpolkit &
numlockx &
xset s 0 0 &
xset dpms 0 0 0 &
greenclip daemon &

export QT_QPA_PLATFORMTHEME=qt5ct

#exec qtile start
exec awesome
