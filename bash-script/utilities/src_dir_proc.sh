#!/bin/bash

# Source solution: https://www.baeldung.com/linux/find-working-directory-of-running-process

declare app=$1
declare pids=$(pgrep $app)

for pid in $pids; do
  # Solution1:
  pwdx $pid

  # Solution2:
  # `lsof` := list open files (from a given process-ID).
  lsof -p $pid | grep cwd

  # Solution3:
  readlink -e "/proc/${pid}/cwd"
done