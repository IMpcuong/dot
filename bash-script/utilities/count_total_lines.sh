#!/bin/bash

declare fileName=$1
declare cmd=$2
declare -i lines=0

case $cmd in
  "cat")
    lines=$(cat $fileName | wc -l)
    echo -ne "$lines\n"
    ;;

  "awk")
    lines=$(awk 'END { print NR }' $fileName)
    echo -ne "$lines\n"
    ;;

  "sed")
    lines=$(sed -n "$=" $fileName)
    echo -ne "$lines\n"
    ;;

  "grep")
    # Or: `grep -e "$"`
    lines=$(grep -e "^" --count $fileName)
    echo -ne "$lines\n"
    ;;

  "tail")
    lines=$(cat -n $fileName | tail -n1 | awk '{ print $1 }')
    echo -ne "$lines\n"
    ;;
esac

if (( "$lines" == 0 )); then lines=1; fi

# NOTE: example about utilize the line numbers extract from a file.
sed -n "${lines}p" $1
