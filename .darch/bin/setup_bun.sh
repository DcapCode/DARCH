#!/bin/bash
set -euo pipefail
trap 'echo -e "\033[0;31m❌ Error in $0 at line $LINENO\033[0m" >&2' ERR
#!/bin/bash

echo "🍞 Installing Bun..."

# Check if zip is installed
if ! command -v zip &> /dev/null; then
    echo "❌ Error: 'zip' is required but not installed."
    echo "   Please install it first:"
    echo "   - Arch Linux: sudo pacman -S zip"
    echo "   - Ubuntu/Debian: sudo apt install zip"
    exit 1
fi

# 1. Run the official install script
curl -fsSL https://bun.sh/install | bash

# 2. Ensure the bun binary directory exists (the installer creates this, but just in case)
mkdir -p ~/.bun/bin

echo "✅ Bun installation complete!"
