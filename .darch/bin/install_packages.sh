#!/bin/bash
set -euo pipefail
trap 'echo -e "\033[0;31m❌ Error in $0 at line $LINENO\033[0m" >&2' ERR

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Detect git worktree for bare repo setup
DOT_GIT="/usr/bin/git --git-dir=$HOME/.darch --work-tree=$HOME"

# Multiple possible locations for pkglist (supports both bare and regular clone)
PKGLIST_LOCATIONS=(
    "$HOME/.config/pkglist_native.txt"                    # Standard location (bare repo)
    "$HOME/dotfiles/.config/pkglist_native.txt"          # Regular clone location
    "$HOME/pkglist_native.txt"                          # Legacy/root location
    "./pkglist_native.txt"                              # Current directory (for repo root)
    "./.config/pkglist_native.txt"                      # Repo root config folder
    "$($DOT_GIT rev-parse --show-toplevel 2>/dev/null)/.config/pkglist_native.txt"  # Bare repo root
    "/home/dcap/pkglist_native.txt"                     # Fallback
)

PKGLIST=""

# Find first existing pkglist
for location in "${PKGLIST_LOCATIONS[@]}"; do
    if [[ -f "$location" ]]; then
        PKGLIST="$location"
        echo -e "${GREEN}📋 Using package list: $PKGLIST${NC}"
        break
    fi
done

# Validate package list
if [[ ! -f "$PKGLIST" ]] || [[ ! -r "$PKGLIST" ]]; then
    echo -e "${RED}❌ Error: Cannot read package list: $PKGLIST${NC}"
    exit 1
fi

if [[ ! -s "$PKGLIST" ]]; then
    echo -e "${YELLOW}⚠️ Warning: Package list is empty: $PKGLIST${NC}"
    echo -e "${YELLOW}Please add packages to list or create it.${NC}"
    exit 0
fi

# Check if display session is active
if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
    echo -e "${YELLOW}⚠️ Active display session detected${NC}"
    echo "This script performs a full system upgrade which may break the display manager."
    echo ""
    read -p "Continue anyway? [y/N]: " confirm
    [[ "$confirm" != "y" ]] && {
        echo -e "${YELLOW}Installation cancelled${NC}"
        exit 0
    }
fi

echo "📦 DARCH: Synchronizing packages via Yay..."

# 1. Update system first
yay -Syu --noconfirm

# 2. Extract package names (ignoring versions) and install
# sed 's/ .*//' takes "discord 1:0.0.119-1" and turns it into "discord"
sed 's/ .*//' "$PKGLIST" | xargs yay -S --noconfirm --needed

echo -e "${GREEN}✅ Package synchronization complete.${NC}"
