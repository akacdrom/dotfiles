#!/bin/sh

DEFAULT_SOURCE_INDEX=$(pacmd list-sources | grep "\* index:" | cut -d' ' -f5)

display_volume() {
	if [ -z "$volume" ]; then
	  echo "No Mic Found"
	else
	  volume="${volume//[[:blank:]]/}" 
	  if [[ "$mute" == *"yes"* ]]; then
	    echo "%{F#cccccc}[muted]"
	  elif [[ "$mute" == *"no"* ]]; then
	    echo "%{F#cccccc}$volume"
	  else
	    echo "%{F#cccccc}$volume !"
	  fi
	fi
}

case $1 in
	"show-vol")
		
  			volume=$(pacmd list-sources | grep "index: $DEFAULT_SOURCE_INDEX" -A 7 | grep "volume" | awk -F/ '{print $2}')
  			mute=$(pacmd list-sources | grep "index: $DEFAULT_SOURCE_INDEX" -A 11 | grep "muted")
			display_volume
		
		;;
	"inc-vol")
		
			pactl set-source-volume $DEFAULT_SOURCE_INDEX +7%
		
		;;
	"dec-vol")
		
			pactl set-source-volume $DEFAULT_SOURCE_INDEX -7%
		
		;;
	"mute-vol")
		
			pactl set-source-mute $DEFAULT_SOURCE_INDEX toggle
		
		;;
	
esac
