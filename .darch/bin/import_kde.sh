#!/bin/bash
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

PROFILE_NAME="darch-kde-profile"
CONFIG_DIR="$HOME/.config/konsave"
EXPORT_FILE="$CONFIG_DIR/${PROFILE_NAME}.knsv"

echo -e "${BLUE}🎨 DARCH KDE Profile Import${NC}"
echo "================================"

if ! command -v konsave &> /dev/null; then
    echo -e "${YELLOW}⚠️  konsave not installed. Skipping KDE import.${NC}"
    exit 0
fi

if [[ ! -f "$EXPORT_FILE" ]]; then
    echo -e "${YELLOW}⚠️  KDE profile not found at $EXPORT_FILE${NC}"
    echo "    Skipping KDE import."
    exit 0
fi

echo -e "${GREEN}📥 Importing KDE profile...${NC}"
konsave -i "$EXPORT_FILE"

echo -e "${GREEN}📋 Activating profile '$PROFILE_NAME'...${NC}"
if konsave -l | grep -q "$PROFILE_NAME"; then
    konsave -a "$PROFILE_NAME"
    echo -e "${GREEN}✅ KDE profile applied!${NC}"
    echo -e "${YELLOW}   Log out and back in for full effect.${NC}"
else
    echo -e "${YELLOW}⚠️  Profile import may have failed${NC}"
fi
