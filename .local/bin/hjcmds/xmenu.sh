#!/bin/sh

xmenu <<EOF | sh &
Applications
	IMG:./icons/web.png	Web Browser	firefox
	IMG:./icons/gimp.png	Image editor	gimp

touch toggle	[ "$(xinput list-props "Wacom ISDv4 E6 Finger" | grep 'libinput Send Events Mode Enabled (' | awk -F '\t' '{print $NF}')" = '0, 0' ] && xinput set-prop "Wacom ISDv4 E6 Finger" "libinput Send Events Mode Enabled" 1, 0 || xinput set-prop "Wacom ISDv4 E6 Finger" "libinput Send Events Mode Enabled" 0, 0
rotate	tablet-rotate
close
	confirm	xdotool windowkill $(xdotool getactivewindow)
st	st
file manager	thunar
EOF
