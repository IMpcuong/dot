#!/bin/bash

# `$3` := Column 3 = Total amount of used disk space.
# `$0` := All the fields.
df -h | awk '{ if($3 > 0) { print $0 } }'