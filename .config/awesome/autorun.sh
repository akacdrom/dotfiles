#!/usr/bin/env bash
if ! pgrep -f "chrome" ;
then
  google-chrome-stable &
  picom --experimental-backends &
  /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
  greenclip daemon &
  numlockx
  xset s 0 0
  xset dpms 0 0 0
  setxkbmap -layout tr
  #brightnessctl s 100% &
  #feh --bg-fill ~/Pictures/wallpapers/forest.png
fi
