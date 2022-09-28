#!/bin/bash

# Exp1: Retrieves multiple sections/chunks from all files existed in the current directory:
ls -la | \
  grep '^-' | \
  awk '{ print $9 }' | \
  xargs -I {} sh -c 'head -1 {}; tail -10 {}' | \
  less