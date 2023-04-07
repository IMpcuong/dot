#!/bin/bash

sudo systemd-analyze blame

sudo systemctl list-units --type service
sudo systemctl list-units --type service -all
sudo systemctl list-units --state=failed
sudo systemctl list-unit-files
sudo systemctl list-unit-files
sudo systemctl status -l nginx.service
sudo systemctl is-active nginx.service

sudo systemctl cat nginx.service
# Output:
# [Unit]
# Description=nginx - high performance web server
# After=network-online.target remote-fs.target nss-lookup.target
# Wants=network-online.target
# ConditionPathExists=/etc/nginx/nginx.conf
#
# [Service]
# Type=forking
# PIDFile=/var/run/nginx.pid
# ExecStartPre=/usr/sbin/nginx -t
# ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf
# ExecReload=/bin/sh -c "/bin/kill -s HUP $MAINPID"
# ExecStop=/bin/sh -c "/bin/kill -s TERM $MAINPID"
#
# Open files
# LimitNOFILE=100000
#
# [Install]
# WantedBy=multi-user.target
