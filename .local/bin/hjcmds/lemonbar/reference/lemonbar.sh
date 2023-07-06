#!/bin/sh

# Just a simple Lemonbar script
# Only clickable workspaces, window title, and clock
# Spamming command every second using shell to generate statusline is not really efficient
# So I only put those three items
# If I need other status informations
# I'd rather to call them using Dunst

# Workspace indicator is generated using bspc subscribe
# Which only update if there is an reaction on bspwm
# Window title is generated using xtitle
# Which also has subscribe event ability
# Clock is generated using looped date command
# Only update every thirty seconds

# Based on default example from Bspwm GitHub repository
# Some parts are modified to make them look like what i want
# Cheers! Addy

# . "${HOME}/.cache/wal/colors.sh"

trap 'update' 35

foreground=#ebdbb2
background=#282828
color0=#181818
color1=#fc514e
color2=#a1b56c
color3=#f7ca88
color4=#7cafc2
color5=#ba8baf
color6=#86c1b9
color7=#d8d8d8

FOREGROUND="$foreground"
BACKGROUND="$background"
BLACK="$color0"
RED="$color1"
GREEN="$color2"
YELLOW="$color3"
BLUE="$color4"
MAGENTA="$color5"
CYAN="$color6"
WHITE="$color7"

delim='|'


# Panel configurations
PANEL_HEIGHT=24
# PANEL_WIDTH=920
# PANEL_HORIZONTAL_OFFSET=180
PANEL_VERTICAL_OFFSET=3
# PANEL_FONT="*-fixed-medium-r-n*--13-120-75-*-iso1*-1"
PANEL_FONT="*-ibm-plex-mono-r-n*--13-120-75-*-iso1*-1"
PANEL_FIFO=/tmp/panel-fifo
PANEL_WM_NAME=bspwm_panel
COLOR_DEFAULT_FG="$FOREGROUND"
COLOR_DEFAULT_BG="$BACKGROUND"
COLOR_MONITOR_FG="$BACKGROUND"
COLOR_MONITOR_BG="$WHITE"
COLOR_FOCUSED_MONITOR_FG="$FOREGROUND"
COLOR_FOCUSED_MONITOR_BG="$CYAN"
COLOR_FREE_FG="$FOREGROUND"
COLOR_FREE_BG="$BACKGROUND"
COLOR_FOCUSED_FREE_FG="$FOREGROUND"
COLOR_FOCUSED_FREE_BG="$BLUE"
COLOR_OCCUPIED_FG="$FOREGROUND"
COLOR_OCCUPIED_BG="$RED"
COLOR_FOCUSED_OCCUPIED_FG="$FOREGROUND"
COLOR_FOCUSED_OCCUPIED_BG="$BLUE"
COLOR_URGENT_FG="$FOREGROUND"
COLOR_URGENT_BG="$YELLOW"
COLOR_FOCUSED_URGENT_FG="$FOREGROUND"
COLOR_FOCUSED_URGENT_BG="$YELLOW"
COLOR_STATE_FG="$BACKGROUND"
COLOR_STATE_BG="$BACKGROUND"
COLOR_TITLE_FG="$FOREGROUND"
COLOR_TITLE_BG="$BACKGROUND"
COLOR_DATE_FG="$FOREGROUND"
COLOR_DATE_BG="$BACKGROUND"
COLOR_BAT_FG="$FOREGROUND"
COLOR_BAT_BG="$BACKGROUND"
COLOR_NET_FG="$FOREGROUND"
COLOR_NET_BG="$BACKGROUND"
COLOR_VOL_FG="$FOREGROUND"
COLOR_VOL_BG="$BACKGROUND"
COLOR_WEATHER_FG="$FOREGROUND"
COLOR_WEATHER_BG="$BACKGROUND"
COLOR_SYSTEM_FG="$FOREGROUND"
COLOR_SYSTEM_BG="$BACKGROUND"

[ -e "$PANEL_FIFO" ] && rm "$PANEL_FIFO"
mkfifo "$PANEL_FIFO"

calc () { awk "BEGIN { print int($*) }"; }

clock () {
    while true; do
	echo "D%{A3:$TERMINAL -e calcurse &:}$(date '+%b-%d %H:%M')%{A3}"
        sleep 60
    done
}


volume() {
    while true; do
	echo "V$(amixer get Master | grep -o "[0-9]*%\|\[on\]\|\[off\]" | sed "s/\[on\]//;s/\[off\]//")"
	sleep 60
    done
}


network() {
    while true; do
	echo "N%{A3:$TERMINAL -e nmtui &:}$(printf '%s ' "$(grep "^\s*w" /proc/net/wireless | awk '{ print "", int($3 * 100 / 70) "%" }')" "$(sed "s/down/❌/;s/up//;s/unknown//" /sys/class/net/e*/operstate)")%{A3}"
	sleep 30
    done
}

