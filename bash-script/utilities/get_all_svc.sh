#!/bin/bash

declare sys_dir="/etc/systemd/system"

# Two simple solutions that have exact same output (all services):
find ${sys_dir} -mindepth 1 ! -type l | \
  grep -i ".*.service$" | \
  cut -d "/" -f5 | \
  xargs systemctl status -l

find ${sys_dir} -mindepth 1 ! -type l -iname "*.service" | \
  cut -d "/" -f5 | \
  xargs systemctl status -l

# Script to restart a specific service:
declare srv=$1
if [[ "" == "$srv" ]]; then
  echo -ne "Missing service as an positional argument. Available service: \n"
  find ${sys_dir} -mindepth 1 ! -type l | \
    grep -iE ".*.service$" | \
    cut -d "/" -f5
  exit 1
fi

sudo -b sh && systemctl restart "${srv}.service"