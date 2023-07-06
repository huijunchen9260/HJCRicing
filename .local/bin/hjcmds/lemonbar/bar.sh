#!/bin/sh
# run this script with:
# hjcbar | lemonbar -a 12 -p -f "ibm plex mono" -f "DejaVu Sans Mono" -f "Noto Sans CJK TC" -f "IPAGothic"  -f  "Font Awesome" -B "#282828" -n "hjcbar"

# Run Update when receive SIGTRAP (refbar)
trap 'update' 5

delim='|'

panel_name=hjcbar

calc () { awk "BEGIN { print $*}"; }

clock () { date '+%Y-%m-%d %H:%M'; }

title () { xtitle -t 30 & }

battery () {
    for x in /sys/class/power_supply/BAT?; do
	num="${x##*BAT}"
	AC="$(cat $x/status)"
	CAP="$(cat $x/capacity)"
	case $AC in
	    "Charging") echo "$num: $CAP%" ;;
	    *)
		case "$CAP" in
		    100|9[0-9])	echo "$num: $CAP%" ;;
		    8[0-9]|7[0-9])	echo "$num: $CAP%" ;;
		    6[0-9]|5[0-9])	echo "$num: $CAP%" ;;
		    4[0-9]|3[0-9])	echo "$num: $CAP%" ;;
		    *)		echo "$num: $CAP%" ;;
		esac
	esac
    done
}


volume() {
    amixer get Master | grep -o "[0-9]*%\|\[on\]\|\[off\]" | sed "s/\[on\]//;s/\[off\]//"
}

network() {
    set -x
    grep "^\s*w" /proc/net/wireless | awk '{ print "", int($3 * 100 / 70) "%" }'
    sed "s/down//;s/up//" /sys/class/net/e*/operstate
    set +x
}

groups() {
    cur=$(xprop -root _NET_CURRENT_DESKTOP)
    cur=${cur##* }
    # cur=$((cur+1))
    tot=$(xprop -root _NET_NUMBER_OF_DESKTOPS)
    tot=${tot##* }

    ch='-'
    line=$(printf '%*s ' "$((tot-1))" | tr ' ' "$ch" | sed "s/^\(.\{$cur\}\)./\1+/")
    echo $line
}

music () {
    format=$(mpc -f "[%title%]|[%file%]" 2>/dev/null)
    name=$(printf '%s' "$format" | head -n 1)
    name="${name##*/}"
    status="$(printf '%s' "$format" | grep -o "\[playing\]\|\[paused\]" | tr '\n' ' ' | sed "s/\[playing\]//;s/\[paused\]//")"

    [ ${#name} -ge 60 ] && printf '%s' "$(printf '%s' "$name" | cut -b 1-60)... $status" || printf '%s' "$name $status"
}

# This loop will fill a buffer with our infos, and output it to stdout.

update () {
    BAR_INPUT="%{l}$(groups) $delim $(title)%{r}$(music) $delim $(volume) $delim $(network) $delim $(battery) $delim $(clock)"
    set -x
    echo "$BAR_INPUT" | tr '\n' ' '
    set +x
    wid=$(xdo id -a "hjcbar")
    xdo above -t "$(xdo id -N Bspwm -n root | sort | head -n 1)" "$wid"
}

while :; do
    update
    sleep 1m &
    wait
done
