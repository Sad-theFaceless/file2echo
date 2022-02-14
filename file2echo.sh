#!/bin/bash

enable_auto_updates=true #Set to 'false' to disable auto updates

auto_update () {
    if wget -V > /dev/null 2>&1; then
        if ! file_network=$(wget -qO- "$1"); then
            return 1
        fi
    elif curl -V > /dev/null 2>&1; then
        if ! file_network=$(curl -fsSL "$1"); then
            return 1
        fi
    else
        # wget and curl not found, can't check for update
        return 2
    fi
    hash_local=$(md5sum "$2" | awk '{ print $1 }')
    hash_network=$(echo -E "$file_network" | md5sum | awk '{ print $1 }')
    if [[ "$hash_local" != "$hash_network" ]]; then
        tmpfile=$(mktemp "${2##*/}".XXXXXXXXXX --tmpdir)
        echo -E "$file_network" > "$tmpfile"
        chown --reference="$2" "$tmpfile"
        chmod --reference="$2" "$tmpfile"
        mv "$tmpfile" "$2"
        exec "${@:2}"
    fi
}

parsing () {
    if [ $# -ne 1 ]; then
        echo "Syntax: $0 FILE"
        exit 1
    fi

    if [ ! -f "$1" ]; then
        echo "Invalid file." >&2
        exit 2
    fi
}

main () {
    number=0
    number_total=$(wc -m < "$1")

    command="echo -ne '"

    while read -rN1 ch; do
        case "$ch" in
            "'" )
                command="$command'\''" ;;
            "\\" )
                command="$command\\\\" ;;
            $'\a' )
                command="$command\\a" ;;
            $'\b' )
                command="$command\\b" ;;
            $'\e' )
                command="$command\\e" ;;
            $'\f' )
                command="$command\\f" ;;
            $'\n' )
                command="$command\\n" ;;
            $'\r' )
                command="$command\\r" ;;
            $'\t' )
                command="$command\\t" ;;
            $'\v' )
                command="$command\\v" ;;
            [^[:print:]] )
                echo "Unknown non-printable character found... abort." >&2
                exit 3 ;;
            * )
                command="$command$ch" ;;
        esac
        number="$(( number+1 ))"
        echo -ne "\r$(( (number*100)/number_total ))%" >&2
    done < "$1"
    echo -ne "    \r" >&2

    command="$command'"
}

if [ "$enable_auto_updates" = true ] ; then
    auto_update "https://raw.githubusercontent.com/Sad-theFaceless/file2echo/main/file2echo.sh" "$0" "$@"
fi
parsing "$@"
command=""
main "$1"
echo -E "$command"

exit 0
