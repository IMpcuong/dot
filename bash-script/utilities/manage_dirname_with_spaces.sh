#!/bin/bash

# Resource: https://www.cyberciti.biz/tips/handling-filenames-with-spaces-in-bash.html

# Exp1: Using `du` to measure all directories that were existing in our current location.
find . -maxdepth 1 -type d ! -empty -regex ".*[^[:space:]*].*" | xargs du -h --max-depth=1

# Exp2: Using `find -print0` option to extricate/bring-out full dirname to stdout, followed by a null character.
# + `\0` := Identical with null-character/terminate-character in Bash (and Bash had been written by C).
find . -maxdepth 1 -type d -print0 | while read -d $'\0' dir; do
  du -h --max-depth=1 $dir
done

# Exp3: Messing around with `read` command.
while IFS=: read userName passWord userID groupID geCos homeDir userShell; do
  echo "$userName -> $homeDir"
done </etc/passwd

# Exp4: This example was not offically be compeleted (or incomplete/flawed/unfinished).
IFS=$'\n' read -d '' -r arr <<<$(find . -maxdepth 1 -type d -print0)
for d in ${arr[@]}; do echo $d; done
