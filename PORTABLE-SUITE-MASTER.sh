#!/usr/bin/env bash
# Cross-platform (Linux/macOS) master control menu for the portable dev suite
set -uo pipefail

PORTABLE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PATH="$PORTABLE_ROOT/02_RUNTIMES/node/bin:$PORTABLE_ROOT/02_RUNTIMES/python/bin:$PORTABLE_ROOT/02_RUNTIMES/python/bin:$PORTABLE_ROOT/02_RUNTIMES/git/bin:$PORTABLE_ROOT/05_UTILITIES/7-Zip-Portable:$PATH"
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
    echo "  [3] Launch Terminal"
    echo "  [4] Open Developer Prompt (Node + Python + Git)"
    echo "  [5] Run System Health & Environment Check"
    echo "  [6] Initialize Git & Push to GitHub (avion121)"
    echo "  [7] Auto-Setup Directory Structure"
    echo "  [8] Auto-Download & Setup All Runtimes (First Time)"
    echo "  [0] Exit"
    echo
    echo "============================================================"
    read -rp "Select an option (0-8) and press Enter: " choice
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
            echo "[OK] Launching terminal..."
            if [ -n "${TMUX:-}" ] || [ -n "${STY:-}" ]; then
                echo "[INFO] Already inside a terminal multiplexer."
            else
                exec "$SHELL"
            fi
            ;;
        4)
            clear
            echo "============================================================"
            echo "     PORTABLE DEVELOPER PROMPT"
            echo "============================================================"
            echo "Environment loaded with Node, Python, Git."
            echo
            exec "$SHELL"
            ;;
        5)
            clear
            if [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.sh" ]; then
                bash "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.sh"
            else
                bash "$PORTABLE_ROOT/00_LAUNCHERS/Verify-Portable-Env.bat" 2>/dev/null || echo "[INFO] No verifier available on this OS."
            fi
            read -rp "Press Enter to return to menu..."
            ;;
        6)
            clear
            echo "============================================================"
            echo "     GIT INITIALIZATION & GITHUB PUSH (avion121)"
            echo "============================================================"
            echo
            echo "Target Repository: https://github.com/avion121/claude-code-portable.git"
            echo
            read -rp "Proceed with Git commit and push? (y/N): " confirm
            if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
                continue
            fi
            cd "$PORTABLE_ROOT"
            git init
            git add .
            git commit -m "feat: portable dev suite cross-platform update" || echo "[INFO] Nothing to commit."
            git branch -M main
            git remote remove origin >/dev/null 2>&1
            git remote add origin https://github.com/avion121/claude-code-portable.git
            git push -u origin main
            read -rp "Press Enter to return to menu..."
            ;;
        7)
            clear
            mkdir -p "$PORTABLE_ROOT/00_LAUNCHERS" "$PORTABLE_ROOT/01_EDITORS" \
                     "$PORTABLE_ROOT/02_RUNTIMES" "$PORTABLE_ROOT/02_RUNTIMES/python-portable" \
                     "$PORTABLE_ROOT/03_AI_TOOLS" "$PORTABLE_ROOT/04_DEV_TOOLS" \
                     "$PORTABLE_ROOT/05_UTILITIES" "$PORTABLE_ROOT/05_UTILITIES/Windows-Terminal" \
                     "$PORTABLE_ROOT/05_UTILITIES/Fiddler" "$PORTABLE_ROOT/05_UTILITIES/pageant" \
                     "$PORTABLE_ROOT/05_UTILITIES/7-Zip-Portable"
            echo "[OK] All directories verified/created."
            read -rp "Press Enter to return to menu..."
            ;;
        8)
            clear
            if [ -f "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh" ]; then
                bash "$PORTABLE_ROOT/00_LAUNCHERS/Setup-Runtimes.sh"
            else
                echo "[WARN] Linux/macOS setup script not found. Use the Windows one or run manually."
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