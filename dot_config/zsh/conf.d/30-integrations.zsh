# Activate mise shims/environment when available.
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Enable automatic .envrc loading on directory changes.
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# Enable smart directory jumping (`z`).
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# Enable fzf keybindings and completion from common install locations.
if command -v fzf >/dev/null 2>&1; then
  # Check common Homebrew and manual install prefixes.
  for _fzf in /opt/homebrew/opt/fzf /usr/local/opt/fzf "$HOME/.fzf" /usr/share/fzf; do
    # Load first matching shell integration bundle.
    if [[ -r "$_fzf/shell/key-bindings.zsh" ]]; then
      source "$_fzf/shell/key-bindings.zsh"
      [[ -r "$_fzf/shell/completion.zsh" ]] && source "$_fzf/shell/completion.zsh"
      break
    fi
  done
  # Cleanup temporary loop variable.
  unset _fzf
fi
