# Keep PATH/fpath entries unique when prepending.
typeset -U path PATH fpath FPATH

# Prefer user and package-manager binaries before system defaults.
# User-level binaries (pipx, cargo, custom scripts).
[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
# Homebrew on Apple Silicon.
[[ -d "/opt/homebrew/bin" ]] && path=("/opt/homebrew/bin" $path)
# Homebrew admin tools on Apple Silicon.
[[ -d "/opt/homebrew/sbin" ]] && path=("/opt/homebrew/sbin" $path)
# Homebrew/other tools on Intel macOS and many Linux machines.
[[ -d "/usr/local/bin" ]] && path=("/usr/local/bin" $path)
# Admin tools on Intel macOS and many Linux machines.
[[ -d "/usr/local/sbin" ]] && path=("/usr/local/sbin" $path)

# Make Homebrew-provided zsh completions discoverable.
[[ -d "/opt/homebrew/share/zsh/site-functions" ]] && fpath=("/opt/homebrew/share/zsh/site-functions" $fpath)
[[ -d "/usr/local/share/zsh/site-functions" ]] && fpath=("/usr/local/share/zsh/site-functions" $fpath)

# Export final PATH to child processes.
export PATH
# Default terminal editor if not already set by host.
export EDITOR="${EDITOR:-nvim}"
# GUI/editor fallback uses EDITOR by default.
export VISUAL="${VISUAL:-$EDITOR}"
# Git editor follows EDITOR unless explicitly overridden.
export GIT_EDITOR="${GIT_EDITOR:-$EDITOR}"
# Pager fallback for long command output.
export PAGER="${PAGER:-less}"
