#!/usr/bin/env bash
# Cross-platform (Linux/macOS) master control menu for the portable dev suite
set -uo pipefail

PORTABLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PATH="$PORTABLE_ROOT/02_RUNTIMES/node/bin:$PORTABLE_ROOT/02_RUNTIMES/python/bin:$PORTABLE_ROOT/02_RUNTIMES/git/bin:$PATH"
export NPM_CONFIG_CACHE="$PORTABLE_ROOT/02_RUNTIMES/node/.npm-cache"

menu() {
    clear
    echo "============================================================"
    echo "     PORTABLE CLAUDE CODE CLI & DEV SUITE MASTER CONTROL"
    echo "============================================================"
    echo "  OS: $(uname -s)"
    echo "  Root: $PORTABLE_ROOT"
    echo "============================================================"
    echo
    echo "  [1] Launch Claude Code CLI (via freellmapi zero-trace)"
    echo "  [2] Launch Portable VS Code"
    echo "  [3] Open Developer Prompt (Node + Python + Git)"
    echo "  [4] Run System Health & Environment Check"
    echo "  [0] Exit"
    echo
    echo "============================================================"
    read -rp "Select an option (0-4) and press Enter: " choice
}

while true; do
    menu
    case "$choice" in
        1)
            clear
            echo "============================================================"
            echo "     LAUNCHING PORTABLE CLAUDE CODE CLI (freellmapi)"
            echo "============================================================"
            echo
            FREELL="$PORTABLE_ROOT/03_AI_TOOLS/freellmapi/dist/index.js"
            if [ -f "$FREELL" ]; then
                echo "[*] Step 1: Dry-run verification..."
                node "$FREELL" launch --dry-run || true
                echo
                echo "[*] Step 2: Executing Claude Code CLI via freellmapi..."
                node "$FREELL" launch
            else
                echo "[ERROR] freellmapi not found at $FREELL"
            fi
            read -rp "Press Enter to return to menu..."
            ;;
        2)
            clear
            if [ -x "$PORTABLE_ROOT/01_EDITORS/VSCode-Portable/code" ]; then
                "$PORTABLE_ROOT/01_EDITORS/VSCode-Portable/code" &
                echo "[OK] VS Code launched."
            else
                echo "[ERROR] VS Code Portable binary not found."
            fi
            read -rp "Press Enter to return to menu..."
            ;;
        3)
            clear
            echo "============================================================"
            echo "     PORTABLE DEVELOPER PROMPT"
            echo "============================================================"
            echo "Environment loaded with Node, Python, Git."
            echo
            exec "$SHELL"
            ;;
        4)
            clear
            if [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.sh" ]; then
                bash "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.sh"
            else
                bash "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.bat" 2>/dev/null || echo "[INFO] No verifier available on this OS."
            fi
            read -rp "Press Enter to return to menu..."
            ;;
        0)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            echo "Invalid option. Press Enter to continue..."
            read -rp ""
            ;;
    esac
done