#!/usr/bin/expect -f

# Auto: correct password Linux:
spawn ssh user@my.server.com
expect "assword:"
send "mypassword\r"
interact