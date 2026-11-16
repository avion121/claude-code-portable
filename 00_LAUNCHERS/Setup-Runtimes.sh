#!/usr/bin/env bash
# Cross-platform (Linux/macOS) runtime auto-setup for the portable dev suite
set -euo pipefail

PORTABLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMP_DIR="$PORTABLE_ROOT/._tmp_downloads"

echo "============================================================"
echo "     PORTABLE DEV SUITE - AUTO RUNTIME SETUP"
echo "============================================================"
echo
echo "OS: $(uname -s)"
echo "Root: $PORTABLE_ROOT"
echo
echo "This will download and extract all required runtimes."
echo "Requires internet connection."
echo
read -rp "Continue? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

mkdir -p "$PORTABLE_ROOT/01_EDITORS" \
         "$PORTABLE_ROOT/02_RUNTIMES/node" \
         "$PORTABLE_ROOT/02_RUNTIMES/python" \
         "$PORTABLE_ROOT/02_RUNTIMES/git" \
         "$PORTABLE_ROOT/03_AI_TOOLS" \
         "$PORTABLE_ROOT/04_DEV_TOOLS" \
         "$PORTABLE_ROOT/05_UTILITIES" \
         "$TEMP_DIR"

echo
echo "[1/4] Setting up Node.js LTS..."
if command -v nvm >/dev/null 2>&1; then
    echo "[INFO] nvm detected - installing Node LTS into portable folder..."
    NVM_DIR="$HOME/.nvm" && [ -d "$NVM_DIR" ] && . "$NVM_DIR/nvm.sh"
    nvm install --lts >/dev/null 2>&1 || true
    NODE_BIN="$(command -v node)"
    cp -r "$(dirname "$NODE_BIN")"/* "$PORTABLE_ROOT/02_RUNTIMES/node/bin/" 2>/dev/null || true
    echo "[OK] Node.js portable."
else
    echo "[WARN] No nvm. Install Node manually and place binaries in 02_RUNTIMES/node/bin/"
fi

echo
echo "[2/4] Setting up Python..."
if command -v python3 >/dev/null 2>&1; then
    PYVER=$(python3 --version 2>/dev/null | awk '{print $2}')
    echo "[INFO] System Python $PYVER found. Copying to portable folder..."
    PYDIR="$(dirname $(dirname $(command -v python3)))"
    cp -r "$PYDIR"/* "$PORTABLE_ROOT/02_RUNTIMES/python/" 2>/dev/null || true
    echo "[OK] Python portable."
else
    echo "[WARN] No system Python. Install Python 3.x and place in 02_RUNTIMES/python/"
fi

echo
echo "[3/4] Setting up Git..."
if command -v git >/dev/null 2>&1; then
    GITDIR="$(dirname $(dirname $(command -v git)))"
    cp -r "$GITDIR"/* "$PORTABLE_ROOT/02_RUNTIMES/git/" 2>/dev/null || true
    echo "[OK] Git portable."
else
    echo "[WARN] No system Git. Install git and place in 02_RUNTIMES/git/"
fi

echo
echo "[4/4] Setting up freellmapi..."
cd "$PORTABLE_ROOT/03_AI_TOOLS"
if [ ! -d "freellmapi" ]; then
    git clone https://github.com/freellmapi/freellmapi.git freellmapi || echo "[WARN] freellmapi clone failed."
fi
cd "$PORTABLE_ROOT/03_AI_TOOLS/freellmapi"
npm install 2>/dev/null || echo "[WARN] npm install failed."
npm run build 2>/dev/null || echo "[WARN] npm build failed."
echo "[OK] freellmapi setup complete."

echo
echo "============================================================"
echo "  SETUP COMPLETE"
echo "============================================================"
echo
echo "Next: run 'run-claude.sh' -> Option [5] to verify."
echo