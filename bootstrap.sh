#!/usr/bin/env bash

echo "Preparing your environment..."
echo "Entering sudo mode... Keeping session alive until bootstrap is over."

sudo -v

# Keep-alive: update existing sudo time stamp until the script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Closing System Preferences..."

osascript -e 'tell application "System Preferences" to quit'


# --------------------------------
# .gitconfig
# --------------------------------

grep 'user = GITHUBUSER' ./homedir/.gitconfig > /dev/null 2>&1
if [[ $? = 0 ]]; then
    read -r -p "What is your GitHub username? " githubuser

  fullname=`osascript -e "long user name of (system info)"`

  if [[ -n "$fullname" ]];then
    lastname=$(echo $fullname | awk '{print $2}');
    firstname=$(echo $fullname | awk '{print $1}');
  fi

  if [[ -z $lastname ]]; then
    lastname=`dscl . -read /Users/$(whoami) | grep LastName | sed "s/LastName: //"`
  fi
  if [[ -z $firstname ]]; then
    firstname=`dscl . -read /Users/$(whoami) | grep FirstName | sed "s/FirstName: //"`
  fi
  email=`dscl . -read /Users/$(whoami)  | grep EMailAddress | sed "s/EMailAddress: //"`

  if [[ ! "$firstname" ]];then
    response='n'
  else
    echo -e "I see that your full name is $COL_YELLOW$firstname $lastname$COL_RESET"
    read -r -p "Is this correct? [Y|n] " response
  fi

  if [[ $response =~ ^(no|n|N) ]];then
    read -r -p "What is your first name? " firstname
    read -r -p "What is your last name? " lastname
  fi
  fullname="$firstname $lastname"

  echo "Great $fullname, "

  if [[ ! $email ]];then
    response='n'
  else
    echo -e "Your email address is $COL_YELLOW$email$COL_RESET"
    read -r -p "Is this correct? [Y|n] " response
  fi

  if [[ $response =~ ^(no|n|N) ]];then
    read -r -p "What is your email? " email
    if [[ ! $email ]];then
      echo "ERROR: you must provide an email to configure .gitconfig"
      exit 1
    fi
  fi


  running "replacing items in .gitconfig with your info ($COL_YELLOW$fullname, $email, $githubuser$COL_RESET)"

  # test if gnu-sed or MacOS sed

  sed -i "s/GITHUBFULLNAME/$firstname $lastname/" ./homedir/.gitconfig > /dev/null 2>&1 | true
  if [[ ${PIPESTATUS[0]} != 0 ]]; then
    echo
    echo "looks like you are using MacOS sed rather than gnu-sed, accommodating"
    sed -i '' "s/GITHUBFULLNAME/$firstname $lastname/" ./homedir/.gitconfig;
    sed -i '' 's/GITHUBEMAIL/'$email'/' ./homedir/.gitconfig;
    sed -i '' 's/GITHUBUSER/'$githubuser'/' ./homedir/.gitconfig;
    ok
  else
    echo
    echo "looks like you are already using gnu-sed."
    sed -i 's/GITHUBEMAIL/'$email'/' ./homedir/.gitconfig;
    sed -i 's/GITHUBUSER/'$githubuser'/' ./homedir/.gitconfig;
  fi
fi

# --------------------------------
# Homebrew Installation
# --------------------------------

if test ! $(which brew); then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Checking for Homebrew Updates..."
brew update

# --------------------------------
# Homebrew Taps
# --------------------------------

tap 'caskroom/cask'
tap 'caskroom/eid'
tap 'caskroom/fonts'
tap 'caskroom/versions'
tap 'homebrew/bundle'

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

brew install caskroom/cask/brew-cask

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

open "${HOME}/iterm/Oceanic-Next.itermcolors"
brew tap homebrew/cask-fonts
brew cask install font-meslolg-nerd-font

defaults write com.googlecode.iterm2 "Normal Font" -string "MesloLGMDZN-Regular 12";

# Install oh-my-zsh

echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Install spaceship prompt + symlink
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"


# ------------------
# Dotfiles
# ------------------
echo "Copying dotfiles..."

cp .zshrc ~/.zshrc
cp .aliases ~/.aliases

echo "Installation complete! 😁"
