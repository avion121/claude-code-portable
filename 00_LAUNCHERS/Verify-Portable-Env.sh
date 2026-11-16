#!/usr/bin/env bash
set -uo pipefail

PORTABLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ERR=0

echo "============================================================"
echo "     PORTABLE DEV SUITE - HEALTH CHECK"
echo "============================================================"
echo

check() {
    local label="$1"; shift
    if command -v "$1" >/dev/null 2>&1; then
        echo "[OK] $label ($1: $($1 --version 2>/dev/null | head -n1))"
    else
        echo "[WARN] $label not found in PATH"
        ERR=$((ERR+1))
    fi
}

echo "--- Core Runtimes ---"
check "Node.js" node
check "Python" python3
check "Git" git
check "npm" npm

echo
echo "--- AI Tools ---"
if [ -x "$PORTABLE_ROOT/03_AI_TOOLS/freellmapi/dist/index.js" ] || [ -f "$PORTABLE_ROOT/03_AI_TOOLS/freellmapi/dist/index.js" ]; then
    echo "[OK] freellmapi CLI build present"
else
    echo "[WARN] freellmapi build missing"
    ERR=$((ERR+1))
fi

echo
echo "--- Editors ---"
for f in \
    "$PORTABLE_ROOT/01_EDITORS/VSCode-Portable/code"; do
    if [ -x "$f" ] || [ -f "$f" ]; then
        echo "[OK] Found: $f"
    else
        echo "[WARN] Missing: $f"
    fi
done

echo
echo "------------------------------------------------------------"
if [ "$ERR" -eq 0 ]; then
    echo "STATUS: READY - Portable environment passes all core checks."
else
    echo "STATUS: ATTENTION NEEDED ($ERR missing item(s))."
fi
echo "------------------------------------------------------------"

exit $ERR