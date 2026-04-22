# Dotfiles

Personal dotfiles managed with [chezmoi](https://www.chezmoi.io/).

## Features

| Category | Tools | Description |
|----------|-------|-------------|
| **Shell** | Zsh, antidote | Modern zsh configuration with fast plugin loading |
| **Plugins** | zsh-autosuggestions, fzf-tab, fast-syntax-highlighting | Command suggestions, fuzzy completion, syntax highlighting |
| **CLI Tools** | eza, bat, ripgrep, fd, fzf, zoxide, delta | Modern replacements for ls, cat, grep, find, cd, git diff |
| **Completion** | fzf-tab | Fuzzy completion with smart previews (eza/bat), group support |
| **Terminal** | Zellij | Multiplexer with Catppuccin Macchiato theme, custom layouts |
| **Editor** | Neovim + LazyVim | IDE-like features with LSP, treesitter, telescope |
| **Git** | Delta, aliases | Side-by-side diffs, useful shortcuts, sensible defaults |
| **Integrations** | mise, direnv, zoxide, fzf | Auto-environment loading, smart directory jumping |

## Installation

### macOS

```bash
# Install chezmoi
brew install chezmoi

# Initialize and apply dotfiles
chezmoi init --apply colinshum/dotfiles
```

### GitHub Codespaces

Configure dotfiles in [GitHub Settings → Codespaces](https://github.com/settings/codespaces):
- Repository: `colinshum/dotfiles`

Codespaces will automatically:
1. Clone your dotfiles
2. Run `install.sh` to setup chezmoi
3. Install neovim 0.11.4, starship, eza, bat, ripgrep, fzf, delta, zellij
4. Apply your configuration

## Usage

### Zellij Layouts

After SSH into a codespace:

```bash
# For monorepo work
zellij --layout cs-gh

# For frontend work
zellij --layout cs-cafe
```

### Useful Commands

| Command | Description |
|---------|-------------|
| `z <dir>` | Jump to frecent directories with zoxide |
| `reload` | Reload zsh configuration |
| `git s` | Short status |
| `git l` | Pretty log with graph |
| `git amend` | Amend without editing message |
| `git undo` | Undo last commit but keep changes |
| `git branches` | Show branches sorted by last modified |
| `git cleanup` | Remove merged branches |

### fzf Keybindings

| Keybinding | Description |
|------------|-------------|
| `Ctrl+R` | Fuzzy search command history |
| `Ctrl+T` | Fuzzy find files |
| `Alt+C` | Fuzzy cd into directories |
| `<` / `>` | Switch completion groups in fzf-tab |

## Structure

```
.
├── dot_config/
│   ├── git/ignore              # Global gitignore
│   ├── nvim/                   # LazyVim configuration
│   ├── zellij/
│   │   ├── config.kdl          # Zellij config with Catppuccin theme
│   │   └── layouts/            # Custom layouts (cs-gh, cs-cafe)
│   └── zsh/
│       ├── conf.d/             # Modular zsh configuration
│       └── plugins.txt         # Antidote plugin manifest
├── dot_gitconfig               # Git configuration
├── dot_zshrc                   # Zsh entrypoint
└── run_once_before_install-packages.sh.tmpl  # Codespaces setup
```

## Customization

### Add a new zsh plugin

Edit `dot_config/zsh/plugins.txt` and add the plugin:

```
owner/repo
```

Run `reload` to install and activate.

### Create a new Zellij layout

Add a new `.kdl` file in `~/.config/zellij/layouts/`:

```kdl
layout {
    tab name="dev" {
        pane
    }
}
```

Launch with: `zellij --layout <name>`
