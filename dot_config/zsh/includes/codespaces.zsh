# Codespaces-specific UX defaults.
if command -v code >/dev/null 2>&1; then
  # Prefer opening files in VS Code when running in Codespaces.
  export EDITOR="${EDITOR:-code --wait}"
  # Keep VISUAL aligned with EDITOR.
  export VISUAL="${VISUAL:-$EDITOR}"
fi

# Open current repository page in browser.
alias repo='gh repo view --web'
# Open current workspace in existing VS Code window.
alias browse='code -r .'
