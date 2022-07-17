#!/usr/bin/env bash

# This is the example script for running some GitHub CLI commands.
declare -x username=$1 repo=$2

function syncForkedRepo() {
  gh repo sync "$username"/"$repo"
}

function getHtmlURL() {
  gh api -X GET "repos/"$username"/"$repo"" --jq ' .owner | .html_url '
}

function createGist() {
  local gistName=$1
  cat "$gistName" | gh gist create --public "$gistName"
}

function createRepo() {
  local repoName=$1
  gh repo create "$repoName" --public --source=. --remote=upstream
}

function renameRepo() {
  local newName=$3
  gh repo rename "$newName" -y -R git@github.com:"$username"/"$repo".git
}

function cloneRepo() {
  gh repo clone "$username"/"$repo"
}
