#! /bin/sh -e

VOLM_LOUD=""
VOLM_SOFT=""
VOLM_ZERO=""
VOLM_MUTE="×"

get_volm() {
    volm_state="$(amixer get Master | sed -n 'N;s/^.*\[\([a-z]*\).*$/\1/p')"
    if [ "$volm_state" = "on" ]; then
        volm_level="$(amixer get Master | sed -n 'N;s/^.*\[\([0-9][0-9]*\).*$/\1/p')"
        case "$volm_level" in
            [5-9][0-9]|1[0-4][0-9]|15[0-3])
                volm_icon="$VOLM_LOUD"
                ;;
            [1-9]|[1-4][0-9])
                volm_icon="$VOLM_SOFT"
                ;;
            0)
                volm_icon="$VOLM_ZERO"
                ;;
        esac
        volm_level="$volm_level%"
    else
        volm_icon="$VOLM_MUTE"
        volm_level="muted"
    fi
    volm_curr="$volm_icon $volm_level"
    if [ "$volm_curr" != "$volm_last" ]; then
        printf "V %s \n" "$volm_curr"
        volm_last="$volm_curr"
    fi
    unset volm_level
}

get_volm

while true; do # restart loop if it fails unexpectedly
    stdbuf -oL alsactl monitor default | awk '/Playback Switch/ || /Playback Volume/ { print; fflush() }' | while read -r; do
        get_volm
    done
done