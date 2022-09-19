#!/bin/bash

declare full_hash=$1
declare short_hash=$(git rev-parse --short ${full_hash})

# `nl`: number pf all lines.
declare pos_rebase=$(git rev-list HEAD | nl | grep ${short_hash} | awk '{ print $1 }')
if (( ${pos_rebase} == 0 )); then
  pos_rebase=$(git rev-list --abbrev-commit HEAD | nl | grep ${short_hash} | awk '{ print $1 }')
fi
git rebase -i HEAD~${pos_rebase}
