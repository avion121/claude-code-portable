#!/usr/bin/env bash
# Fully automatic portable dev suite launcher (Linux/macOS)
set -uo pipefail

PORTABLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================================"
echo "     PORTABLE DEV SUITE - FULLY AUTOMATIC LAUNCH"
echo "============================================================"
echo "[*] USB Root: $PORTABLE_ROOT"
echo

# Step 1: Auto-update from GitHub
echo "[*] Step 1/4: Checking for updates from GitHub..."
cd "$PORTABLE_ROOT"
if [ -d .git ]; then
    git remote set-url origin https://github.com/avion121/claude-code-portable.git 2>/dev/null || true
    if git fetch --quiet 2>/dev/null; then
        if git pull --quiet --ff-only 2>/dev/null; then
            echo "[OK] Updated to latest version."
        else
            echo "[WARN] Pull failed (merge conflict). Continuing locally."
        fi
    else
        echo "[WARN] Could not fetch updates (offline). Continuing locally."
    fi
else
    echo "[WARN] Not a git repo - skipping update."
fi

# Step 2: Auto-setup runtimes if missing
echo
echo "[*] Step 2/4: Checking runtimes..."
if [ -x "$PORTABLE_ROOT/02_RUNTIMES/node/bin/node" ] || command -v node >/dev/null 2>&1; then
    echo "[OK] Node.js available."
else
    echo "[INFO] Node.js missing - running auto-setup..."
    [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh" ] && bash "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh"
fi
if [ -x "$PORTABLE_ROOT/02_RUNTIMES/git/bin/git" ] || command -v git >/dev/null 2>&1; then
    echo "[OK] Git available."
else
    echo "[INFO] Git missing - running auto-setup..."
    [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh" ] && bash "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh"
fi
if [ -x "$PORTABLE_ROOT/02_RUNTIMES/python/bin/python3" ] || command -v python3 >/dev/null 2>&1; then
    echo "[OK] Python available."
else
    echo "[INFO] Python missing - running auto-setup..."
    [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh" ] && bash "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh"
fi
if [ -f "$PORTABLE_ROOT/03_AI_TOOLS/freellmapi/dist/index.js" ]; then
    echo "[OK] freellmapi already built."
else
    echo "[INFO] freellmapi missing - running auto-setup..."
    [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh" ] && bash "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh"
fi

# Step 3: Health check
echo
echo "[*] Step 3/4: Running health check..."
if [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.sh" ]; then
    bash "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.sh" || true
elif [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.bat" ]; then
    echo "[INFO] Windows batch verifier found; skipping on $(uname -s)."
else
    echo "[INFO] No verifier script found."
fi

# Step 4: Launch VS Code
echo
echo "[*] Step 4/4: Launching VS Code..."
export PATH="$PORTABLE_ROOT/02_RUNTIMES/node/bin:$PORTABLE_ROOT/02_RUNTIMES/python/bin:$PORTABLE_ROOT/02_RUNTIMES/git/bin:$PATH"
export NPM_CONFIG_CACHE="$PORTABLE_ROOT/02_RUNTIMES/node/.npm-cache"

if [ -x "$PORTABLE_ROOT/01_EDITORS/VSCode-Portable/code" ]; then
    "$PORTABLE_ROOT/01_EDITORS/VSCode-Portable/code" &
    echo "[OK] VS Code launched."
elif command -v code >/dev/null 2>&1; then
    code "$PORTABLE_ROOT" &
    echo "[OK] System VS Code launched."
else
    echo "[ERROR] VS Code Portable not found at 01_EDITORS/VSCode-Portable/code"
    exit 1
fi

echo
echo "[OK] Portable environment fully loaded."
echo "[*] VS Code is running. Use the terminal to run Claude Code CLI:"
echo "     node 03_AI_TOOLS/freellmapi/dist/index.js launch"
echo