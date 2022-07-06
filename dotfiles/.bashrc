#!/bin/bash

# .bashrc
### ALIASES ###

# root privileges
alias doas="doas --"

# User specific aliases and functions
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias h='history'
alias b='cd ..'

# History format with datetime
HISTTIMEFORMAT="%d/%m/%Y %T "

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Get absolute path of file/dir
realdir() {
    curDir="$(cd "$(dirname "$1")"; pwd -P)/$(basename "$1")"
    echo $curDir
}

# Search through man pages options utility faster: manopt <cmd> -<opt>
manopt() {
    local cmd=$1 opt=$2
    [[ $opt == -* ]] || { (( ${#opt} == 1 )) && opt="-$opt" || opt="--$opt"; }

    # `-v`: var=val
    # `RS`: input Record Separator, by default is a newline (\n):
    man "$cmd" | col -b | awk -v opt="$opt" -v RS= '$0 ~ "(^|,)[[:blank:]]+" opt "([[:punct:][:space:]]|$)"'
}

# Split PATH variable for human readable
splitpath() {
    local counter=$(grep -o ':' <<< "$PATH" | wc -l)
    IFS=':' read -ra Path <<< "$PATH"

    # With default the indices equal to the total elements of list/array
    # We can define an  array with specific type of key, eg:

    # declare/typeset -A dirs
    # dirs=(
    #   [jim]=/home/jim
    #	[silvia]=/home/silvia
    #	[alex]=/home/alex]
    # )

    # "[@]" : it's a separated list/array of words
    # "!"   : enumerate all indices in the list/array [echo "${!Path[@]}"]
    for i in "${!Path[@]}"; do
        printf "%s\t%s\n" "Path $((i+1)):" "${Path[$i]}"
    done
}

# Interaction menu showing all the children dirs inside
# current dir and can traverse between all of them
mndirs() {
    # Get 'ls' command's location: /usr/bin/ls
    local lsLoc=$(whereis ls | cut -d ":" -d " " -f 2)

    # FIXME: if dir doesn't have children dir -> throw error
    # List all directory options and store in a/an list/array
    local opts=$(${lsLoc} -d */ | cut -d " " -f 1)
    local optsArr=($opts)

    # Read array and separate to lines with line number
    IFS=' ' read -d '' -ra dirs <<< "${optsArr[@]}"
    local q="Quit" b="Back"

    # Arithmetric expansion inside string literal: "<text> ... $((${#arr[@] + 1))"

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

        # `2>&1`: captures `stderr` -> pipes it into `stdout` -> whole lots piped to `null`
        ls ./*/ > /dev/null 2>&1 ;

        # Menu dirs recursion; `$?`: the exit status of the command above
        if [ $? == 0 ]; then
            mndirs
        else
            { echo "There is no more directory!" >&2; break; }
        fi
        break # Valid choice was made; exit the prompt
    done

    # local curDir=$(find ../ "$name" -exec readlink -f {} \;)

    # Split the chosen line in to only dir's name
    read -r name unused <<< "$choice"

    # $curDir is global variable defined in function realdir() {}
    echo "Current directory: [$name]; absolute path: [$curDir]"
}

# Checking and retrieve the given file's privilege.
chper() {
    filename=$1
    if [[ -f "$filename" ]]; then
        # If you wanna see access rigths in human readable form: "%a" -> "%A"
        # Some more indirective fields: ["%F", "%s". "%i", "%m/%M", "%l/%L", "%c/%C"]
        perm=`stat -c "%a" "$filename"`
        printf "%s have permissions: %d\n" "$filename" "$perm"
    else
        echo ""$filename" is not a file"
    fi
}

# Checking if the given directory is a git repository or not.
chrepo() {
    dir=$1
    [[ -d "$dir" ]] || echo "Not a readable directory's path"

    counter=`ls -halt "$dir"| grep -E "\.git" | wc -l`
    if (( "$counter" == 1 )); then
        cd "$dir"; branches=`git branch -a`
        printf "List current branches\n: %s" "$branches"
    else
        echo "Not a git repository"
    fi
}

# From the GitHub API retrieve the 'created-date' of one repo.
daterepo() {
    username=$1
    repo=$2

    date=$( curl -s "https://api.github.com/repos/${username}/${repo}" |
        grep -E "created_at" | cut -d: -f2- )

    if [[ $? == 1 ]]; then
        echo "The given username ("$username") or repo ("$repo") is wrong!"
    else
        created_date=${date//[\",]/''}
        echo "The created date of the repo "$repo" is: "${created_date}""
    fi
}

# Synchronize forked repositories up-to-date with the latest commit.
syncforked() {
    username=$1

    forkedRepos=(`gh repo list | grep -E "fork" |
        grep -E "$username" |
        cut -d " " -f 1
    `)
    for repo in "${forkedRepos[@]}"; do
        gh sync $repo
    done
}

### From: https://gitlab.com/dwt1/dotfiles/-/blob/master/.bashrc
### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
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

# navigation
up () {
    local d=""
    local limit="$1"

    # Default to limit of 1
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
        limit=1
    fi

    for (( i=1; i<=limit; i++ )); do
        d="../$d"
    done

    # perform cd. Show error if cd fails
    if ! cd "$d"; then
        echo "Couldn't go up $limit dirs.";
    fi
}
### End From.
