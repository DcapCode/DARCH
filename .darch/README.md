# DARCH - Simple Arch Linux Dotfiles

Easy-to-deploy Arch Linux setup for multiple machines with different hardware.

## 🚀 Quick Start (New Machine)

### Step 1: Clone Repository
```bash
git clone git@github.com:DcapCode/DARCH.git ~/temp-darch
cd ~/temp-darch
mv .darch ../
mv .darch.setup.sh ../
mv .darch.bootstrap.sh ../
cd ..
rm -rf ~/temp-darch
```

### Step 2: Bootstrap Repository
```bash
~/.darch.bootstrap.sh
```

### Step 3: Install Everything
```bash
~/.darch.setup.sh
```

### Step 4: Reboot
```bash
sudo reboot
```

## 🔄 Keeping Machines in Sync

### One-Command Sync
```bash
~/.darch/bin/sync.sh
```

This will:
- Pull latest changes from remote
- Detect what changed (packages, services, configs, scripts)
- Automatically apply updates where needed

## 📦 Managing Packages

### Add New Package to All Machines

```bash
# Add to appropriate package list
echo "helix" >> ~/.config/pkglist_native.txt

# Commit and push
git dotfiles add ~/.config/pkglist*.txt
git dotfiles commit -m "Add helix editor"
git dotfiles push

# On other machines:
~/.darch/bin/sync.sh
```

### Update All Packages
```bash
~/.darch/bin/install_packages.sh
```

## 📁 Directory Structure

```
~/.darch/              # DARCH directory (hidden)
├── setup.sh           # Master installer (run once)
├── bootstrap.sh       # Repository setup (run once)
├── README.md          # This file
├── TESTING.md         # VM testing checklist
└── bin/
    ├── install_packages.sh   # Package installer (run once)
    ├── enable_services.sh   # Service enabler (run once)
    ├── install_drivers.sh   # GPU drivers (run once)
    ├── setup_rust.sh      # Rust setup (run once)
    ├── setup_bun.sh       # Bun setup (run once)
    ├── bootstrap_theme.sh  # Theme setup (run once)
    ├── export_kde.sh      # Export KDE profile to .knsv
    ├── import_kde.sh      # Import KDE profile (called by setup)
    └── sync.sh            # Auto-sync (run multiple times)

~/.config/            # Configuration files
├── konsave/              # KDE profile export (.knsv file)
├── pkglist_native.txt   # Official Arch packages
├── pkglist_foreign.txt  # Foreign/AUR packages
├── pkglist_aur.txt      # AUR packages
├── system_services.txt # System services
└── user_services.txt  # User services

~/                     # Tracked dotfiles
├── .zshrc            # Shell config (Oh My Zsh + p10k)
├── .p10k.zsh         # Powerlevel10k theme config
├── .gitconfig        # Git configuration
└── .config/ghostty/  # Terminal config
```

## 🎨 KDE Plasma Setup

### Export Your Current KDE Theme

After customizing KDE Plasma:
```bash
~/.darch/bin/export_kde.sh
```

This creates a `.knsv` file at `~/.config/konsave/darch-kde-profile.knsv`.

Commit it to track:
```bash
git dotfiles add .config/konsave/
git dotfiles commit -m "Update KDE profile"
git dotfiles push
```

### On New Machines

The `.darch.setup.sh` automatically:
1. Installs `konsave` from AUR
2. Imports the KDE profile
3. Applies the theme

Log out/in after setup for full effect.

## 🔍 Troubleshooting

### KDE/Plasma Won't Start After Setup

**Solutions**:
```bash
# Option 1: Reboot (simplest)
sudo reboot

# Option 2: Restart display manager (from TTY)
# Press Ctrl+Alt+F3, login, then:
sudo systemctl restart sddm

# Option 3: Check logs
journalctl -xe | grep -i "sddm\|plasma\|kde"
```

### Package Installation Errors

**Solutions**:
```bash
# Check package list files
cat ~/.config/pkglist*.txt

# Update package databases
sudo pacman -Sy

# Check for syntax errors in pkglist files
# (should be: package-name version)

# Try installing manually
yay -S package-name
```

### Git Sync Issues

**Solutions**:
```bash
# Check git config
git config --list | grep user

# Set up SSH keys
ssh-keygen -t ed25519 -C "your-email@example.com"
# Add public key to GitHub

# Test connection
ssh -T git@github.com
```

### Services Not Starting

**Solutions**:
```bash
# Check service status
systemctl status service-name

# Check service logs
journalctl -xe -u service-name

# Try enabling manually
sudo systemctl enable service-name
sudo systemctl start service-name

# Check service list format
cat ~/.config/system_services.txt
# Must be: UNIT FILE  STATE  PRESET
# Example: sddm.service  enabled  disabled
```

### Rollback with Snapper

**If something breaks after updates**:
```bash
# List snapshots
sudo snapper list

# View snapshot differences
sudo snapper -c root diff X..Y

# Rollback to snapshot
sudo snapper -c root rollback X

# Reboot to apply
sudo reboot
```

## 📝 Best Practices

1. **Always commit before major changes**
   ```bash
   git dotfiles add .
   git dotfiles commit -m "Pre-update backup"
   ```

2. **Test package changes on one machine first**
   - Don't add to pkglist and immediately push
   - Install locally first: `yay -S package-name`
   - Verify it works, then add to list

3. **Keep package lists organized**
   - `pkglist_native.txt`: Official Arch packages
   - `pkglist_foreign.txt`: Foreign/AUR packages
   - `pkglist_aur.txt`: Alternative AUR format

4. **Use meaningful commit messages**
   ```bash
   git dotfiles commit -m "Add neovim lazy.nvim plugin manager"
   git dotfiles commit -m "Fix KDE panel position"
   ```

5. **Regular updates**
   ```bash
   ~/.darch/bin/sync.sh
   ```
   Do this weekly or monthly to keep machines in sync.

## 🔗 Related Resources

- [Arch Wiki](https://wiki.archlinux.org/)
- [Yay AUR Helper](https://github.com/Jguer/yay)
- [Snapper Documentation](https://snapper.io/documentation.html)
