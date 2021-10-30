#!/bin/bash

if [[ $OSTYPE == 'darwin'* ]]; then
    # macOS
    # This script will ensure that you have Xcode developer tools installed before cloning
    # the dotfiles repository from GitHub. 

    # Ask for sudo upfront and keep alive until script has finished.
    sudo -v
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Check for CLI tools
    xcode-select -p
    if [[ $? != 0 ]] ; then
        echo "Xcode CLI tools not detected, proceeding with installation..."
        sudo xcode-select --install
    else
        echo "Xcode CLI tools already installed, proceeding with bootstrap..."
    fi

    which -s brew
    if [[ $? != 0 ]] ; then
        echo "Homebrew not detected, proceeding with installation..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        echo "Homebrew already installed, proceeding with bootstrap..."
    fi

    # mkdir ~/dotfiles
    cd ~/dotfiles
    # git clone https://github.com/colinshum/dotfiles.git

    # Run installation script
    set -euo pipefail 
    ruby ./lib/macos.rb
else
    # Linux
    if [ -n "$CODESPACES" ] ; then
        echo "Codespaces environment detected."
        rm $HOME/.zshrc $HOME/.zshrc-backup
        ln -s /workspaces/.codespaces/.persistedshare/dotfiles/config/.zshrc $HOME
        ln -s /workspaces/.codespaces/.persistedshare/dotfiles/config/.aliases $HOME
        ln -s /workspaces/.codespaces/.persistedshare/dotfiles/config/.zshenv $HOME
        zsh
    fi
fi
