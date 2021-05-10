#!/usr/bin/env bash

# iTerm Setup Script
osascript -e 'tell application "iTerm" to quit'

# Symlink Preferences
if [ -f ~/Library/Preferences/com.googlecode.iterm2.plist ]; then
  mv ~/Library/Preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2backup.plist
fi

defaults delete com.googlecode.iterm2 2>&1 /dev/null

ln -s ~/dotfiles/config/apps/iterm/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist
defaults read com.googlecode.iterm2 2>&1 /dev/null
