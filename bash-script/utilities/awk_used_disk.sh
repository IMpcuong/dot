#!/bin/bash

# `$3` := Column 3 = Total amount of used disk space.
# `$0` := All the fields.
df -h | awk '{ if($3 > 0) { print $0 } }'

# `awk` examples:

# Assigned variable:
awk 'BEGIN { cnt = 2; cnt ^= 4; print "Counter =", cnt }'

# Logical:
awk 'BEGIN { name = ""; if(!length(name)) print "name is empty string." }'
awk 'BEGIN { \
  ch = "\n"; if (ch == " " || ch == "\t" || ch == "\n") \
  print "Current character is whitespace." \
}'

# String concatenation:
awk 'BEGIN { str1 = "Hello, "; str2 = "World"; str3 = str1 str2; print str3 }'

# Ternary and unary:
awk 'BEGIN { a = 10; b = 20; (a > b) ? max = a : max = b; print "Max =", max}'
awk 'BEGIN { a = -10; a = -a; print "a =", a }'

# Exponetial:
awk 'BEGIN { a = 10; a = a**2; print "a =", a }'
awk 'BEGIN { a = 10; a = a^2; print "a =", a }'

# Regex: the pattern must be declared inside the `/.*/` block
echo -e "knife\nknow\nfun\nfin\nfan\nnine" | awk '/n$/'