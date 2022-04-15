msgID="2345"
msgID2="2346"

case $1 in
    up)
        pactl set-source-volume @DEFAULT_SOURCE@ +5%
        
        ;;
    down)
        pactl set-source-volume @DEFAULT_SOURCE@ -5%
        ;;
esac

volume=$(pactl list sources | grep 'Description: Built-in Audio Analog Stereo' -A 10 | tr ' ' '\n' | grep -m1 '%' | tr -d '%')
volume="${volume//[[:blank:]]/}"

if [ $(pactl list sources | grep 'Description: Built-in Audio Analog Stereo' -A 20 | grep 'Mute: yes' | wc -c) -gt "1" ]; then
    dunstify -i /usr/share/icons/Papirus-Dark/48x48/status/microphone-sensitivity-muted.svg "Microphone: Muted " -t 2000 -r $msgID2
fi

# check volume
if [ "$volume" -gt "30" ]; then
    dunstify  -i /usr/share/icons/Papirus-Dark/48x48/status/microphone-sensitivity-high.svg "Mic Volume: $volume%" -t 2000 -r $msgID
elif [ "$volume" == "0" ]; then
    dunstify -i /usr/share/icons/Papirus-Dark/48x48/status/microphone-sensitivity-muted.svg "Mic Volume: 0% " -t 2000 -r $msgID
else
    dunstify  -i /usr/share/icons/Papirus-Dark/48x48/status/microphone-sensitivity-medium.svg "Mic Volume: $volume%" -t 2000 -r $msgID
fi
