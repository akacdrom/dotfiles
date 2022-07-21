#!/usr/bin/env bash
if ! pgrep -f "chrome" ;
then
  sleep 2
  #~/.screenlayout/arandr.sh
  ~/.screenlayout/arandr-nvidia.sh
  sleep 3
  google-chrome-stable --profile-directory=Default --app-id=cinhimbnkkaeohfgghhklpknlkffjgod &
  picom --experimental-backends &
  /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
  greenclip daemon &
  numlockx
  xset s 0 0
  xset dpms 0 0 0
  #brightnessctl s 100% &
  #feh --bg-fill ~/Pictures/wallpapers/forest.png
fi
