#!/bin/bash
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROFILE_NAME="darch-kde-profile"
CONFIG_DIR="$HOME/.config/konsave"

echo -e "${BLUE}🎨 DARCH KDE Profile Export${NC}"
echo "================================"

if ! command -v konsave &> /dev/null; then
    echo -e "${YELLOW}⚠️  konsave not installed. Installing...${NC}"
    yay -S --noconfirm konsave
fi

mkdir -p "$CONFIG_DIR"

if konsave -l | grep -q "$PROFILE_NAME"; then
    echo -e "${YELLOW}📋 Profile '$PROFILE_NAME' exists, updating...${NC}"
    konsave -r "$PROFILE_NAME"
else
    echo -e "${GREEN}📋 Creating new profile '$PROFILE_NAME'...${NC}"
    konsave -s "$PROFILE_NAME"
fi

echo -e "${GREEN}📤 Exporting profile to file...${NC}"
konsave -e "$PROFILE_NAME" -d "$CONFIG_DIR"

EXPORT_FILE="$CONFIG_DIR/${PROFILE_NAME}.knsv"
if [[ -f "$EXPORT_FILE" ]]; then
    echo -e "${GREEN}✅ KDE profile exported to: $EXPORT_FILE${NC}"
    echo ""
    echo -e "${BLUE}To track in git:${NC}"
    echo "  git dotfiles add $EXPORT_FILE"
    echo "  git dotfiles commit -m 'Update KDE profile'"
else
    echo -e "${YELLOW}⚠️  Export file not found at $EXPORT_FILE${NC}"
fi
