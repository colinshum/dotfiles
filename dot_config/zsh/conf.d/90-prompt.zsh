# Initialize Starship prompt only when installed.
if command -v starship >/dev/null 2>&1; then
  # Inject Starship prompt hooks into current zsh session.
  eval "$(starship init zsh)"
fi
