#!/bin/bash

declare -x svc=$1

if [[ "$svc" == "" ]]; then svc="java"; fi
# NOTE: the pattern `/^ES/` equivalent with the status of connection have been `ESTABLISHED`
# with the remmote host successfully.
#
# + `$4` := local address.
# + `$5` := foreign address.
netstat -tulpan |
  grep -i $svc |
  awk '{ if ($6 ~ /^ES/) print $4 "\t" $5 }'

# NOTE: You can also check the status of the daemon as well.
strings /proc/$(pgrep -n $svc)/status
