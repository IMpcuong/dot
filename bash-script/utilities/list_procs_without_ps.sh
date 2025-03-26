#!/bin/bash

ls -l /proc/*/exe
for prc in /proc/*/cmdline; {
  (printf "$prc "; cat -A "$prc") | sed 's/\^@/ /g;s|/proc/||;s|/cmdline||'
  echo
}
