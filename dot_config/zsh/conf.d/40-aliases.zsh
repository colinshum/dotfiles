# Directory listing.
if command -v eza >/dev/null 2>&1; then
  # Richer default listing with directories grouped first.
  alias ls='eza --group-directories-first'
  # Long listing including hidden files and git metadata.
  alias ll='eza -la --git --group-directories-first'
  # Tree view listing.
  alias lt='eza -laT --group-directories-first'
else
  # GNU ls color flag.
  if ls --color=auto >/dev/null 2>&1; then
    alias ls='ls --color=auto'
  else
    # BSD/macOS ls color flag.
    alias ls='ls -G'
  fi
  # Portable fallback list aliases.
  alias ll='ls -lah'
  alias la='ls -A'
fi

# QoL.
# Go up one directory.
alias ..='cd ..'
# Go up two directories.
alias ...='cd ../..'
# Clear terminal screen.
alias c='clear'
# Make directories recursively.
alias md='mkdir -p'

# Reload shell config. In the sandbox dev shell, do a full in-place restart.
# Remove any existing alias so function creation is always safe.
unalias reload 2>/dev/null
reload() {
  # Exported by scripts/dev-shell; empty outside sandbox.
  local dev_root="${DOTFILES_DEV_ROOT:-}"

  # Fallback: infer repo root via symlinked ~/.zshrc.
  if [[ -z "$dev_root" && -L "$HOME/.zshrc" ]]; then
    dev_root="$(cd -P -- "$(dirname -- "$HOME/.zshrc")/.." && pwd)"
  fi

  # In dev shell, restart through wrapper to refresh env and symlinks.
  if [[ -n "${DOTFILES_DEV_SHELL:-}" && -x "$dev_root/scripts/dev-shell" ]]; then
    exec "$dev_root/scripts/dev-shell"
  fi
  # Outside dev shell, just re-source current config.
  source ~/.zshrc
}

# Config shortcuts.
# Edit top-level modular zsh loader.
alias zshrc='$EDITOR ~/.config/zsh/zshrc'
# Edit aliases module quickly.
alias zaliases='$EDITOR ~/.config/zsh/conf.d/40-aliases.zsh'
# Edit options/history module quickly.
alias zoptions='$EDITOR ~/.config/zsh/conf.d/10-options.zsh'

# Git.
alias g='git'
alias ga='git add'
alias gap='git add -p'
alias gc='git commit'
alias gcm='git commit -m'
alias gcan='git commit --amend --no-edit'
alias gb='git branch'
alias gco='git checkout'
alias gsw='git switch'
alias gd='git diff'
alias gl='git log --oneline --decorate --graph --all'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull --rebase --autostash'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbi='git rebase -i'
alias gs='git status -sb'
alias gst='git stash'

# Common dev helpers.
alias dbrebuild='rake db:drop && rake db:setup'
alias ssd='script/server --debug'
alias gqlschema='bin/dump-graphql-schema'
alias rt='bin/rails test'

# Platform CLIs.
alias d='docker'
alias dc='docker compose'
alias k='kubectl'

# Codespaces helpers.
ghcs-github() {
  # Require a name argument for the new codespace.
  if [[ -z "${1:-}" ]]; then
    echo "usage: ghcs-github <name>" >&2
    return 2
  fi
  # Create a github/github codespace with your preferred machine size.
  gh codespace create -r github/github --devcontainer-path .devcontainer/devcontainer.json -m xLargePremiumLinux -d "$1"
}
# SSH into an existing codespace by name.
alias ghcs-ssh='gh codespace ssh -c'

mkcd() {
  # Require a destination argument.
  if [[ -z "${1:-}" ]]; then
    echo "usage: mkcd <dir>" >&2
    return 2
  fi
  # Create directory path and enter it in one command.
  mkdir -p -- "$1" && cd -- "$1"
}
