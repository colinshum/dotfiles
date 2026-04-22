# Load the completion initializer function.
autoload -Uz compinit
# Load menu-style completion support.
zmodload zsh/complist

# Store completion dump in cache, keyed by host and zsh version.
_compdump="$XDG_CACHE_HOME/zsh/.zcompdump-${HOST}-${ZSH_VERSION}"
# Ensure completion cache directory exists.
mkdir -p "${_compdump:h}"

# First run builds completion dump; later runs skip expensive checks.
if [[ ! -s "$_compdump" ]]; then
  compinit -d "$_compdump"
else
  compinit -C -d "$_compdump"
fi

# Show interactive selection menu for ambiguous completions.
zstyle ':completion:*' menu select
# Case-insensitive completion matching.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Cache completion results for speed.
zstyle ':completion:*' use-cache on
# Put completion cache under XDG cache.
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Shift+Tab cycles completion menu backwards.
bindkey '^[[Z' reverse-menu-complete
