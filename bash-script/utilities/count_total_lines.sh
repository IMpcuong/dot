#!/bin/bash

declare fileName=$1
declare cmd=$2
declare lines=0

case $cmd in
  "cat")
    lines=$(cat $fileName | wc -l)
    echo -n $lines
    ;;

  "awk")
    lines=$(awk 'END { print NR }' $fileName)
    echo -n $lines
    ;;

  "sed")
    lines=$(sed -n "$=" $fileName)
    echo $lines
    ;;

  "grep")
    lines=$(grep -e "^|$" --count $fileName)
    echo $lines
    ;;

  "tail")
    lines=$(cat -n $fileName | tail -n1)
    echo $lines
    ;;

# NOTE: example about utilize the line numbers extract from a file.
sed -n "4,${lines}p" $fileName