music () {
    while true; do
	format=$(mpc -f "[%title%]|[%file%]" 2>/dev/null)
	name=$(printf '%s' "$format" | head -n 1)
	name="${name##*/}"
	status="$(printf '%s' "$format" | grep -o "\[playing\]\|\[paused\]" | tr '\n' ' ' | sed "s/\[playing\]//;s/\[paused\]//")"
	time="$(printf '%s' "$format" | grep -o "[0-9]*:[0-9]*/[0-9]*:[0-9]*")"

	[ ${#name} -ge 60 ] && echo "M$time $(echo "$name" | cut -b 1-60)... $status" || echo "M$time $name $status"
	sleep 1
    done
}

battery () {
    while true; do
	for x in /sys/class/power_supply/BAT?; do
	    num="${x##*BAT}"
	    AC="$(cat $x/status)"
	    CAP="$(cat $x/capacity)"
	    case $AC in
		"Charging") echo "B$num:  $CAP%" ;;
		*)
		    case "$CAP" in
			100|9[0-9])	echo "B$num:  $CAP%" ;;
			8[0-9]|7[0-9])	echo "B$num:  $CAP%" ;;
			6[0-9]|5[0-9])	echo "B$num:  $CAP%" ;;
			4[0-9]|3[0-9])	echo "B$num:  $CAP%" ;;
			*)		echo "B$num:  $CAP%" ;;
		    esac
	    esac
	done
	sleep 5
    done
}

system () {
    while true; do
	read -r name user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
	total=$((user+nice+system+idle+iowait+irq+softirq+steal+guest+guest_nice))
	idle=$((idle+iowait+irq))
	[ -z $pretotal ] && pretotal=$((total-1))
	[ -z $preidle ] && preidle=$((idle-1))
	cpu=" $(calc "(($total-$pretotal)-($idle-$preidle))/($total-$pretotal)*100")%"
	pretotal=$total
	preidle=$idle
	memory=" $(free -h | sed -n '2{p;q}' | cut -d ' ' -f 19)"
	echo "S%{A3:$TERMINAL -e htop &:}$memory $cpu%{A3}"
	sleep 1
    done
}


weather () {
    [ "$(stat -c %y "$HOME/.local/share/weatherreport" 2>/dev/null | cut -d' ' -f1)" = "$(date '+%Y-%m-%d')" ] ||
	(ping -q -c 1 1.1.1.1 >/dev/null && curl -s "wttr.in/$location" > "$HOME/.local/share/weatherreport") &&
	echo "L%{A3:$TERMINAL -e less $HOME/.local/share/weatherreport &:}$(sed '16q;d' "$HOME/.local/share/weatherreport" | grep -wo "[0-9]*%" | sort -n | sed -e '$!d' | sed -e "s/^/ /g" | tr -d '\n' &&
	sed '13q;d' "$HOME/.local/share/weatherreport" | grep -o "m\\(-\\)*[0-9]\\+" | sort -n -t 'm' -k 2n | sed -e 1b -e '$!d' | tr '\n|m' ' ' | awk '{print " ",$1 "°","",$2 "°"}')%{A3}"
}

# Just to make sure there is no double process
killall -9 lemonbar xtitle xdo clock battery volume music weather system

# Echo every modules to PANEL_FIFO
clock > "$PANEL_FIFO" &
battery > "$PANEL_FIFO" &
volume > "$PANEL_FIFO" &
music > "$PANEL_FIFO" &
network > "$PANEL_FIFO" &
weather > "$PANEL_FIFO" &
system > "$PANEL_FIFO" &
xtitle -t 30 -sf 'T%s\n' > "$PANEL_FIFO" &
bspc subscribe report > "$PANEL_FIFO" &
num_mon=$(bspc query -M | wc -l)

