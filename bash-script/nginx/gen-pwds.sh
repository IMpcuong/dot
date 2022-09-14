#!/bin/bash

# Solution1 - Install apache2-utils:
which apache2-utils
if [[ $? -ne 0 ]]; then
  sudo apt install apache2-utils
fi

# Solution2 - Another way to do this instead of using `which` is:
command -v apache2-utils
if (( 0 != $? )); then
  sudo apt install apache2-utils
fi

# Create passwords for root user and user1:
sudo htpasswd -c /etc/apache2/.htpasswd root
sudo htpasswd /etc/apache2/.htpasswd user1
cat /etc/apache2/.htpasswd >>~/apache_pwds.txt
