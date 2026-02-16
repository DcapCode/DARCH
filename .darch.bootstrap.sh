#!/bin/bash
set -euo pipefail

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 DARCH Bootstrap${NC}"
echo "================================"
echo "This will set up your dotfiles repository."
echo ""

read -p "Enter remote URL [default: git@github.com:DcapCode/DARCH.git]: " remote_url
remote_url=${remote_url:-"git@github.com:DcapCode/DARCH.git"}

echo ""
echo -e "${GREEN}📥 Setting up bare repository...${NC}"

if [[ -d "$HOME/.darch" ]]; then
    echo -e "${YELLOW}Bare repo already exists at $HOME/.darch${NC}"
    read -p "Reinitialize? [y/N]: " reinit
    [[ "$reinit" != "y" ]] && exit 0
    mv "$HOME/.darch" "$HOME/.darch.backup.$(date +%s)"
fi

echo "Cloning bare repository..."
git clone --bare "$remote_url" "$HOME/.darch"

echo "Configuring git alias..."
git config --global alias.dotfiles "/usr/bin/git --git-dir=\$HOME/.darch/ --work-tree=\$HOME"

echo "Configuring worktree..."
/usr/bin/git --git-dir="$HOME/.darch" --work-tree="$HOME" config --local status.showUntrackedFiles no

echo "Making scripts executable..."
find "$HOME/.darch/bin" -name "*.sh" -exec chmod +x {} \;
chmod +x "$HOME/.darch.setup.sh"
chmod +x "$HOME/.darch.bootstrap.sh"

echo -e "${GREEN}✅ Bare repository setup complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Run: ~/.darch.setup.sh"
echo "  2. Reboot to apply changes"
echo ""
echo "Use 'git dotfiles status' to check status"
