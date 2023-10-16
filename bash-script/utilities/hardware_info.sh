#!/bin/bash

dmidecode -t system
dmidecode -t processor
dmidecode -t memory
grep ^cpu\\scores /proc/cpuinfo | uniq | awk '{ print $4 }'
