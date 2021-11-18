msgID="2345"
msgID2="2346"
msgID3="2347"

case $1 in
    up)
        pactl set-source-volume @DEFAULT_SOURCE@ +5%
        
        ;;
    down)
        pactl set-source-volume @DEFAULT_SOURCE@ -5%
        ;;
esac

volume=$(pacmd list-sources  | grep '* index' -A 10 | tr ' ' '\n' | grep -m1 '%' | tr -d '%')
volume="${volume//[[:blank:]]/}"

if [ $(pacmd list-sources  | grep '* index'  -A 11 | grep 'muted: yes' | wc -c) -gt "1" ]; then
    dunstify -i /usr/share/icons/Papirus-Dark/48x48/status/microphone-sensitivity-muted.svg "Microphone: Muted " -t 2000 -r $msgID2
fi

if [ $(pacmd list-sources  | grep '* index'  -A 30 | grep 'FreeBuds' | wc -c) -gt "1" ]; then
    dunstify -i /usr/share/icons/Papirus-Dark/48x48/devices/audio-headphones.svg "FreeBuds Microphone Using " -t 2000 -r $msgID3
fi



# check volume
if [ "$volume" -gt "30" ]; then
    dunstify  -i /usr/share/icons/Papirus-Dark/48x48/status/microphone-sensitivity-high.svg "Mic Volume: $volume%" -t 2000 -r $msgID
elif [ "$volume" == "0" ]; then
    dunstify -i /usr/share/icons/Papirus-Dark/48x48/status/microphone-sensitivity-muted.svg "Mic Volume: 0% " -t 2000 -r $msgID
else
    dunstify  -i /usr/share/icons/Papirus-Dark/48x48/status/microphone-sensitivity-medium.svg "Mic Volume: $volume%" -t 2000 -r $msgID
fi
