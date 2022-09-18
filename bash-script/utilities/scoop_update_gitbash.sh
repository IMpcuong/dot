#!/bin/bash

# `scoop status` output:

# Scoop is up to date.
#
# Name     Installed Version Latest Version Missing Dependencies Info
# ----     ----------------- -------------- -------------------- ----
# 7zip     21.07             22.01
# bat      0.21.0            0.22.1

scoop status | \
  tail -n +5 | \
  awk '{ if ($2 -ne $3) { print $1 } }' | \
  xargs scoop update
