#!/bin/bash

# From: https://superuser.com/a/1330590
# Removes old revisions of snaps.
# CLOSE ALL SNAPS BEFORE RUNNING THIS.

LANG=C snap list --all | awk '{ if ($6 ~ /disabled/) print $1, $3 }' |
  while read snapname rev; do
    snap remove "$snapname" --rev="$rev"
  done

sudo snap set system refresh.retain=2
