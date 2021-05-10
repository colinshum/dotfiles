#!/usr/bin/env bash

# VSCode Setup Script

# Open/Close VSCode to generate preferences for the first time
osascript -e 'tell application "Visual Studio Code" to activate'
sleep 2
osascript -e 'tell application "Visual Studio Code" to quit'

# Reload ~/.zshrc to ensure we have access to `code` command in path
source ~/.zshrc

# Install extensions
# To list all your extensions: `code --list-extensions`
pkglist=(
    arcticicestudio.nord-visual-studio-code
    earshinov.sort-lines-by-selection
    rebornix.ruby
    wingrunr21.vscode-ruby
)

for i in ${pkglist[@]}; do
  code --install-extension $i
done

# Ensure VSCode is closed
osascript -e 'tell application "Visual Studio Code" to quit'

# Symlink VSCode preferences
mv ~/Library/Application\ Support/Code/User/settings.json ~/Library/Application\ Support/Code/User/settings_backup.json
mv ~/Library/Application\ Support/Code/User/keybindings.json ~/Library/Application\ Support/Code/User/keybindings_backup.json

if [ -f ~/Library/Application\ Support/Code/User/snippets/ ]; then  
  mv ~/Library/Application\ Support/Code/User/snippets/ ~/Library/Application\ Support/Code/User/snippets_backup/
fi

ln -s ~/dotfiles/config/apps/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
ln -s ~/dotfiles/config/apps/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
# ln -s ~/dotfiles/config/apps/vscode/snippets/ ~/Library/Application\ Support/Code/User/snippets/