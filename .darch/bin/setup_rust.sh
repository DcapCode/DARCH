#!/bin/bash
set -euo pipefail
trap 'echo -e "\033[0;31m❌ Error in $0 at line $LINENO\033[0m" >&2' ERR
#!/bin/bash

echo "🦀 Initializing Rust environment..."

# 1. Install rustup if not present
if ! command -v rustup &> /dev/null; then
    echo "📥 Installing rustup via pacman..."
    sudo pacman -S --needed --noconfirm rustup
fi

# 2. Install/Update the Stable toolchain
echo "⚙️ Setting default toolchain to stable..."
rustup default stable

# 3. Add essential development components
echo "🛠️ Adding components: rust-analyzer, rustfmt, clippy..."
rustup component add rust-analyzer rustfmt clippy

# 4. Create cargo bin directory if it doesn't exist
mkdir -p ~/.cargo/bin

echo "✅ Rust is ready! (Note: Ensure ~/.cargo/bin is in your PATH)"
