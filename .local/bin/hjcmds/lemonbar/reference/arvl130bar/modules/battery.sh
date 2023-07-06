#! /bin/sh -e

CHARGING=
BAT_FULL=
BAT_TRFR=
BAT_HALF=
BAT_QRTR=
BAT_ZERO=
plugstate_dev="/sys/class/power_supply/AC/online"
battstate_dev="/sys/class/power_supply/BAT0/capacity"

read -r plugstate_now < "$plugstate_dev"
read -r battstate_now < "$battstate_dev"
case "$plugstate_now" in
    0)  plugstate_now="yes"
        case "$battstate_now" in
             [0-9]|1[0-9])  batt_icon="$BAT_ZERO" ;; #  0-19
            2[0-9]|3[0-9])  batt_icon="$BAT_QRTR" ;; # 20-39
            4[0-9]|5[0-9])  batt_icon="$BAT_HALF" ;; # 40-59
            6[0-9]|7[0-9])  batt_icon="$BAT_TRFR" ;; # 60-79
            *)              batt_icon="$BAT_FULL" ;; # 80-100
        esac
        ;;
    1)  plugstate_now="no"
        batt_icon="$CHARGING"
        ;;
esac

print_state() {
    printf 'B %s %s \n' "$1" "$2%"
}

print_state "$batt_icon" "$battstate_now"

upower --monitor-detail | awk '/percentage/ || /on-battery/ { print $2; fflush() }' | while read -r line; do
    case "$line" in
        [0-9]%|[1-9][0-9]%|100%)
                battstate_then="$battstate_now"
                battstate_now="${line%\%}"
                [ "$battstate_then" != "$battstate_now" ] && {
                    [ "$plugstate_now" = "yes" ] && {
                        case "$battstate_now" in
                             [0-9]|1[0-9])  batt_icon="$BAT_ZERO" ;; #  0-19
                            2[0-9]|3[0-9])  batt_icon="$BAT_QRTR" ;; # 20-39
                            4[0-9]|5[0-9])  batt_icon="$BAT_HALF" ;; # 40-59
                            6[0-9]|7[0-9])  batt_icon="$BAT_TRFR" ;; # 60-79
                            *)              batt_icon="$BAT_FULL" ;; # 80-100
                        esac
                    }
                    print_state "$batt_icon" "$battstate_now"
                }
                ;;
        yes)    plugstate_then="$plugstate_now"
                plugstate_now="$line"
                [ "$plugstate_then" != "$plugstate_now" ] && {
                    case "$battstate_now" in
                         [0-9]|1[0-9])  batt_icon="$BAT_ZERO" ;; #  0-19
                        2[0-9]|3[0-9])  batt_icon="$BAT_QRTR" ;; # 20-39
                        4[0-9]|5[0-9])  batt_icon="$BAT_HALF" ;; # 40-59
                        6[0-9]|7[0-9])  batt_icon="$BAT_TRFR" ;; # 60-79
                        *)              batt_icon="$BAT_FULL" ;; # 80-100
                    esac
                    print_state "$batt_icon" "$battstate_now"
                }
                ;;
        no)     plugstate_then="$plugstate_now"
                plugstate_now="$line"
                [ "$plugstate_then" != "$plugstate_now" ] && {
                    batt_icon="$CHARGING"
                    print_state "$batt_icon" "$battstate_now"
                }
                ;;
    esac
done