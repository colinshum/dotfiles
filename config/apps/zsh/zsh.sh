#!/usr/bin/env bash

# ZSH Setup Script

# Oh My Zsh
cd ~

ZSH="$HOME/.oh-my-zsh"
git clone https://github.com/ohmyzsh/ohmyzsh.git .oh-my-zsh --quiet
# source ~/.zshrc

# Spaceship Prompt
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH/themes/spaceship-prompt" --depth=1 --quiet
ln -s "$ZSH/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"  2>&1 /dev/null