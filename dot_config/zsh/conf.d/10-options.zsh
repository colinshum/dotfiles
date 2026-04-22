# Use emacs-style keybindings (zsh default and most common).
bindkey -e

# Allow typing a directory name alone to `cd` into it.
setopt AUTO_CD
# Allow `# ...` comments in interactive commands.
setopt INTERACTIVE_COMMENTS
# Disable terminal bell.
setopt NO_BEEP
# Enable richer glob patterns.
setopt EXTENDED_GLOB

# History under XDG state so it is portable and explicit.
HISTFILE="$XDG_STATE_HOME/zsh/history"
# In-memory history size for this shell.
HISTSIZE=100000
# Persisted history size on disk.
SAVEHIST=100000
# Ensure history directory exists before writing.
mkdir -p "${HISTFILE:h}"

# Append instead of overwriting history file.
setopt APPEND_HISTORY
# Include timestamp metadata in history.
setopt EXTENDED_HISTORY
# Drop duplicates first when trimming old entries.
setopt HIST_EXPIRE_DUPS_FIRST
# Skip duplicate results during history search.
setopt HIST_FIND_NO_DUPS
# Keep newest copy of duplicate commands.
setopt HIST_IGNORE_ALL_DUPS
# Ignore commands prefixed with a leading space.
setopt HIST_IGNORE_SPACE
# Normalize repeated whitespace in saved history.
setopt HIST_REDUCE_BLANKS
# Avoid writing duplicates to disk history.
setopt HIST_SAVE_NO_DUPS
# Write history incrementally during session.
setopt INC_APPEND_HISTORY
# Share history among concurrent zsh sessions.
setopt SHARE_HISTORY
