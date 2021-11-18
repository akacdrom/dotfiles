#!/bin/sh


case $1 in
	"show-brightness")
		
  			brightness=$(brightnessctl | grep 'Current brightness:' | awk '{print $4}' | sed 's/(//' | sed 's/)//')
			if [ "$brightness" == 100% ];then
				echo ""
			else
				echo "%{F#cccccc}$brightness"
			fi
		
		;;
	"inc-brightness")
		
			brightnessctl s 10+%
		
		;;
	"dec-brightness")
		
			brightnessctl s 10-%
		
		;;

	
esac
