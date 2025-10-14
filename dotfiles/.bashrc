#!/bin/bash

# .bashrc: with some useful utility functions.

### ALIASES ###

# Root privileges
alias doas="doas --"

# User-specific aliases and functions:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias lh='ls -halt --color=auto'
alias os='cat /etc/*release'
alias h='history'
alias b='cd ..'

### ALIASES ###

### Special/Builtin Variables ###

# History format with date time formatted:
HISTTIMEFORMAT="%d/%m/%Y %T "

# Customizing the prompt:
# For more information please visit: https://github.com/IMpcuong/live-and-learn/blob/main/08162022.md
export PS1="[\A \u@\h \w]\$ "

# NOTE: when using the backslash (\) line continuation character (placed at the end of the line).
# Notice that the greater-than symbol (>) will appear at the start of any newline was showed up.
# It is the secondary prompt string and can be customized by changing the `$PS2` environment variable.
export PS2="line continued: "

### Special/Builtin Variables ###

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# ---------- Utilitty functions ----------

# Get absolute path of file/dir
function realdir() {
  local curDir="$(
    cd "$(dirname "$1")"
    pwd -P
  )/$(basename "$1")"
  echo $curDir
}

# Search through man pages options utility faster: `manopt <cmd> -<opt>`.
function manopt() {
  local cmd=$1 opt=$2
  [[ $opt == -* ]] || { ((${#opt} == 1)) && opt="-$opt" || opt="--$opt"; }

  # `-v`: `var=val`.
  # `RS`: input Record Separator, by default is a newline (\n).
  man "$cmd" | col -b | awk -v opt="$opt" -v RS= '$0 ~ "(^|,|\n)[[:blank:]]+" opt "([[:punct:][:space:]]|$)"'
}

# NOTE:
# `tr`: Translate or delete characters. See: `man tr`.
function _splitpath_alt() {
  sed 's/:/\n/g' <<<"$PATH" || tr ":" "\n" <<<"$PATH"
}

### From: https://github.com/rwxrob/dot/blob/c6b19d0c1dfe1b3a5b7dc013b288b9c1fb0b8467/.bashrc#L17.
function _have() {
  type "$1" &>/dev/null
}

# NOTE: `-r` ~ checking if the file has read permission (for the user running the test).
function _source_if() {
  [[ -r "$1" ]] && source "$1"
}
### End From: https://github.com/rwxrob/dot/blob/c6b19d0c1dfe1b3a5b7dc013b288b9c1fb0b8467/.bashrc#L18.

# Split PATH variable for human readable.
function splitpath() {
  local counter=$(grep -o ':' <<<"$PATH" | wc -l)
  IFS=':' read -ra Path <<<"$PATH"

  # By default, the large number of indices equal to the total elements from the source list/array.
  # We can define an array using any unique type of key (for short: `dictionaries` data-structure in Python).

  # E.g.:
  # declare/typeset -A/a dirs
  # dirs=(
  #   [jim]="/home/jim"
  #   [silvia]="/home/silvia"
  #   [alex]="/home/alex"
  # )

  # "[@]" : A list of sequential elements that originally combined the array.
  # "!"   : Enumerate through all indices of the list/array `[echo "${!Path[@]}"]`.
  for i in "${!Path[@]}"; do
    printf "%s\t%s\n" "Path $((i + 1)):" "${Path[$i]}"
  done
}

# An interactive menu that unveils/exhibits all of the subdirectories inside
# the current one also allows us to traverse between each node as well.
function mndirs() {
  # Get 'ls' command's location: "/usr/bin/ls".
  local lsLoc=$(whereis ls | cut -d ":" -d " " -f 2)

  # FIXME: if dir doesn't have children dir -> throw `error`.
  # List all directory options and store in a/an list/array.
  local opts=$(${lsLoc} -d */ | cut -d " " -f 1)
  local optsArr=($opts)

  # Read array and separate to lines with line number.
  IFS=' ' read -d '' -ra dirs <<<"${optsArr[@]}"
  local q="Quit" b="Back"

  # Arithmetric expansion inside string literal: "<text> ... $((${#arr[@] + 1))".

  echo "Select directory you want to 'cd'."
  select choice in "${dirs[@]}" "$b" "$q"; do
    [[ -n "$choice" ]] || {
      echo "Invalid choice. Please try again!" >&2
      continue
    }
    if [[ "${choice%/*}" = "$q" ]]; then
      {
        echo "Quit prompt!" >&2
        break
      }
    elif [[ "${choice%/*}" = "$b" ]]; then
      {
        echo "Back to father directory!" >&2
        b
      }
    else
      cd $choice
      echo "[cd] to [$choice]"
    fi

    # `2>&1`: captures `stderr` -> pipes it into `stdout` -> whole lots piped to `null`.
    ls ./*/ >/dev/null 2>&1

    # Menu dirs recursion; `$?`: the exit status of the command above.
    if [ $? == 0 ]; then
      mndirs
    else
      {
        echo "There is no more directory!" >&2
        break
      }
    fi
    break # Valid choice was made; exit the prompt.
  done

  # Old exec command:
  # local curDir=$(find ../ "$name" -exec readlink -f {} \;)

  # Split the chosen line into only dir's name.
  read -r name unused <<<"$choice"

  # $curDir is global variable defined in `function realdir() {}`.
  echo "Current directory: [$name]; absolute path: [$curDir]"
}

# Checking and retrieving the given file's privilege.
function chper() {
  local filename=$1
  if [[ -f "${filename}" ]]; then
    # If you wanna see access rights in human-readable form: "%a" -> "%A".
    # Some more indirective fields: ["%F", "%s". "%i", "%m/%M", "%l/%L", "%c/%C"].
    local perm=$(stat -c "%a" "${filename}")
    printf "%s have permissions: %d\n" "${filename}" "${perm}"
  else
    echo "'${filename}' is not a file"
  fi
}

# Checking if the given directory is a git repository or not.
function chrepo() {
  local dir=$1
  [[ -d "$dir" ]] || echo "Not a readable directory's path"

  local counter=$(ls -halt "$dir" | grep -E "\.git" | wc -l)
  if (("$counter" == 1)); then
    cd "$dir"
    local branches=$(git branch -a)
    printf "List current branches\n: %s" "$branches"
  else
    echo "Not a git repository"
  fi
}

# From the GitHub API retrieve the 'created-date' of one repo.
function daterepo() {
  local username=$1
  local repo=$2

  # `-f{number}`: retrieves only one field corresponding with the given position.
  # `-f{number}-`: retrieves every field from the input position until reaches the end.
  local date=$(
    curl -s "https://api.github.com/repos/${username}/${repo}" |
      grep -E "created_at" |
      cut -d: -f2-
  )

  if [[ $? == 1 ]]; then
    echo "The given username ("$username") or repo ("$repo") is wrong!"
  else
    local created_date=${date//[\",]/''}
    echo "The created date of the repo "${repo}" is: "${created_date}""
  fi
}

# Synchronize forked repositories up-to-date with the latest owner's commit.
function syncforked() {
  gh repo list --fork --json 'nameWithOwner' --jq '.[] | .nameWithOwner | @text' |
    while read repo; do
      gh repo sync --force $repo
    done
}

# Remove/clear multiple commands line history from `HISTFILE` in the Linux system.
function rmhist() {
  declare -i from=$1 to=$2
  declare -i range=$(($to - $from))
  printf "Delete history from index %s to %s (range=%s)\n" "$from" "$to" "$range"

  # NOTE: `history -c` ~ for cleansing the history database entirely.
  # Remove `$range` lines starting from the `$from` position permanently.
  for ((i = 1; i <= $range; i++)); do
    history -d $from
    history -w
  done
}

# Weigh multiple sub-folders inside the given directory.
function mdu() {
  local dir="$1"

  # `du -h/--human-readable` := Print sizes in human-readable format (e.g., 1K 234M 2G).
  # `du -c/--total` := Produce a grant total.
  # `du -x` := File system mount points are not traversed.
  #
  # `sort -h` := Compares human-readable numbers such as 1k, 1G.
  # `sort -k` := Sort the data via a specific key (useful when sorting columnar data).
  # `sort -r` := Sort the values in reverse (descending order).
  find "$dir" -maxdepth 1 ! -path "*proc*" -type d ! -empty |
    xargs du -hxc --max-depth=1 |
    sort -hr -k1
}

### From: https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc
# Archive extraction.
# Usage: `ex <file>``.
function ex() {
  if [ -f "$1" ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar x $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *.deb) ar x $1 ;;
    *.tar.xz) tar xf $1 ;;
    *.tar.zst) unzstd $1 ;;
    *) echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Navigation.
function up() {
  local d="" limit="$1"

  # Default to a limit of 1.
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then limit=1; fi
  for ((i = 1; i <= limit; i++)); do d="../$d"; done

  # Perform cd. Show error if cd fails.
  if ! cd "$d"; then echo "Couldn't go up $limit dirs."; fi
}
### End From.

### From: https://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit
# NOTE:
# - `refbranch` := which branch the ahead or behind columns are calculated against. The default is master branch.
# - `count` := how many recent branches to show. Default 20.
# - `line` := each line of data have the convention like this "data-sync|*data-sync|3 months ago|chore: Refactor a minority amount of classes|imp".
#          := the `*` (asterisk) represents for the current local branch where you have already located at.
function recentb() {
  local refbranch=$1 count=$2

  # `echo -e` := enable interpretation of backslash escapes.
  # `column -t -s='|'` := table with the given separator character.
  git for-each-ref \
    --sort=-committerdate refs/heads \
    --format='%(refname:short)|%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' \
    --color=always \
    --count=${count:-20} |
    while read line; do
      branch=$(echo "$line" | awk 'BEGIN { FS = "|" }; { print $1 }' | tr -d '*')
      ahead=$(git rev-list --count "${refbranch:-origin/master}..${branch}")
      behind=$(git rev-list --count "${branch}..${refbranch:-origin/master}")
      colorline=$(echo "$line" | sed 's/^[^|]*|//')
      echo "$ahead|$behind|$colorline" | awk -F='|' -v OFS='|' '{ $5 = substr($5, 1, 70) } $1'
    done | cat | column -t -s='|' --table-columns Ahead,Behind,Branch,LastCommit,Message,Author
  # Both solutions have the same effect:
  # ( echo -e "Ahead|Behind|Branch|Lastcommit|Message|Author\n" && cat ) | column -t -s='|'
}
### End From.

# ---------- Utilitty functions ----------
