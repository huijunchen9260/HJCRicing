#! /bin/sh -e

src_dir="$HOME"/.cache
src_file="$src_dir"/corona_tracker.cache

show_help_message() {
    cat << EOF
Usage: "$0"  [options]
    -s, --show  Show the current COVID-19 status.
    -h, --help  Show this help message.
EOF
}

get_covidstatus() {
    printf 'D  %s±i \n' "$(cat "$src_file")"
}
update_covidstatus() {
    printf "Updating COVID19 status..."
    if ping -c 5 1.1.1.1 > /dev/null 2>&1 && curl "https://corona-stats.online/PH?minimal=true" -so "$src_file"; then
        awkout="$(awk '/PH/ {print $6}' "$src_file" )"
        awkout="${awkout#?????}"
        awkout="$(echo "$awkout" | sed 's/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&'"'"'()*+,.\/]*[][\\@A-Z^_`a-z{|}~]//g')"
        printf '%s\n' "$awkout" > "$src_file"
        printf " done.\n"
    else
        printf " something went wrong. :(\n"
        exit 1
    fi
}
monitor_covidstatus() {
    "$(readlink -f "$0")" -s
    find "$src_file" | entr -p "$(readlink -f "$0")" -s
}

case "$1" in
    -h|--help)
        show_help_message
        ;;
    -s|--show)
        get_covidstatus
        ;;
    -u|--update)
        update_covidstatus
        ;;
    *)  
        monitor_covidstatus
        ;;
esac