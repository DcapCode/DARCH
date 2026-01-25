# VM Testing Checklist

Use this checklist when testing DARCH on a new VM before deploying to production machines.

## 🖥️ VM Setup

- [ ] Create VM with at least:
  - [ ] 2 CPU cores
  - [ ] 4GB RAM (8GB recommended)
  - [ ] 20GB disk
  - [ ] 3D acceleration enabled
- [ ] Install minimal Arch Linux
- [ ] Enable network
- [ ] Create user account with sudo access
- [ ] Install base-devel: `sudo pacman -S --needed base-devel git curl`

## 📦 Pre-Flight Checks

Before running DARCH setup:

- [ ] Verify internet connectivity: `ping archlinux.org`
- [ ] Verify git installation: `git --version`
- [ ] Verify sudo access: `sudo -v`
- [ ] Check disk space: `df -h`
- [ ] Create snapper snapshot: `sudo snapper -c root create -d "Pre-DARCH"`

## 🚀 Installation Test

Run through full installation:

- [ ] Clone repository: `git clone git@github.com:DcapCode/DARCH.git ~/temp-darch`
- [ ] Move files: `cd ~/temp-darch && mv .darch ../ && mv .darch.*.sh ../ && cd .. && rm -rf ~/temp-darch`
- [ ] Run bootstrap: `~/.darch.bootstrap.sh`
- [ ] Verify bare repo created: `ls -la ~/.darch`
- [ ] Verify git alias: `git config --global alias.dotfiles`
- [ ] Run setup: `~/.darch.setup.sh`
- [ ] Complete without errors
- [ ] Review output for warnings

## 🎮 Post-Installation Checks

After setup completes and reboot:

- [ ] Boot to login screen successfully
- [ ] SDDM login screen appears
- [ ] Can login to KDE Plasma
- [ ] Desktop loads correctly
- [ ] Panel appears at bottom (or configured position)
- [ ] Application menu works
- [ ] Terminal opens (Konsole or Ghostty)
- [ ] Internet works in browser

## 📦 Package Verification

- [ ] Check installed packages: `pacman -Qqe | wc -l`
- [ ] Verify specific packages:
  - [ ] `btop` - Launch with `btop`
  - [ ] `eza` - Run `eza`
  - [ ] `yay` - Run `yay --version`
  - [ ] `ghostty` - Launch terminal
  - [ ] `kde-gtk-config` - Check in system settings
- [ ] No errors in package logs: `cat /var/log/pacman.log | tail -50`

## 🔌 Service Verification

Check system services:
```bash
# Check enabled services
systemctl list-unit-files | grep enabled

# Specific services:
systemctl status sddm
systemctl status NetworkManager
```

- [ ] SDDM is running and active
- [ ] NetworkManager is running
- [ ] No failed services: `systemctl --failed`

## 🎨 Config Verification

- [ ] KDE theme applied correctly
- [ ] Terminal font (Hermit Nerd Font) renders correctly
- [ ] Ghostty theme (Catppuccin) loads
- [ ] Neovim config loads without errors: `nvim --check-health`
- [ ] VSCodium settings applied

## 🔄 Sync Test

Test sync functionality:

- [ ] Create test config change: `echo "test" >> ~/.config/test-file.txt`
- [ ] Commit: `git dotfiles add . && git dotfiles commit -m "Test commit"`
- [ ] Push: `git dotfiles push`
- [ ] On other machine/clone: `git pull && ~/.darch/bin/sync.sh`
- [ ] Verify change appears

## 🐛 Rollback Test

Test snapper rollback:

- [ ] List snapshots: `sudo snapper list`
- [ ] Create pre-test snapshot: `sudo snapper -c root create -d "Before rollback test"`
- [ ] Make intentional change: `sudo rm /etc/important-file`
- [ ] Verify change: `ls /etc/important-file` (should fail)
- [ ] Rollback: `sudo snapper -c root rollback <snapshot-number>`
- [ ] Reboot: `sudo reboot`
- [ ] Verify file restored: `ls /etc/important-file`

## ✅ Final Verification

Before considering production ready:

- [ ] All installation steps completed without errors
- [ ] KDE Plasma works correctly
- [ ] All packages installed and functional
- [ ] Services running properly
- [ ] Configs applied correctly
- [ ] Sync works bidirectional
- [ ] Snapper rollback tested
- [ ] No critical errors in logs: `journalctl -p err -b`

## 🚨 Known Issues

### VMware-Specific
- **Issue**: Wayland/KDE may not start if 3D acceleration not enabled
- **Fix**: Enable 3D acceleration in VM settings
- **Fallback**: Use X11 if needed

### Network Issues
- **Issue**: NetworkManager may not auto-connect
- **Fix**: Manually enable network: `nmcli device wifi connect <SSID>`

### GPU Detection
- **Issue**: VM may show no GPU or generic VMware GPU
- **Fix**: Script handles this gracefully, but may not install specific drivers

## 📝 Test Report

After completing VM testing, document results:

**Test Date**: _______________
**VM Specs**: _______________
**Arch Version**: _______________
**Kernel Version**: _______________

**Results**:
- Installation successful? [ ] Yes [ ] No
- KDE Plasma works? [ ] Yes [ ] No
- All packages installed? [ ] Yes [ ] No
- Sync works? [ ] Yes [ ] No
- Rollback works? [ ] Yes [ ] No

**Issues encountered**:
1.
2.
3.

**Ready for production?**: [ ] Yes [ ] No
