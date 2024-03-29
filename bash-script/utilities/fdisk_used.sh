#!/bin/sh

set +x

declare -x used_disk=$(
  df -h |
    awk '{ if ($3 > 0) print $0; }' |
    wc -l
)

echo -e "Number of file system disks that have been used: $((used_disk - 1))"

set -x
