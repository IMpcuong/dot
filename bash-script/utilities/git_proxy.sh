#!/bin/bash

proxy_port=$(env | grep -i proxy)
if [[ $? -eq 0 ]]; then
  current_ip=$(wget -q -O - checkip.dyndns.org |
    sed -e 's/.*Current IP Address: //g' -e 's/<.*$//g')
  echo -e ${current_ip}
  git config --global http.sslverify false
  git config --global http.proxy "http://${current_ip}/${port}"
fi
