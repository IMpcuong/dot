#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo >>/Users/$(whoami)/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>/Users/$(whoami)/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install iterm2 z zsh-autocomplete zsh-autosuggestions zsh-syntax-highlighting

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autocomplete
tmux source-file ~/.tmux.conf
