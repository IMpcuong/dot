#!/bin/sh

function netcat() {
  local HOST=$1
  local PORT=$2
  local DESCRIPTION=$3

  # `-w`: wait time ~ 10 sec.
  # `-z`: zero IO mode, report connection status only.
  # Abstract condition statement: `if [[ nc -w 10 -z $HOST $PORT ]]; then`

  # Checking the stdout status code from the `nc` command:
  nc -w 10 -z $HOST $PORT
  if [[ $? -eq 0 ]]; then
    printf "%-35s | %-53s | %-18s\n" "[netcat][SUCCESS][${DESCRIPTION}]" "Connecting to ${HOST}:${PORT}" "Status: succeeded"
  else
    printf "%-35s | %-53s | %-18s\n" "[netcat][FAILURE][${DESCRIPTION}]" "Connecting to ${HOST}:${PORT}" "Status: failed"
  fi
}

function curl_status() {
  local URL=$1
  local DESCRIPTION=$2

  local status=$(curl -m 3 -Is ${URL} | grep HTTP | cut -d ' ' -f2 | head -1)
  if [[ $status -eq "200" ]]; then
    printf "%-35s | %-53s | %-18s\n" "[curl][SUCCESS][${DESCRIPTION}]" "Connecting to ${URL}" "Status: $status"
  else
    printf "%-35s | %-53s | %-18s\n" "[curl][FAILURE][${DESCRIPTION}]" "Connecting to ${URL}" "Status: $status"
  fi
}

# Examples:
netcat google.com 22 DOMAIN_TEST

curl_status https://github.com GH_URL