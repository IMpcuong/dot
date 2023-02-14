#!/bin/bash

touch {1..10}.txt
# NOTE: `seq` command's hand-on examples.
# Source: https://linuxhandbook.com/seq-command/
for i in $(seq 1 1 5); do echo $i > $i.txt; done # NOTE: [first, increment, last].
for i in {1..10}; do echo $(($i**$i)) >> $i.txt; done # NOTE: Another acceptable syntax `$((echo 2^100 | bc))`.
for i in {1..10..2}; do let "val = ~(100 >> 2)"; echo $val >> $i.txt; done
for i in {1..10}; do cat $i.txt; done

# NOTE: `let` built-in command used for evaluating arithmetric expression(s).
# Source: https://phoenixnap.com/kb/bash-let
#
# Syntax: `let [expression] ([expression1] ...)`.
# Exp:
let "var1 = 10" "var2 = var1**2"; echo $var2 # 100
let "var2 += 100 << 2"; echo $var2 # 500
let "var1 = 10" "var2 = --var1"; echo $var1 $var2 # 9 9
