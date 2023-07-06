#! /bin/sh -e

HDD_ICON=""

while true; do
    free_curr="$(df -B1 --output='avail' / | numfmt --header --to=iec-i --suffix=B --format="%.1f" --round=up | tail -n 1)"
    [ "$free_curr" != "$free_last" ] && {
        free_last="$free_curr"
        printf "F %s \n" "$HDD_ICON $free_curr"
    }
    sleep "${POLLING_RATE:-2}"
done