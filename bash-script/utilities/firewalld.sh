#!/bin/bash

firewall-cmd --get-services | cut -d ' ' -f1- | sed 's/ /\n/g' -

firewall-cmd --add-port=8080/tcp --permanent
firewall-cmd --remove-port=8080/tcp --permanent
