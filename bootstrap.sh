#!/usr/bin/env bash

# This script is used to install necessary tools on a macOS platform

echo "Preparing your environment..."

# Homebrew

if test ! $(which brew); then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi 

echo "Checking for Homebrew Updates..."
brew update

# Homebrew Taps

tap 'caskroom/cask'
tap 'caskroom/eid'
tap 'caskroom/fonts'
tap 'caskroom/versions'
tap 'homebrew/bundle'

# Brew

brew install git
brew install grep
brew install mas
brew install zsh
brew install zsh-completions

# Cask

brew install caskroom/cask/brew-cask

CASKS=(
    google-chrome
    iterm2
    slack
    visual-studio-code
    rubymine
)

echo "Installing apps..."
brew cask install ${CASKS[@]}

# Ruby Gems

RUBY_GEMS=(
    bundler
)

echo "Installing Ruby Gems..."
sudo gem install ${RUBY_GEMS[@]}

# macOS Preferences

echo "Setting macOS Preferences..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# ZSH

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# TODO: symlink theme, alias and zshrc

# Fonts & iTerm Config

# TODO: Meslo Nerd font, symlink iTerm config
 
# VSCode

# TODO: copy user preferences, prompt user to install 'code' shortcut, run extension install
echo "Installation complete"
