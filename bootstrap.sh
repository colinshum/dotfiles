#!/usr/bin/env bash

echo "Preparing your environment..."
echo
echo "Entering sudo mode... Keeping session alive until bootstrap is over."
echo

sudo -v

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Closing System Preferences..."
echo

osascript -e 'tell application "System Preferences" to quit'

# --------------------------------
# Homebrew Installation
# --------------------------------

if test ! $(which brew); then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Checking for Homebrew Updates..."
echo
brew update

# --------------------------------
# Homebrew Taps
# --------------------------------

brew tap 'homebrew/cask-eid'
brew tap 'homebrew/cask-fonts'
brew tap 'homebrew/cask-versions'
brew tap 'homebrew/bundle'

# --------------------------------
# Brew Install
# --------------------------------

brew install git
brew install grep
brew install mas
brew install zsh
brew install zsh-completions

# --------------------------------
# Cask Install
# --------------------------------

CASKS=(
    google-chrome
    iterm2
    slack
    visual-studio-code
    spotify
    1password
    polymail
)

echo "Installing apps..."
brew cask install ${CASKS[@]}

# --------------------------------
# macOS Preferences
# --------------------------------

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write -g AppleShowAllExtensions -bool true

# Disable auto-correct, auto-capitalization and auto-period
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Dark Mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Keyboard Repeat Rate
defaults write NSGlobalDomain InitialKeyRepeat -int 12
defaults write NSGlobalDomain KeyRepeat -int 2

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Set screenshot format to .png
defaults write com.apple.screencapture type -string "png"

# Disable natural scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# ------------------
# Finder
# ------------------

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show the ~/Library folder
chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

# ------------------
# iTerm & zsh
# ------------------

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Install theme/fonts for iTerm
echo "Installing iTerm themes and fonts..."
echo

open "./iterm/Oceanic-Next.itermcolors"
brew cask install font-meslolg-nerd-font

defaults write com.googlecode.iterm2 "Normal Font" -string "MesloLGMDZN-Regular 12"

# Install oh-my-zsh

echo "Installing oh-my-zsh..."
echo
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install spaceship prompt + symlink
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"


# ------------------
# Dotfiles
# ------------------
echo "Copying dotfiles..."
echo

cp .zshrc ~/.zshrc
cp .aliases ~/.aliases

echo "Installation complete! 😁"
echo
