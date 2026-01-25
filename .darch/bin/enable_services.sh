#!/bin/bash
set -euo pipefail
trap 'echo -e "\033[0;31m❌ Error in $0 at line $LINENO\033[0m" >&2' ERR

SYSTEM_SERVICES="$HOME/.config/system_services.txt"
USER_SERVICES="$HOME/.config/user_services.txt"

echo "󱐋 Starting Service Activation..."

# Function to enable services from a file
enable_from_file() {
    local file=$1
    local is_user=$2
    local cmd="sudo systemctl enable"
    
    if [ "$is_user" = true ]; then
        cmd="systemctl --user enable"
    fi

    if [ ! -f "$file" ]; then
        echo " 󰈸 Error: $file not found."
        return 1
    fi

    # FIXED: Only enable services where column 2 is "enabled"
    # Original buggy: grep "enabled" "$file" | awk '{print $1}'
    # Fixed: awk '$2 == "enabled" {print $1}' "$file"
    awk '$2 == "enabled" {print $1}' "$file" | while read -r service; do
        echo "  󰄬 Enabling $service..."
        $cmd "$service" 2>/dev/null
    done
}

echo "󰒋 Processing System Services..."
enable_from_file "$SYSTEM_SERVICES" false

echo "󰚔 Processing User Services..."
enable_from_file "$USER_SERVICES" true

echo "󰄬 Done! Some changes may require a reboot."
