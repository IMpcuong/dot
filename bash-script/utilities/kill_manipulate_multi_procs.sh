#!/bin/bash

# NOTE: pidof <image_name>/<app_name>

declare proc=$(ps aux | awk '{ print $2, $11 }' OFS='\t' | grep $1)
# NOTE:
# + With `$1 = python`
# + `echo $proc` -> stdout := "1142 python 27263 python 58476 python"
# -> The PID has been only located in the odd index ~ 2n + 1, n >= 0

declare -a mixtureArr=($proc)
declare -i arrLen=${#mixtureArr[@]}
if test "$arrLen" -eq 0; then
  proc=$(pidof $1)
  mixtureArr=($proc)
fi

# Solution1:
for ((i = 0; i < $arrlen; i++)); do
  if (($i % 2 == 0)); then
    kill -9 ${mixtureArr[$i]}
  fi
done

# Solution2:
for i in ${!mixtureArr[@]}; do
  if (($i % 2 == 0)); then
    # NOTE: Print out each process's statistics with some advance options.
    # `-f`: Do full-format listing, This option can be combined with many other UNIX-style options to add additional columns.
    #     When used with -L/l, the NLWP (number of threads) and LWP (thread ID) columns will be added.
    #     `-F` option was implied from its normal-case literal option.
    # `-w`: Use 132 columns to display information, instead of the default which is your window size
    ps -Flw -p ${mixtureArr[$i]}
    kill -9 ${mixtureArr[$i]}
  fi
done

# NOTE: Collects specified columns from the process manager output.
ps aux
ps -ef
ps -eo pcpu,pmem,args
