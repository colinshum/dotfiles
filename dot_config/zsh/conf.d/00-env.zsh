# Keep PATH/fpath entries unique when prepending.
typeset -U path PATH fpath

# Guarantee core system paths exist even if parent PATH is broken.
# This prevents "command not found" for essentials like mkdir/touch/uname.
for _sys_dir in /usr/bin /bin /usr/sbin /sbin; do
  (( ${path[(I)$_sys_dir]} )) || path+=("$_sys_dir")
done

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
# Ensure baseline zsh function paths exist for autoloaded functions like compinit.
[[ -d "/usr/share/zsh/site-functions" ]] && fpath=("/usr/share/zsh/site-functions" $fpath)
[[ -d "/usr/share/zsh/vendor-functions" ]] && fpath=("/usr/share/zsh/vendor-functions" $fpath)
[[ -d "/usr/share/zsh/vendor-completions" ]] && fpath=("/usr/share/zsh/vendor-completions" $fpath)
# Some Linux distros (including Codespaces images) ship zsh functions under /usr/share/zsh/functions/*
for _zfunc_dir in /usr/share/zsh/functions(/N) /usr/share/zsh/functions/*(/N) /usr/share/zsh/functions/*/*(/N); do
  fpath=("$_zfunc_dir" $fpath)
done
unset _zfunc_dir

# Cleanup temporary loop variable.
unset _sys_dir

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
