#!/usr/bin/env bash

# Link: https://stackoverflow.com/a/20018504/12535617

function info__() {
  printf "[INFO] Print out variable's content status:\n"
}

declare -x log_path="$(find /path/to/log/dir -maxdepth 3 -type d -iname "*logs")"
info__
printf "%s\n" "${log_path}"

if [[ -d "${log_path}" ]]; then
  # NOTE: A robust way to deal with coprocesses in Bash `coproc` builtin.
  coproc find_subdirs_fd { find "${log_path}" -maxdepth 1 -type d ! -path "*/logs"; }
  exec 3>&"${find_subdirs_fd[0]}" # Copy the input file descriptor 'find_subdirs_fd[0]' to fd 3.

  # NOTE:
  # `output=$(cat <&3)` := Capture whole output from fd 3.
  # `IFS=read -d '' -u 3 output` := Same usage as above.
  #
  # + Cannot capture binary data in general.
  # + Only defined operation if the output text in the POSIX sense.
  info__
  while read <&3 dir; do
    printf "+) [%s]:\n" "$dir"
    du -sh "$dir"
    if [[ "$dir" == *"payment"* ]]; then
      find "$dir" -type f ! -empty ! -newermt "6 months ago" | xargs rm -rfv
    else
      find "$dir" -type f ! -empty ! -newermt "1 month ago" | xargs rm -rfv
    fi
  done
fi
