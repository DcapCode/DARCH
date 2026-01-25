#!/bin/bash
set -euo pipefail
trap 'echo -e "\033[0;31m❌ Error in $0 at line $LINENO\033[0m" >&2' ERR

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

if [[ -d "$HOME/.darch" ]]; then
    GIT_CMD="/usr/bin/git --git-dir=$HOME/.darch --work-tree=$HOME"
    echo -e "${BLUE}🔄 Syncing (bare repo mode)...${NC}"
else
    echo -e "${YELLOW}⚠️ No bare repository found${NC}"
    echo "Please run ~/.darch.bootstrap.sh first"
    exit 1
fi

echo -e "${GREEN}📥 Pulling changes from remote...${NC}"
$GIT_CMD pull

if $GIT_CMD rev-parse HEAD@{1} >/dev/null 2>&1; then
    if $GIT_CMD diff HEAD@{1} HEAD -- ".config/pkglist*.txt" | grep -q "^++"; then
        echo -e "${GREEN}📦 Package lists changed, updating...${NC}"
        if [[ -f "$HOME/.darch/bin/install_packages.sh" ]]; then
            bash "$HOME/.darch/bin/install_packages.sh"
        fi
    fi
    
    if $GIT_CMD diff HEAD@{1} HEAD -- ".config/*services.txt" | grep -q "^++"; then
        echo -e "${GREEN}🔌 Service lists changed, updating...${NC}"
        if [[ -f "$HOME/.darch/bin/enable_services.sh" ]]; then
            bash "$HOME/.darch/bin/enable_services.sh"
        fi
    fi
    
    if $GIT_CMD diff HEAD@{1} HEAD -- ".config/*.conf" ".config/*.json" ".config/k*" ".config/*.rc" | grep -q "^++"; then
        echo -e "${GREEN}⚙️  Configuration files changed${NC}"
        echo "  ✅ Configs updated. You may need to restart applications."
    fi
    
    if $GIT_CMD diff HEAD@{1} HEAD -- ".darch/*.sh" ".darch/bin/*.sh" | grep -q "^++"; then
        echo -e "${GREEN}📜 Scripts updated${NC}"
        echo "  ✅ Scripts updated."
    fi
else
    echo -e "${YELLOW}⚠️ Cannot compare with previous commit (first sync?)${NC}"
fi

echo ""
echo -e "${GREEN}✨ Sync complete!${NC}"
echo ""
echo "Check status with: git dotfiles status"
