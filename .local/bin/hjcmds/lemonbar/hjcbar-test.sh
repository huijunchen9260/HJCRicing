#!/bin/sh

delim='|'

panel_name=hjcbar

calc () { awk "BEGIN { print $*}"; }

clock () { time=$(date '+%Y-%m-%d %H:%M:%S'); }

title () { title=$(xtitle -t 30); }

volume () { volume=$(amixer get Master | grep -o "[0-9]*%\|\[on\]\|\[off\]" | sed "s/\[on\]//;s/\[off\]//"); }

memory () { memory=" $(free -h | sed -n '2{p;q}' | cut -d ' ' -f 19)"; }

cpu () {
    # update as sleep interval in while loop
    total=$(($(cat -u /proc/stat | head -n 1 | cut -b 6- | tr ' ' '+')))
    idle=$(($(cat -u /proc/stat | head -n 1 | cut -b 6- | cut -d ' ' -f 4,6 | tr ' ' '+')))
    [ -z $pretotal ] && pretotal=$total
    [ -z $preidle ] && preidle=$idle
    # totald=$(calc "$total-$pretotal")
    # idled=$(calc "$idle-$preidle")
    cpu=" $(calc "(($total-$pretotal)-($idle-$preidle))/($total-$pretotal)*100")%"
    pretotal=$total
    preidle=$idle
}


weather () {
        [ "$(stat -c %y "$HOME/.local/share/weatherreport" 2>/dev/null | cut -d' ' -f1)" = "$(date '+%Y-%m-%d')" ]
    	case $? in
    	    0) weather=$(sed '16q;d' "$HOME/.local/share/weatherreport" | grep -wo "[0-9]*%" | sort -n | sed -e '$!d' | sed -e "s/^/ /g" | tr -d '\n' &&
    		sed '13q;d' "$HOME/.local/share/weatherreport" | grep -o "m\\(-\\)*[0-9]\\+" | sort -n -t 'm' -k 2n | sed -e 1b -e '$!d' | tr '\n|m' ' ' | awk '{print " ",$1 "°","",$2 "°"}')
    		;;
    	    *) ping -q -c 1 1.1.1.1 >/dev/null && curl -s "wttr.in/$location" > "$HOME/.local/share/weatherreport"
    		;;
    	esac
}

battery () {
    for x in /sys/class/power_supply/BAT?; do
	num="${x##*BAT}"
	AC="$(cat $x/status)"
	CAP="$(cat $x/capacity)"
	case $AC in
	    "Charging") battery=$(printf '%s' "$battery" " $num: $CAP%") ;;
	    *)
		case "$CAP" in
		    100|9[0-9])	battery=$(printf '%s' "$battery" " $num: $CAP%") ;;
		    8[0-9]|7[0-9]) battery=$(printf '%s' "$battery" " $num: $CAP%") ;;
		    6[0-9]|5[0-9]) battery=$(printf '%s' "$battery" " $num: $CAP%") ;;
		    4[0-9]|3[0-9]) battery=$(printf '%s' "$battery" " $num: $CAP%") ;;
		    *) battery=$(printf '%s' "$battery" " $num: $CAP%") ;;
		esac
	esac
    done
}

network() {
    network=$(printf '%s ' "$(grep "^\s*w" /proc/net/wireless | awk '{ print "", int($3 * 100 / 70) "%" }')" "$(sed "s/down//;s/up//" /sys/class/net/e*/operstate)")
}

groups() {
    cur=$(xprop -root _NET_CURRENT_DESKTOP)
    cur=${cur##* }
    tot=$(xprop -root _NET_NUMBER_OF_DESKTOPS)
    tot=${tot##* }
    wincount=$(xdotool search --all --onlyvisible --desktop $cur "" 2>/dev/null | wc -l)
    monitorlist=$(xrandr --listactivemonitors | tail -n +2 | cut -d ' ' -f 6)

    idle='-'
    active='+'
    ws=$(printf '%*s ' "$((tot-1))" | tr ' ' "$idle" | sed "s/^\(.\{$cur\}\)./\1$active/")
}

music () {
    format=$(mpc -f "[%title%]|[%file%]" 2>/dev/null)
    name=$(printf '%s' "$format" | head -n 1)
    name="${name##*/}"
    status="$(printf '%s' "$format" | grep -o "\[playing\]\|\[paused\]" | tr '\n' ' ' | sed "s/\[playing\]//; s/\[paused\]//")"

    music=$([ ${#name} -ge 60 ] && printf '%s' "$(printf '%s' "$name" | cut -b 1-60)... $status" || printf '%s' "$name $status")
}

# This loop will fill a buffer with our infos, and output it to stdout.

update () {
    # left="${ws} ${wincount} $delim ${title}"
    left="${ws} ${wincount}"
    right="${music} ${volume} $delim ${weather} $delim ${network} $delim ${cpu} ${memory} $delim ${battery} $delim ${time}"
    BAR_INPUT="%{l}${left}%{r}${right}"
    echo "$BAR_INPUT" | tr '\n' ' '
    # Hide bar in full screen
    wid=$(xdo id -a "hjcbar")
    xdo above -t "$(xdo id -N Bspwm -n root | sort | head -n 1)" "$wid"
}

refresh () {
    case "$sig" in
	1) volume; update ;;
	# 3) ; update ;;
	# 6) network; update ;;
	# 14) groups; title; update ;;
	14) groups; update ;;
	15) music; update ;;
	# '') unset title network battery time memory cpu; clock; title; memory; cpu; battery; network; update ;;
	'') unset network battery time memory cpu; clock; memory; cpu; battery; network; update ;;
    esac
    unset sig
}

trap 'sig=1; refresh; update' 1
trap 'sig=3; refresh; update;' 3
trap 'sig=6; refresh; update;' 6
trap 'sig=14; refresh; update;' 14
trap 'sig=15; refresh; update;' 15

# clock; title; volume; memory; cpu; weather; battery; network; groups; music; update
clock; volume; memory; cpu; weather; battery; network; groups; music; update
while :; do
    refresh; update &
    sleep 1 &
    wait
done
