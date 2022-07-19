#!/bin/bash

chmod 744 ./all_args.sh

# Resource: https://linuxconfig.org/how-do-i-print-all-arguments-submitted-on-a-command-line-from-a-bash-script

if [[ "$#" != 2 ]]; then
  echo "[Error] Not enough arguments"
  exit 1
fi

# Solution1:
echo "$@"

# Solution2:
for i; do
  echo $i
done

# Solution3:
for i in "$*"; do
  echo $i
done

# Solution4:
while (( "$#" )); do
  echo $1
  shift
done

# Solution5:
args=($*)
for ((i = 0; i < ${#args[@]}; ++i)); do
  echo "The argument number $((i+1)): ${args[i]}"
  # Another approach, have the same result: echo "The argument number $((i+1)): ${args[$i]}"
done

# FIXME: `stdout` display an infinite loop.
echo "$1 $2" | awk '{ print $2, $1 }' | xargs ./all_args.sh