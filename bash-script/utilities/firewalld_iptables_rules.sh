#!/bin/bash

firewall-cmd --get-services | cut -d ' ' -f1- | sed 's/ /\n/g' -

firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --remove-port=8080/tcp --permanent

# NOTE: Docker network is unstabilized after adding new routing rules, solution: `https://stackoverflow.com/a/33797967/12535617`.
# 
# Options enlightened/illuminated:
#   -t := This option specifies the packet matching table which the command should operate on.
iptables -t nat -L --line-numbers | grep -i postrouting
iptables -t nat -L POSTROUTING

# https://docs.docker.com/network/packet-filtering-firewalls/#:~:text=arrive%20to%20the-,DOCKER-USER,-chain%2C%20they%20have
# Options enlightened/illuminated:
#   -I := Insert operation injection/interpolation in-between the INPUT-chain of rules.
#   -p := Network-protocal family is allowed to ingress/egress packets through our system.
#   -m := Network-module has been loaded in `iptables` that provides additional matching/target capabilities 
#         (conntrack ~ connection-tracking).
#   --ctstate := Conntrack-state is used to observe and filter the arrived-packets based on their connection tracking state.
#     + NEW: Filters packets that are part of a new connection attempt.
#     + ESTABLISHED: Filters packets that are part of an established connection.
#     + RELATED: Filters packets that are related to an existing connection
#                (e.g, ICMP error messages related to an existing connection).
#     + INVALID: Filters packets that are not partially belonging to any had-known connection or have an invalid state.
#     + UNTRACKED: Filters packets which are not generally tracked by the connection tracking system.
#   -j := Specifies the target operation our filtering-system is going to execute if the packets match this rule.
iptables -I DOCKER-USER -p tcp -m conntrack --ctstate ESTABLISHEDED,RELATED -j ACCEPT
iptables -I DOCKER-USER -p tcp -m conntrack --ctorigsrc 1.2.3.4 --ctorigdstport 80 -j ACCEPT

iptables -L -nv --line-numbers
iptables -L INPUT -nv --line-numbers # -L := List only INPUT rules (from one CHAIN).
iptables -D INPUT 1                  # -D := Delete INPUT rule in line-number 1.
iptables -R INPUT 3 -s 120.121.122.123 -j DROP # -R := Replace/modify this current rule from the INPUT-chain.
iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT
iptables -I INPUT 1 -p tcp --dport 26379 -s 10.120.0.0/16 -j ACCEPT  # `-s`: source ~ Exp: Some VPN IPs range.
iptables -I INPUT 1 -p tcp --dport 26379 -s 10.120.42.0/24 -j ACCEPT # `-s`: source ~ Exp: From the same VLAN range. 
iptables -L -nv # Are semantically distinguished even though the command itself might have a similar outlook.
ip route add 10.0.0.0/8 gw 10.120.42.1 dev eth1
ip route add 10.0.0.0/8 gw 10.120.42.1
route -n

# Exp: 7 111 20001 REJECT all -- * * 0.0.0.0/0 0.0.0.0/0 reject-with icmp-host-prohibited -> prohibit ping-protocol.
