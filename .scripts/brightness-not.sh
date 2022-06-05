msgID="2345"

case $1 in
	up)
		brightnessctl s 10+%
		;;
	down)
		brightnessctl s 10-%
		;;
esac

brightness=$(brightnessctl | grep 'Current brightness:' | awk '{print $4}' | sed 's/(//' | sed 's/)//' | sed 's/%//' )

if [ "$brightness" -gt "80" ]; then
	dunstify  -i /usr/share/icons/Papirus-Dark/symbolic/status/display-brightness-high-symbolic.svg "Brightness: $brightness%" -t 2000 -r $msgID

elif [ "$brightness" -gt "40" ]; then
	dunstify  -i /usr/share/icons/Papirus-Dark/symbolic/status/display-brightness-symbolic.svg "Brightness: $brightness%" -t 2000 -r $msgID

else
	dunstify  -i /usr/share/icons/Papirus-Dark/symbolic/status/display-brightness-low-symbolic.svg "Brightness: $brightness%" -t 2000 -r $msgID
fi
