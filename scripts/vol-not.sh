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

if [ $(pacmd list-sinks  | grep '* index' -A 30 | grep 'FreeBuds' | wc -c) -gt "1" ];then
  dunstify  -i /usr/share/icons/Papirus-Dark/48x48/devices/audio-headphones.svg 'Huawei 4i Earpods Using' -t 2000 -r $msgID2
fi

if [ $(pacmd list-sinks  | grep '* index'  -A 11 | grep 'muted: yes' | wc -c) -gt "1" ]; then
    dunstify -i /usr/share/icons/Papirus-Dark/48x48/status/notification-audio-volume-muted.svg "Volume: Muted " -t 2000 -r $msgID3
fi


volume="$(pacmd list-sinks  | grep '* index' -A 10 | tr ' ' '\n' | grep -m1 '%' | tr -d '%')"
volume="${volume//[[:blank:]]/}"

# check volume
if [ "$volume" -gt "50" ]; then
    dunstify  -i /usr/share/icons/Papirus-Dark/48x48/status/notification-audio-volume-high.svg "Volume: $volume%" -t 2000 -r $msgID
elif [ "$volume" == "0" ]; then
    dunstify -i /usr/share/icons/Papirus-Dark/48x48/status/notification-audio-volume-muted.svg "Volume: 0% " -t 2000 -r $msgID
else
    dunstify  -i /usr/share/icons/Papirus-Dark/48x48/status/notification-audio-volume-medium.svg "Volume: $volume%" -t 2000 -r $msgID
fi
