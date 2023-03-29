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

# Exp2: Download a desired MySQL community server RPM package from the MySQL Yum Repository official repositories.
curl -s "https://dev.mysql.com/downloads/repo/yum/" |
  grep -oE "mysql80.*-el7-.*rpm" |
  head -n1 |
  xargs -I{} sh -c 'curl -sSLO "https://dev.mysql.com/get/{}"'
