#! /bin/sh -e

parse_wspcstat() {
    while [ $# -gt 0 ]; do
        item="$1"
        name="${item#?}"
        case "$item" in
            [fFoOuU]*)
                case "$item" in
                    [FOU]*) UL="#e7e7e7" ;;
                    [fou]*) UL="#181818" ;;
                esac
                desktops="${desktops}%{A:bspc desktop -f ${name}:}%{U${UL}}%{+u}${name}%{-u}%{U-} %{A}"
                ;;
        esac
        shift
    done
    printf "S %s\n" "${desktops}"
    unset desktops
}

bspc subscribe | awk '$0!=l { print; l=$0; fflush() }' | while read -r line; do
    arguments="$(echo "${line#?}" | tr ':' ' ')"
    eval "parse_wspcstat $arguments"
done