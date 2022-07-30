#!/usr/bin/env bash
if ! pgrep -f "picom" ;
then
  #~/.screenlayout/arandr.sh
  ~/.screenlayout/arandr-nvidia.sh
  picom --experimental-backends &
  /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
  greenclip daemon &
  numlockx
  xset s 0 0
  xset dpms 0 0 0
  #brightnessctl s 100% &
  #feh --bg-fill ~/Pictures/wallpapers/forest.png
fi
