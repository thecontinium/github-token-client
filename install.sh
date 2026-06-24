#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "🛠️ GitHub CLI & Git Secure Wrapper Installer"
echo "=================================================="

# 1. Verify a real underlying gh installation exists somewhere
if [ ! -x "/opt/homebrew/bin/gh" ] && [ ! -x "/usr/local/bin/gh" ]; then
    echo "❌ Error: 'gh' is not installed via Homebrew." >&2
    echo "Please ask the central brew owner to run: brew install gh" >&2
    exit 1
fi

# 2. Install wrapper script straight into user space shadowing the global gh command
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"
cp github-client-service "$LOCAL_BIN/gh"
chmod +x "$LOCAL_BIN/gh"

# 3. Route native git commands through the SSH tunnel port
echo "⚙️ Routing native global git config through localhost tunnel..."
git config --global credential.helper "" # Clear old configurations
git config --global credential.helper '!f() { \
    if [ "$1" = "get" ]; then \
        TOKEN=$(curl -s --max-time 3 http://127.0.0.1:8080); \
        echo "username=x-access-token"; \
        echo "password=$TOKEN"; \
    fi \
}; f'

# 4. Detect shell profile and append path variable rule if missing
echo "⚙️ Verifying environment PATH configuration..."
SHELL_PROFILE=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_PROFILE="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    if [ -f "$HOME/.bash_profile" ]; then
        SHELL_PROFILE="$HOME/.bash_profile"
    else
        SHELL_PROFILE="$HOME/.bashrc"
    fi
fi

PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

if [ -n "$SHELL_PROFILE" ]; then
    if [ -f "$SHELL_PROFILE" ] && grep -Fq "$PATH_LINE" "$SHELL_PROFILE"; then
        echo "✅ Path precedence rule already exists in $SHELL_PROFILE"
    else
        echo "📝 Appending path precedence rule to $SHELL_PROFILE..."
        echo "" >> "$SHELL_PROFILE"
        echo "# Priority pathing for user-space tools (LiteLLM, GH Interceptor)" >> "$SHELL_PROFILE"
        echo "$PATH_LINE" >> "$SHELL_PROFILE"
    fi
else
    echo "⚠️ Could not auto-detect shell profile. Please add manually: $PATH_LINE"
fi

echo "=================================================="
echo "🎉 Replacement Complete! Old Formula Displaced."
echo "=================================================="
echo "👉 Run the following command to update your active terminal:"
echo "   source $SHELL_PROFILE"
echo "=================================================="
