#! /usr/bin/bash

declare -x API_URL="https://api-url.com/api/v1"

# NOTE:
# curl [options...] <URL>
#
# `-u/--user` := Server username/password (to do basic authentication).
# `-x/--proxy` := Use this proxy configuration.
# `-X/--request <method>` := Specify HTTP request to interact with.
# `-T/--upload-file <file>` := Transfer local FILE to destination.
# `-d/--data <data>` := HTTP POST data.
# `-K/--config <file>` := Read config from a file.
# `-k/--insecure` := Allow insecure server connections.
# `-H/--header <header/@file>` := Pass custom header(s) to the server.
# `-D/--dump-header <filename>` := Write/dump the received headers to <filename>.

# Exp1: `curl` POST request using basic authentication.
declare -x AUTH="user:passwd"

curl -u $AUTH -X DELETE $API_URL
curl -u $AUTH -T test.csv -H "Content-Type: text/csv" $API_URL
curl -u $AUTH -T test.json -H "Content-Type: application/json" $API_URL
curl -u $AUTH -d '{}' -H "Content-Type: application/json" $API_URL