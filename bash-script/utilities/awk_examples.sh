#!/bin/bash

# `$3` := Column 3 = Total amount of used disk space.
# `$0` := All the fields.
df -h | awk '{ if ($3 > 0) { print $0 } }'

# `awk` examples:

# Assigned variable:
# `BEGIN` pattern: means that Awk will execute the action(s) specified in `BEGIN` once before any input lines are read.
# `END` pattern: means that Awk will execute the action(s) specified in `END` before it actually exits.
awk 'BEGIN { cnt = 2; cnt ^= 4; print "Counter =", cnt }'

# Logical:
awk 'BEGIN { name = ""; if (!length(name)) print "$name is an empty string!" }'
# Both of these conventions in the `awk` command below returning the same result:
# NOTE: `-v <assignment>` := declaration of a new variable.
awk 'BEGIN { \
  ch = "\n"; if (ch == " " || ch == "\t" || ch == "\n") \
  print "Current character is whitespace." \
}'
awk -v ch="\n" 'BEGIN { \
  if (ch == " " || ch == "\t" || ch == "\n") \
  print "Current character is whitespace." \
}'

# String concatenation:
awk 'BEGIN { str1 = "Hello, "; str2 = "World"; str3 = str1 str2; print str3 }'

# Ternary and unary:
awk 'BEGIN { a = 10; b = 20; (a > b) ? max = a : max = b; print "Max =", max}'
awk 'BEGIN { a = -10; a = -a; print "a =", a }'

# Exponential:
awk 'BEGIN { a = 10; a = a**2; print "a =", a }'
awk 'BEGIN { a = 10; a = a^2; print "a =", a }'

# Regex: the pattern must be declared inside the `/.*/` block.
echo -e "knife\nknow\nfun\nfin\nfan\nnine" | awk '/n$/'

# Loop:
awk 'BEGIN { for (i = 1; i <= 5; ++i) print i }'
awk 'BEGIN { i = 1; do { print i; ++i } while (i < 6) }'
awk 'BEGIN { \
  sum1 = 0; sum2 = 0; sum3 = 0;
  for (i = 0; i < 20; ++i) { \
    sum1 += i; if (sum1 % 2 == 2) print "Sum1 =", sum1; else continue; \
    sum2 += i; if (sum2 > 50) exit(10); else print "Sum2 =", sum2; \
    sum3 += i; if (sum3 > 50) break; else print "Sum3 =", sum3; \
  } \
}'
awk 'BEGIN { sum = 0; for (i = 0; i < 20; i++) { sum += i; if (sum % 2 == 0) print sum; else continue } }'

# Backward loop using `awk`:
awk '{ lines[NR] = $0 } END { for (i = NR; i >= 1; --i) print lines[i] }' reverse-me.txt # `tac reverse-me.txt`.

# Compare wildcare string:
awk 'BEGIN { app = "dude"; if (app ~ /^du.*/) print app; }'
awk '{ app = "dude"; if (app ~ /^du.*/) print app; }'

# NOTE:
# + `-F <fs>, --field-separator <fs>` := Use <fs> for the input field separator (the value of the FS predefined variable).
# + `awk` can be executed on data stream directly from `stdin` or from file input stream.
awk -F '|' "{ print $1 > $2 > $3 }" ~/tmp/test_fs.txt
awk -F '|' "{ print $1 > $2 > $3 }" <~/tmp/test_fs.txt
