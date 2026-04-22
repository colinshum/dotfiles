# Antidote plugin manager location under the active zsh home.
_antidote_home="${ZDOTDIR:-$HOME}/.antidote"
# Antidote init file that defines the `antidote` function.
_antidote_init="$_antidote_home/antidote.zsh"
# Tracked plugin manifest in this dotfiles repo.
_antidote_plugins="$ZSH_CONFIG_HOME/plugins.txt"
# Generated static plugin bundle for fast startup.
_antidote_bundle="$XDG_CACHE_HOME/zsh/.antidote-bundle.zsh"

# Only continue when a plugin manifest exists.
if [[ -r "$_antidote_plugins" ]]; then
  # Ensure cache directory for generated bundle exists.
  mkdir -p "${_antidote_bundle:h}"

  # Rebuild bundle when missing or stale.
  if [[ ! -s "$_antidote_bundle" || "$_antidote_plugins" -nt "$_antidote_bundle" ]]; then
    # Rebuild requires antidote itself to be installed.
    if [[ -r "$_antidote_init" ]]; then
      source "$_antidote_init"
      antidote bundle <"$_antidote_plugins" >| "$_antidote_bundle"
    fi
  fi

  # Load generated plugin bundle when present.
  [[ -r "$_antidote_bundle" ]] && source "$_antidote_bundle"
fi

# Cleanup internal temp variables from shell namespace.
unset _antidote_home _antidote_init _antidote_plugins _antidote_bundle
