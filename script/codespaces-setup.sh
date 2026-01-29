#!/bin/bash
# Codespaces-specific setup - runs automatically when Codespace starts

set -e

# Only run in Codespaces environment
if [ "$CODESPACES" = "true" ]; then
    echo "🚀 Setting up Codespaces environment..."

    # Install opencode
    echo "📦 Installing opencode..."
    curl -fsSL https://opencode.ai/install | bash

    # Add to PATH for current and future sessions
    export PATH="$HOME/.local/bin:$PATH"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true

    echo "✅ Codespaces setup complete!"
    echo "   - opencode is installed (run 'opencode' to start)"
    echo "   - From your host, run: gh codespace ssh -c \$CODESPACE_NAME"
fi
