#!/bin/bash

# Exp1: Retrieves multiple sections/chunks from all files existed in the current directory:
ls -la |
  grep '^-' |
  awk '{ print $9 }' |
  xargs -I{} sh -c 'head -1 {}; tail -10 {}' |
  less

# Exp2: Using `journalctl` to check all logs of a process by using PID itself (Process ID):
ps aux |
  grep sshd |
  awk '{ print $2 }' |
  tail -n+1 |
  xargs -I{} sh -c 'journalctl _PID={}'

# Exp3: Download a desired MySQL community server RPM package from the MySQL Yum Repository official repositories.
curl -s "https://dev.mysql.com/downloads/repo/yum/" |
  grep -oE "mysql80.*-el7-.*rpm" |
  head -n1 |
  xargs -I{} sh -c 'curl -sSLO "https://dev.mysql.com/get/{}"'

# Exp4: Manage to measure the most captured disk space file in this current directory.
find . -type f ! -newermt "6 months ago" -a -size +0M | xargs -I{} bash -c "du -sh {}"

# Exp5: With the process substitution technique, one stdin can be passed through
#       and treated as an argument for multi-commands.
echo "example" | tee >(xargs mkdir) >(wc -c)
