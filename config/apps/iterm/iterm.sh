#!/usr/bin/env bash

# iTerm Setup Script
osascript -e 'tell application "iTerm" to activate'
sleep 5
osascript -e 'tell application "iTerm" to quit'

# Symlink Preferences
mv ~/Library/Preferences/com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2backup.plist
ln -s ./com.googlecode.iterm2.plist ~/Library/Preferences/com.googlecode.iterm2.plist