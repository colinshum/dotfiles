# oh-my-zsh
export ZSH="${HOME}/.oh-my-zsh"

# theme
if [ -n "$CODESPACES" ]; then
  ZSH_THEME="codespaces"
else
  ZSH_THEME="spaceship-prompt/spaceship"
fi

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

# env
source ~/.zshenv

# plugins
plugins=(
  git
  macos
  vscode
  rails
)

source $ZSH/oh-my-zsh.sh
export GEM_HOME="$HOME/.gem"
