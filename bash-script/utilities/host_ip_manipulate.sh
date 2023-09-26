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

route -n                                # NOTE: Kernel IP routing table
route -n | awk '/UG[ \t]/ { print $2 }' # NOTE: Retrieve host IP address.

# NOTE: https://www.cyberciti.biz/faq/linux-ip-command-examples-usage-syntax/
# Retrieve the subnet-mask of the local machine in format `/24 := 32 - 24 == 8 ~ host-ip`:
# `ip -o/-oneline` := Output each record in the single line, replacing line feeds with the '\' character.
# `ip -f/-family` := Specifies the protocol family to use; protool family identifier := [inet, inet6, bridge, ipx, dnet, link].
ip -o -f inet addr show | awk '/scope global/ { print $4 }' | cut -d'/' -f1
ip -4 a show | grep -oE "inet (10|172)(\.[[:digit:]]{2,3}){3}" | cut -d' ' -f2
ip -4 a show eth0
ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p'

# NOTE: Scan open ports.
nmap -sS your.server.ip -p-
