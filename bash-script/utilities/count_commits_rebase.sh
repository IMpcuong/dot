#!/bin/bash

declare full_hash=$1
declare short_hash=$(git rev-parse --short ${full_hash})

# `nl`: number pf all lines.
declare pos_rebase=$(git rev-list HEAD | nl | grep ${short_hash} | awk '{ print $1 }')
git rebase -i HEAD~${pos_rebase}
