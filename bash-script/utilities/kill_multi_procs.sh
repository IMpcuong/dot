#!/bin/bash

# NOTE: pidof <image_name>/<app_name>

declare proc=$( ps aux | awk '{ print $2, $11 }' OFS='\t' | grep $1 )
# NOTE:
# + With `$1 = python`
# + `echo $proc` -> stdout := "1142 python 27263 python 58476 python"
# -> The PID has been only located in the odd index ~ 2n + 1, n >= 0

declare mixtureArr=($proc)
declare -i arrLen=${#mixtureArr[@]}

# Solution1:
for (( i = 0; i < $arrlen; i++ )); do
  if (( $i % 2 == 0 )); then
    kill -9 ${mixtureArr[$i]}
  fi
done

# Solution2:
for i in ${!mixtureArr[@]}; do
  if (( $i % 2 == 0 )); then
    kill -9 ${mixtureArr[$i]}
  fi
done