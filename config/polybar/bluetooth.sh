#!/bin/sh
if [ $(pactl list sinks | grep "HUAWEI FreeBuds 4i" | wc -c) -gt "1" ]
then
  echo "%{F#5921ff} ""%{F#cccccc}4i""%{F#454545}|"
else
  	if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -gt "1" ]
  	then
    	echo "%{F#5921ff}" "%{F#cccccc}on""%{F#454545}|"
    else
    	echo ""
    fi
fi


