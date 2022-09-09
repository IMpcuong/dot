#!/bin/bash

# .bashrc: with some useful utility functions.

### ALIASES ###

# Root privileges
alias doas="doas --"

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias lh='ls -halt --color=auto'
alias os='cat /etc/*release'
alias h='history'
alias b='cd ..'

### ALIASES ###

### Special/Builtin Variables ###

# History format with datetime
HISTTIMEFORMAT="%d/%m/%Y %T "

# Customizing the prompt:
# For more informations please visit: https://github.com/IMpcuong/live-and-learn/blob/main/08162022.md
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
    local curDir="$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
    echo $curDir
}

# Search through man pages options utility faster: `manopt <cmd> -<opt>`.
function manopt() {
    local cmd=$1 opt=$2
    [[ $opt == -* ]] || { (( ${#opt} == 1 )) && opt="-$opt" || opt="--$opt"; }

    # `-v`: `var=val`.
    # `RS`: input Record Separator, by default is a newline (\n).
    man "$cmd" | col -b | awk -v opt="$opt" -v RS= '$0 ~ "(^|,|\n)[[:blank:]]+" opt "([[:punct:][:space:]]|$)"'
}

# NOTE:
# `tr`: Translate or delete characters. See: `man tr`.
function _splitpath_alt() {
    sed 's/:/\n/g' <<< "$PATH" || tr ":" "\n" <<< "$PATH"
}

### From: https://github.com/rwxrob/dot/blob/c6b19d0c1dfe1b3a5b7dc013b288b9c1fb0b8467/.bashrc#L17.
function _have() {
    type "$1" &>/dev/null
}

# NOTE: `-r` ~ checking if file has read permission (for the user running the test).
function _source_if() {
    [[ -r "$1" ]] && source "$1"
}
### End From: https://github.com/rwxrob/dot/blob/c6b19d0c1dfe1b3a5b7dc013b288b9c1fb0b8467/.bashrc#L18.

# Split PATH variable for human readable.
function splitpath() {
    local counter=$(grep -o ':' <<< "$PATH" | wc -l)
    IFS=':' read -ra Path <<< "$PATH"

    # With default the indices equal to the total elements of list/array.
    # We can define an  array with specific type of key, eg:

    # declare/typeset -A dirs
    # dirs=(
    #   [jim]=/home/jim
    #   [silvia]=/home/silvia
    #   [alex]=/home/alex
    # )

    # "[@]" : it's a separated list/array of words.
    # "!"   : enumerate all indices in the list/array [echo "${!Path[@]}"].
    for i in "${!Path[@]}"; do
        printf "%s\t%s\n" "Path $((i+1)):" "${Path[$i]}"
    done
}

# Interaction menu showing all the children dirs inside
# current dir and can traverse between all of them.
function mndirs() {
    # Get 'ls' command's location: "/usr/bin/ls".
    local lsLoc=$(whereis ls | cut -d ":" -d " " -f 2)

    # FIXME: if dir doesn't have children dir -> throw `error`.
    # List all directory options and store in a/an list/array.
    local opts=$(${lsLoc} -d */ | cut -d " " -f 1)
    local optsArr=($opts)

    # Read array and separate to lines with line number.
    IFS=' ' read -d '' -ra dirs <<< "${optsArr[@]}"
    local q="Quit" b="Back"

    # Arithmetric expansion inside string literal: "<text> ... $((${#arr[@] + 1))".

    echo "Select directory you want to 'cd'."
    select choice in "${dirs[@]}" "$b" "$q"; do
        [[ -n "$choice" ]] || { echo "Invalid choice. Please try again!" >&2; continue; }
        if [[ "${choice%/*}" = "$q" ]]; then
            { echo "Quit prompt!" >&2; break; }
        elif [[ "${choice%/*}" = "$b" ]]; then
            { echo "Back to father directory!" >&2; b; }
        else
            cd $choice
            echo "[cd] to [$choice]"
        fi

        # `2>&1`: captures `stderr` -> pipes it into `stdout` -> whole lots piped to `null`.
        ls ./*/ >/dev/null 2>&1;

        # Menu dirs recursion; `$?`: the exit status of the command above.
        if [ $? == 0 ]; then
            mndirs
        else
            { echo "There is no more directory!" >&2; break; }
        fi
        break # Valid choice was made; exit the prompt.
    done

    # Old exec command:
    # local curDir=$(find ../ "$name" -exec readlink -f {} \;)

    # Split the chosen line in to only dir's name.
    read -r name unused <<< "$choice"

    # $curDir is global variable defined in `function realdir() {}`.
    echo "Current directory: [$name]; absolute path: [$curDir]"
}

# Checking and retrieve the given file's privilege.
function chper() {
    local filename=$1
    if [[ -f "${filename}" ]]; then
        # If you wanna see access rigths in human readable form: "%a" -> "%A".
        # Some more indirective fields: ["%F", "%s". "%i", "%m/%M", "%l/%L", "%c/%C"].
        perm=`stat -c "%a" "${filename}"`
        printf "%s have permissions: %d\n" "${filename}" "${perm}"
    else
        echo "'${filename}' is not a file"
    fi
}

# Checking if the given directory is a git repository or not.
function chrepo() {
    local dir=$1
    [[ -d "$dir" ]] || echo "Not a readable directory's path"

    local counter=`ls -halt "$dir"| grep -E "\.git" | wc -l`
    if (( "$counter" == 1 )); then
        cd "$dir"; branches=`git branch -a`
        printf "List current branches\n: %s" "$branches"
    else
        echo "Not a git repository"
    fi
}

# From the GitHub API retrieve the 'created-date' of one repo.
function daterepo() {
    local username=$1
    local repo=$2

    # `-f{number}`: retrieves only one field corresponded with the given position.
    # `-f{number}-`: retrieves every fields from the input position until reach the end.
    local date=$(curl -s "https://api.github.com/repos/${username}/${repo}" | \
                  grep -E "created_at" | \
                  cut -d: -f2-)

    if [[ $? == 1 ]]; then
        echo "The given username ("$username") or repo ("$repo") is wrong!"
    else
        created_date=${date//[\",]/''}
        echo "The created date of the repo "${repo}" is: "${created_date}""
    fi
}

# Synchronize forked repositories up-to-date with the latest commit.
function syncforked() {
    username=$1

    forkedRepos=(`gh repo list | grep -E "fork" | \
        grep -E "$username" | \
        cut -d " " -f 1
    `)
    for repo in "${forkedRepos[@]}"; do
        gh sync $repo
    done
}

# Remove/clear multiple commands line history from `HISTFILE` in Linux system.
function rmhist() {
    declare -i from=$1 to=$2
    declare -i range=$(($to - $from))
    printf "Delete history from index %s to %s (range=%s)\n" "$from" "$to" "$range"

    # NOTE: `history -c` ~ for delete all history.
    # Remove `$range` lines starting from the `$from` position permanently.
    for ((i = 1; i <= $range; i++)); do
        history -d $from
        history -w
    done
}


### From: https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc
# Archive extraction.
# Usage: `ex <file>``.
function ex() {
    if [ -f "$1" ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1   ;;
            *.tar.gz)    tar xzf $1   ;;
            *.bz2)       bunzip2 $1   ;;
            *.rar)       unrar x $1   ;;
            *.gz)        gunzip $1    ;;
            *.tar)       tar xf $1    ;;
            *.tbz2)      tar xjf $1   ;;
            *.tgz)       tar xzf $1   ;;
            *.zip)       unzip $1     ;;
            *.Z)         uncompress $1;;
            *.7z)        7z x $1      ;;
            *.deb)       ar x $1      ;;
            *.tar.xz)    tar xf $1    ;;
            *.tar.zst)   unzstd $1    ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Navigation.
function up() {
    local d=""
    local limit="$1"

    # Default to limit of 1
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
        limit=1
    fi

    for (( i = 1; i <= limit; i++ )); do
        d="../$d"
    done

    # perform cd. Show error if cd fails
    if ! cd "$d"; then
        echo "Couldn't go up $limit dirs.";
    fi
}
### End From.

### From: https://stackoverflow.com/questions/5188320/how-can-i-get-a-list-of-git-branches-ordered-by-most-recent-commit
# NOTE:
# - `refbranch` := which branch the ahead or behind columns are calculated against. Default is master.
# - `count` := how many recent branches to show. Default 20.
fucntion recentb() {
  local refbranch=$1 count=$2

  # `echo -e` := enable interpretation of backslash escapes.
  git for-each-ref \
    --sort=-committerdate refs/heads \
    --format='%(refname:short)|%(HEAD)%(color:yellow)%(refname:short)|%(color:bold green)%(committerdate:relative)|%(color:blue)%(subject)|%(color:magenta)%(authorname)%(color:reset)' \
    --color=always \
    --count=${count:-20} | \
    while read line; do branch=$(echo "$line" | \
      awk 'BEGIN { FS = "|" }; { print $1 }' | tr -d '*'); \
      ahead=$(git rev-list --count "${refbranch:-origin/master}..${branch}"); \
      behind=$(git rev-list --count "${branch}..${refbranch:-origin/master}"); \
      colorline=$(echo "$line" | sed 's/^[^|]*|//'); \
      echo "$ahead|$behind|$colorline" | awk -F'|' -vOFS='|' '{ $5 = substr($5,1,70) }1'; \
    done | \
    ( echo -ne "ahead|behind||branch|lastcommit|message|author\n" && cat ) | column -ts'|'
}
###

# ---------- Utilitty functions ----------
