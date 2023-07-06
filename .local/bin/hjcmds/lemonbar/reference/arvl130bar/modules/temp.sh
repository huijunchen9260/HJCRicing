#! /bin/sh -e

THR_FULL=
THR_TRFR=
THR_HALF=
THR_QRTR=
THR_ZERO=

while :; do
    temp_curr="$(sensors | awk '/temp1/ {print $2}')"

    [ "$temp_curr" != "$temp_last" ] && {
        temp_last="$temp_curr"
        temp_curr="${temp_curr#?}"
        temp_curr="${temp_curr%.*}"
        case "$temp_curr" in
             [0-9]|1[0-9])  temp_icon="$THR_ZERO" ;; #  0-19
            2[0-9]|3[0-9])  temp_icon="$THR_QRTR" ;; # 20-39
            4[0-9]|5[0-9])  temp_icon="$THR_HALF" ;; # 40-59
            6[0-9]|7[0-9])  temp_icon="$THR_TRFR" ;; # 60-79
            *)              temp_icon="$THR_FULL" ;; # 80-100
        esac
        printf "T %s \n" "$temp_icon $temp_curr°C"
    }

    sleep "${POLLING_RATE:-2}"
done