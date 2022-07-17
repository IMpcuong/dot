#!/bin/bash

local full_hash=$1
local short_hash=$(git rev-parse --short ${full_hash})

# `nl`: number pf all lines.
local pos_rebase=$(git rev-list HEAD | nl | grep ${short_hash} | awk '{ print $1 }')
git rebase -i HEAD~${pos_rebase}
