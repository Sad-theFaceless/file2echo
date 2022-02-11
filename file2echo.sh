#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Syntax: $0 FILE"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "Invalid file." >&2
    exit 2
fi

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
    echo -ne "$(( (number*100)/number_total ))%\r" >&2
done < "$1"

command="$command'"

echo -E "$command"
