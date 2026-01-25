#!/bin/bash
set -euo pipefail
trap 'echo -e "\033[0;31m❌ Error in $0 at line $LINENO\033[0m" >&2' ERR

if [[ $EUID -ne 0 ]]; then
   echo "Please run this script with sudo (e.g., sudo ./install_drivers.sh)"
   exit 1
fi
echo "🔍 Detecting GPU..."

GPU_INFO=$(lspci | grep -i 'VGA\|3D')

if echo "$GPU_INFO" | grep -iq "nvidia"; then
    if lspci -nn | grep -iqE '\[10de:(1b|1c|1d|1f)0'; then
        echo "⚠️ Pascal/Older GPU detected. Installing 580xx legacy drivers..."
        yay -S --needed nvidia-580xx-dkms nvidia-580xx-utils lib32-nvidia-580xx-utils nvidia-settings
        echo "📌 Pinning NVIDIA drivers in pacman.conf..."
        sudo sed -i 's/^#IgnorePkg =/IgnorePkg = nvidia-580xx-dkms nvidia-580xx-utils lib32-nvidia-580xx-utils nvidia-settings/' /etc/pacman.conf
        NV_MODS="nvidia nvidia_modeset nvidia_uvm nvidia_drm"
        sudo sed -i "s/^MODULES=(/MODULES=($NV_MODS /" /etc/mkinitcpio.conf
        sudo sed -i 's/  */ /g' /etc/mkinitcpio.conf
    else
        echo "🚀 Modern GPU detected. Installing nvidia-open..."
        sudo pacman -S --needed nvidia-open nvidia-utils lib32-nvidia-utils nvidia-settings
    fi
elif echo "$GPU_INFO" | grep -iq "amd\|ati"; then
    echo "🔴 AMD GPU detected. Installing Mesa drivers..."
    sudo pacman -S --needed xf86-video-amdgpu mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon
elif echo "$GPU_INFO" | grep -iq "intel"; then
    echo "🔵 Intel GPU detected. Installing Mesa drivers..."
    sudo pacman -S --needed xf86-video-intel mesa lib32-mesa vulkan-intel lib32-vulkan-intel
else
    echo "❓ Unknown GPU or VM. Skipping driver installation."
fi

echo "🧠 Detecting CPU..."
CPU_INFO=$(grep -m 1 'vendor_id' /proc/cpuinfo 2>/dev/null || echo "unknown")

if [[ "$CPU_INFO" == *"GenuineIntel"* ]]; then
    echo "Installing Intel Microcode..."
    sudo pacman -S --needed intel-ucode
elif [[ "$CPU_INFO" == *"AuthenticAMD"* ]]; then
    echo "Installing AMD Microcode..."
    sudo pacman -S --needed amd-ucode
fi
