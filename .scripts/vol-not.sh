msgID="2345"
msgID2="2346"
msgID3="2347"

case $1 in
    up)
       pactl set-sink-volume @DEFAULT_SINK@ +5% 

        ;;
    down)
       pactl set-sink-volume @DEFAULT_SINK@ -5% 
        ;;
esac

if [ $(pamixer --get-mute) = true ];then
  dunstify  -i /usr/share/icons/Papirus-Dark/24x24/actions/audio-volume-muted.svg 'MUTED' -t 2000 -r $msgID3
fi

if [ $(pamixer --get-default-sink | grep 'FreeBuds' | wc -c) -gt "1" ];then
  dunstify  -i /usr/share/icons/Papirus-Dark/48x48/devices/audio-headphones.svg 'Huawei 4i Earpods Using' -t 2000 -r $msgID2
fi


volume="$(pamixer --get-volume '%')"

# check volume
if [ "$volume" -gt "50" ]; then
    dunstify  -i /usr/share/icons/Papirus-Dark/48x48/status/notification-audio-volume-high.svg "Volume: $volume%" -t 2000 -r $msgID
elif [ "$volume" == "0" ]; then
    dunstify -i /usr/share/icons/Papirus-Dark/48x48/status/notification-audio-volume-muted.svg "Volume: 0% " -t 2000 -r $msgID
else
    dunstify  -i /usr/share/icons/Papirus-Dark/48x48/status/notification-audio-volume-medium.svg "Volume: $volume%" -t 2000 -r $msgID
fi
