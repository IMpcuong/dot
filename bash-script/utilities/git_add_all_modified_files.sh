#!/bin/bash

git status | grep -oE "modified:[[:space:]]+(.*)$" | awk '{ printf $2"\n" }'
  while read f; do
    git add $f;
  done

git status | perl -ne 'm/modified:[[:space:]]+(.*)$/ && print "$1\n"' |
  while read f; do
    git add $f;
  done
