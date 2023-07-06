#! /bin/sh -e

WIFI_ICON=""
WIFI_DEV="$(ip link | sed -n 's/^[0-9]: \(.*\):.*$/\1/p' | grep "wl.*" | head -n 1)"

[ -z "$WIFI_DEV" ] && {
    printf "W %s \n" "$WIFI_ICON disabled"
    exit 1
}

get_ssid() {
    ssid_curr="$(iw "$WIFI_DEV" info | awk '/ssid/ {$1=""; print $0}')"
    ssid_curr="${ssid_curr:- disconnected}"
    if [ "$ssid_curr" != "$ssid_last" ]; then
        printf "W %s \n" "$WIFI_ICON$ssid_curr"
        ssid_last="$ssid_curr"
    fi
}

get_ssid

nmcli device monitor 2> /dev/null | awk "/$WIFI_DEV: connected/ || \$0 == \"$WIFI_DEV: disconnected\" || \$0 == \"$WIFI_DEV: unavailable\" && \$0!=l { print \$2; l=\$0; fflush() }" | while read -r; do
    get_ssid
done