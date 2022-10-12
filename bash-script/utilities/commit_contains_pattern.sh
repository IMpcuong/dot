#!/bin/bash

# NOTE: `<pattern>` also including regex/regex-extend standard.
declare -x pattern=$1
[[ "$pattern" != "" ]] || { echo "Please passing pattern as an argument to continue!" 2>&1; exit; }
declare -i count=0

declare -a patternHolder
declare -x commits=$(git log --oneline | awk '{ print $1 }')
for commit in $commits; do
  declare -x matched=$(git show --no-notes --pretty="%h" "$commit" | LC_ALL=C grep -iE "$pattern")
  [[ "$matched" == "" ]] || echo $commit
done