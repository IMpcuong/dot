#!/bin/bash

# Resource: https://www.cyberciti.biz/faq/bash-shell-command-to-find-get-ip-address/

# Exp1: Using basic command `ifconfig`.
ifconfig -a
ifconfig em0
/sbin/ifconfig en0
/sbin/ifconfig -a | less

# Finding default routing information on Unix (Internet section):
netstat -rn

# Exp2: IP address of the local machine using `hostname`.
hostname -I

# Exp3: Using `ip` command.
ip addr show
ip addr show eth0
ip link show

ip route show
# Equivalent with:
ip r s

route -n