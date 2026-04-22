# Load the completion initializer function.
autoload -Uz compinit
# Load menu-style completion support.
zmodload zsh/complist

# Add fzf-tab to fpath before compinit.
fpath+=("$HOME/Library/Caches/antidote/github.com/Aloxaf/fzf-tab")

# Store completion dump in cache, keyed by host and zsh version.
_compdump="$XDG_CACHE_HOME/zsh/.zcompdump-${HOST}-${ZSH_VERSION}"
# Ensure completion cache directory exists.
mkdir -p "${_compdump:h}"

# Codespaces mounts can present group-writable paths that trip compinit security checks.
_compinit_flags=(-d "$_compdump")
[[ -n "${CODESPACES:-}" ]] && _compinit_flags=(-i "${_compinit_flags[@]}")

# First run builds completion dump; later runs skip expensive checks.
if [[ ! -s "$_compdump" ]]; then
  compinit "${_compinit_flags[@]}"
else
  compinit -C "${_compinit_flags[@]}"
fi
unset _compinit_flags

# Load fzf-tab immediately after compinit.
_fzf_tab_plugin="$HOME/Library/Caches/antidote/github.com/Aloxaf/fzf-tab/fzf-tab.plugin.zsh"
[[ -r "$_fzf_tab_plugin" ]] && source "$_fzf_tab_plugin"
unset _fzf_tab_plugin

# Tune fzf-tab completion UI.
# Hide preview window by default.
zstyle ':fzf-tab:*' fzf-flags --height=50% --layout=reverse --border --inline-info --preview-window=right:45%:hidden
# Switch between completion groups using < and >.
zstyle ':fzf-tab:*' switch-group '<' '>'

# Show previews for files and directories while completing (override hidden state).
zstyle ':fzf-tab:complete:*' fzf-preview '
  if [[ -d "$realpath" ]]; then
    if command -v eza >/dev/null 2>&1; then
      command eza -1 --color=always "$realpath"
    else
      command ls -A --color=always "$realpath" 2>/dev/null || command ls -A "$realpath"
    fi
  elif [[ -f "$realpath" ]]; then
    if command -v bat >/dev/null 2>&1; then
      command bat --style=plain --color=always --line-range=:200 "$realpath"
    else
      command sed -n "1,200p" "$realpath"
    fi
  fi
'

# Keep cd completion previews focused on directory listings with visible preview.
zstyle ':fzf-tab:complete:cd:*' fzf-preview '
  if command -v eza >/dev/null 2>&1; then
    command eza -1 --color=always "$realpath"
  else
    command ls -A --color=always "$realpath" 2>/dev/null || command ls -A "$realpath"
  fi
'
zstyle ':fzf-tab:complete:cd:*' fzf-flags --height=50% --layout=reverse --border --inline-info --preview-window=right:45%

# Show ls completion previews with visible preview.
zstyle ':fzf-tab:complete:ls:*' fzf-flags --height=50% --layout=reverse --border --inline-info --preview-window=right:45%

# Force fzf-tab to capture unambiguous prefix by disabling menu.
zstyle ':completion:*' menu no
# Enable group support in completions.
zstyle ':completion:*' group-name ''
# Set descriptions format to enable group support.
zstyle ':completion:*:descriptions' format '[%d]'
# Enable filename colorizing with LS_COLORS.
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# Disable sort for git checkout to show recent branches first.
zstyle ':completion:*:git-checkout:*' sort false
# Case-insensitive completion matching.
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# Cache completion results for speed.
zstyle ':completion:*' use-cache on
# Put completion cache under XDG cache.
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Shift+Tab cycles completion menu backwards.
bindkey '^[[Z' reverse-menu-complete