# Then read those value
panel_bar() {
while read -r line ; do
    case $line in
	D*) date="%{F$COLOR_DATE_FG}%{B$COLOR_DATE_BG}%{A3:$TERMINAL -e calcurse &:} ${line#?} %{A3}%{B-}%{F-}" ;;
	B0*) bat0="%{F$COLOR_BAT_FG}%{B$COLOR_BAT_BG} ${line#?} %{B-}%{F-}" ;;
	B1*) bat1="%{F$COLOR_BAT_FG}%{B$COLOR_BAT_BG} ${line#?} %{B-}%{F-}" ;;
	V*) vol="%{F$COLOR_VOL_FG}%{B$COLOR_VOL_BG} ${line#?} %{B-}%{F-}" ;;
	N*) net="%{F$COLOR_NET_FG}%{B$COLOR_NET_BG} ${line#?} %{B-}%{F-}" ;;
	M*) song="%{F$COLOR_NET_FG}%{B$COLOR_NET_BG} ${line#?} %{B-}%{F-}" ;;
	T*) title="%{F$COLOR_TITLE_FG}%{B$COLOR_TITLE_BG} ${line#?} %{B-}%{F-}" ;;
	L*) weather="%{F$COLOR_WEATHER_FG}%{B$COLOR_WEATHER_BG} ${line#?} %{B-}%{F-}" ;;
	S*) system="%{F$COLOR_SYSTEM_FG}%{B$COLOR_SYSTEM_BG} ${line#?} %{B-}%{F-}" ;;
	W*)
	    # workspaces output
	    wm=
	    IFS=':'
	    set -- ${line#?}
	    while [ $# -gt 0 ] ; do
		item=$1
		name=${item#?}
		case $item in
		    [mM]*)
			case $item in
			    m*)
				# monitor
				FG=$COLOR_MONITOR_FG
				BG=$COLOR_MONITOR_BG
				on_focused_monitor=
				;;
			    M*)
				# focused monitor
				FG=$COLOR_FOCUSED_MONITOR_FG
				BG=$COLOR_FOCUSED_MONITOR_BG
				on_focused_monitor=1
				;;
			esac
			[ $num_mon -lt 2 ] && shift && continue
			wm="${wm}%{F${FG}}%{B${BG}}%{A:bspc monitor -f ${name}:} ${name} %{A}%{B-}%{F-}"
			;;
		    [fFoOuU]*)
			case $item in
			    f*)
				# free desktop
				FG=$COLOR_FREE_FG
				BG=$COLOR_FREE_BG
				UL=$BG
				;;
			    F*)
				if [ "$on_focused_monitor" ] ; then
				    # focused free desktop
				    FG=$COLOR_FOCUSED_FREE_FG
				    BG=$COLOR_FOCUSED_FREE_BG
				    UL=$BG
				else
				    # active free desktop
				    FG=$COLOR_FREE_FG
				    BG=$COLOR_FREE_BG
				    UL=$COLOR_FOCUSED_FREE_BG
				fi
				;;
			    o*)
				# occupied desktop
				FG=$COLOR_OCCUPIED_FG
				BG=$COLOR_OCCUPIED_BG
				UL=$BG
				;;
			    O*)
				if [ "$on_focused_monitor" ] ; then
				    # focused occupied desktop
				    FG=$COLOR_FOCUSED_OCCUPIED_FG
				    BG=$COLOR_FOCUSED_OCCUPIED_BG
				    UL=$BG
				else
				    # active occupied desktop
				    FG=$COLOR_OCCUPIED_FG
				    BG=$COLOR_OCCUPIED_BG
				    UL=$COLOR_FOCUSED_OCCUPIED_BG
				fi
				;;
			    u*)
				# urgent desktop
				FG=$COLOR_URGENT_FG
				BG=$COLOR_URGENT_BG
				UL=$BG
				;;
			    U*)
				if [ "$on_focused_monitor" ] ; then
				    # focused urgent desktop
				    FG=$COLOR_FOCUSED_URGENT_FG
				    BG=$COLOR_FOCUSED_URGENT_BG
				    UL=$BG
				else
				    # active urgent desktop
				    FG=$COLOR_URGENT_FG
				    BG=$COLOR_URGENT_BG
				    UL=$COLOR_FOCUSED_URGENT_BG
				fi
				;;
			esac
			wm="${wm}%{F${FG}}%{B${BG}}%{U${UL}}%{+u}%{A:bspc desktop -f ${name}:} ${name} %{A}%{B-}%{F-}%{-u}"
			;;
		    # [LTG]*)
			# # layout, state and flags
			# wm="${wm}%{F$COLOR_STATE_FG}%{B$COLOR_STATE_BG} ${name} %{B-}%{F-}"
			# ;;
		esac
		shift
	    done
	    ;;
    esac
    set -x
    printf "%s" "%{l}${wm} $delim ${system} $delim ${title}%{r}${song}${vol} $delim ${weather} $delim ${net} $delim ${bat0} ${bat1} $delim ${date}"
    set +x
done
}

# Get all the results of the modules above then pipe them to Lemonbar
update () {
    panel_bar < "$PANEL_FIFO" | lemonbar -a 50 \
    -g "$PANEL_WIDTH"x"$PANEL_HEIGHT"+"$PANEL_HORIZONTAL_OFFSET"+"$PANEL_VERTICAL_OFFSET" \
    -f "$PANEL_FONT" -f "DejaVu Sans Mono" -f "Noto Sans CJK TC" -f "IPAGothic"  -f  "Font Awesome" -F "$COLOR_DEFAULT_FG" -B "$COLOR_DEFAULT_BG" -n "$PANEL_WM_NAME" | sh &
}
update

sleep 0.5
# Trigger the PANEL_FIFO to make it instantly refreshed after bspwmrc reloaded
echo "dummy" > "$PANEL_FIFO"

sleep 0.5
# Rule the panel to make it hiding below fullscreen window
# I add 'sleep 0.5' to avoid xdo executed before the Lemonbar fully loaded
wid=$(xdo id -a "$PANEL_WM_NAME")
xdo above -t "$(xdo id -N Bspwm -n root | sort | head -n 1)" "$wid"

# Don't close this process
wait
