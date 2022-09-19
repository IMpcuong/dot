#!/bin/bash

declare pattern=$1

declare filePath=$(grep -nr "$pattern" | cut -d':' -f1)
declare pos=$(grep -nr "$pattern" | cut -d':' -f2)

declare arrPath=($filePath)
declare arrPos=($pos)

for i in ${!arrPos[@]}; do
  git blame -L ${arrPos[$i]},${arrPos[$i]} -- ${arrPath[$i]}
done