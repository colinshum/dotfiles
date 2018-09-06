# oh-my-zsh
export ZSH="/Users/colinshum/.oh-my-zsh"

# theme
ZSH_THEME="/themes/spaceship-prompt/spaceship"

# spaceship
SPACESHIP_PROMPT_ADD_NEWLINE="true"
SPACESHIP_CHAR_SYMBOL=" \uf0e7"
SPACESHIP_CHAR_PREFIX="\uf296"
SPACESHIP_CHAR_SUFFIX=(" ")
SPACESHIP_CHAR_COLOR_SUCCESS="yellow"
SPACESHIP_PROMPT_DEFAULT_PREFIX="$USER"
SPACESHIP_PROMPT_FIRST_PREFIX_SHOW="true"
SPACESHIP_USER_SHOW="true"

# aliases
source ~/.aliases

# plugins
plugins=(
  git
  osx
  vscode
  rails
)

source $ZSH/oh-my-zsh.sh
