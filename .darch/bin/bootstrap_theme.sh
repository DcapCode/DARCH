#!/bin/bash
set -euo pipefail
trap 'echo -e "\033[0;31m❌ Error in $0 at line $LINENO\033[0m" >&2' ERR
#!/bin/bash
# Clone and install Catppuccin for KDE
git clone --depth=1 https://github.com/catppuccin/kde ~/.cache/catppuccin-kde
cd ~/.cache/catppuccin-kde
./install.sh
cd ~
rm -rf ~/.cache/catppuccin-kde
