#!/bin/bash

# NOTE: `<pattern>` also including regex/regex-extend standard.
declare -x pattern=$1
[[ "$pattern" != "" ]] || { echo "Please passing pattern as an argument to continue!" 2>&1; exit; }

declare -x depth=${2:-5}
declare -a commits=(`git log --oneline | awk '{ print $1 }'`)
for ((i=0; i<=$depth; i++)); do
  declare -x commit=${commits[$i]}
  declare -x matched=$(git show --no-notes --pretty="%h" "$commit" | LC_ALL=C grep -iE "$pattern")
  [[ "$matched" == "" ]] || { echo ">>>>> Commit:" $commit; git diff-tree -r --no-commit-id --name-only $commit; }
  # [[ "$matched" == "" ]] || { echo ">>>>> Commit:" $commit; git show --name-only $commit --oneline; }
done
