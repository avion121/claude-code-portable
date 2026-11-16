#!/usr/bin/env bash
set -euo pipefail

PORTABLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "============================================================"
echo "     PORTABLE DEV SUITE - AUTO-UPDATE & LAUNCH"
echo "============================================================"
echo
echo "[*] Detecting OS: $(uname -s)"
echo "[*] USB Root: $PORTABLE_ROOT"
echo

echo "[*] Step 1/3: Checking for updates from GitHub..."
cd "$PORTABLE_ROOT"

git remote set-url origin https://github.com/avion121/claude-code-portable.git 2>/dev/null || true

if git fetch --quiet --tags 2>/dev/null; then
    BEFORE=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    if git pull --quiet --ff-only 2>/dev/null; then
        AFTER=$(git rev-parse HEAD)
        if [ "$BEFORE" != "$AFTER" ]; then
            echo "[OK] Updated to latest commit."
        else
            echo "[OK] Already at latest version."
        fi
    else
        echo "[WARN] Pull failed (merge conflict or offline). Continuing locally."
    fi
else
    echo "[WARN] Could not fetch updates (offline or no network). Continuing with local version."
fi

echo
echo "[*] Step 2/3: Running health checks..."

if [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.sh" ]; then
    bash "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.sh" || true
elif [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.bat" ]; then
    echo "[INFO] Windows batch verifier found; skipping on $(uname -s)."
else
    echo "[INFO] No verifier script found."
fi

echo
echo "[*] Step 3/3: Launching master control menu..."
echo

if [ -f "$PORTABLE_ROOT/PORTABLE-SUITE-MASTER.sh" ]; then
    bash "$PORTABLE_ROOT/PORTABLE-SUITE-MASTER.sh"
elif [ -f "$PORTABLE_ROOT/PORTABLE-SUITE-MASTER.bat" ]; then
    echo "[INFO] Windows master menu detected. Use run-claude.bat on Windows."
    bash -c "echo 'Running portable environment...'; export PATH=\"$PORTABLE_ROOT/02_RUNTIMES/node/bin:\$PORTABLE_ROOT/02_RUNTIMES/python/bin:\$PORTABLE_ROOT/02_RUNTIMES/git/bin:\$PATH\"; exec bash"
else
    echo "[ERROR] No master menu script found."
    exit 1
fi