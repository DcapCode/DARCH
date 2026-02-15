#!/bin/bash
set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

DARCH_DIR="$HOME/.darch"
BIN_DIR="$DARCH_DIR/bin"

echo -e "${BLUE}🚀 DARCH Master Setup${NC}"
echo "================================"

if [[ $EUID -eq 0 ]]; then
    echo -e "${YELLOW}⚠️ Don't run as root. Run as regular user.${NC}"
    exit 1
fi

echo -e "${GREEN}🔐 Checking sudo access...${NC}"
sudo -v

echo -e "${GREEN}🔄 Step 1/7: Updating system...${NC}"
sudo pacman -Syu --noconfirm --needed base-devel git curl

echo -e "${GREEN}🔍 Step 2/7: Detecting hardware...${NC}"
if [[ -f "$BIN_DIR/install_drivers.sh" ]]; then
    bash "$BIN_DIR/install_drivers.sh"
else
    echo -e "${YELLOW}⚠️ install_drivers.sh not found, skipping${NC}"
fi

echo -e "${GREEN}📦 Step 3/7: Installing Yay...${NC}"
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm && cd -
    rm -rf /tmp/yay-bin
else
    echo "  ✅ Yay already installed"
fi

echo -e "${GREEN}📦 Step 4/7: Installing packages...${NC}"
if [[ -f "$BIN_DIR/install_packages.sh" ]]; then
    bash "$BIN_DIR/install_packages.sh" || echo -e "${YELLOW}⚠️ Package installation encountered errors${NC}"
else
    echo -e "${YELLOW}⚠️ install_packages.sh not found${NC}"
fi

echo -e "${GREEN}🔌 Step 5/7: Enabling services...${NC}"
if [[ -f "$BIN_DIR/enable_services.sh" ]]; then
    bash "$BIN_DIR/enable_services.sh"
else
    echo -e "${YELLOW}⚠️ enable_services.sh not found${NC}"
fi

echo -e "${GREEN}🛠️  Step 6/8: Installing development tools...${NC}"
[[ -f "$BIN_DIR/setup_rust.sh" ]] && bash "$BIN_DIR/setup_rust.sh" || echo -e "${YELLOW}⚠️ setup_rust.sh not found${NC}"
[[ -f "$BIN_DIR/setup_bun.sh" ]] && bash "$BIN_DIR/setup_bun.sh" || echo -e "${YELLOW}⚠️ setup_bun.sh not found${NC}"

echo -e "${GREEN}🎨 Step 7/8: Setting up shell and KDE...${NC}"
if ! [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo "  Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k 2>/dev/null || true
else
    echo "  ✅ Oh My Zsh already installed"
fi

if [[ -f "$BIN_DIR/import_kde.sh" ]]; then
    bash "$BIN_DIR/import_kde.sh"
else
    echo -e "${YELLOW}⚠️ import_kde.sh not found${NC}"
fi

echo -e "${GREEN}✨ Step 8/8: Finalizing...${NC}"
echo "  ✅ Setup complete!"
echo ""
echo -e "${BLUE}⚠️  Reboot recommended to apply all changes${NC}"
echo "  sudo reboot"
