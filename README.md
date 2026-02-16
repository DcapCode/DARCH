# DARCH

Personal Arch Linux dotfiles for quick machine setup.

## Quick Install (New Machine)

```bash
# 1. Clone and setup
git clone https://github.com/DcapCode/DARCH.git ~/temp-darch
cd ~/temp-darch
mv .darch .darch.setup.sh .darch.bootstrap.sh ../
cd && rm -rf temp-darch

# 2. Bootstrap the bare repo
~/.darch.bootstrap.sh

# 3. Run full setup (packages, services, shell, KDE theme)
~/.darch.setup.sh

# 4. Reboot
sudo reboot
```

## What's Included

| Category | Details |
|----------|---------|
| **Shell** | Zsh + Oh My Zsh + Powerlevel10k |
| **Terminal** | Ghostty with Catppuccin theme |
| **Desktop** | KDE Plasma (theme exported via konsave) |
| **Editor** | Neovim with lazy.nvim |
| **Packages** | See `.config/pkglist_*.txt` files |

## Syncing Changes

After making changes to your dotfiles:

```bash
git dotfiles add .
git dotfiles commit -m "Your message"
git dotfiles push
```

On other machines, pull changes:

```bash
~/.darch/bin/sync.sh
```

## Export KDE Theme

After customizing KDE:

```bash
~/.darch/bin/export_kde.sh
git dotfiles add .config/konsave/
git dotfiles commit -m "Update KDE profile"
git dotfiles push
```

## Structure

```
~/.darch/           # Bare git repo & scripts
├── bin/            # Setup and sync scripts
└── README.md       # Detailed documentation

~/.config/          # Application configs
├── konsave/        # KDE profile export
├── nvim/           # Neovim config
├── ghostty/        # Terminal config
└── pkglist_*.txt   # Package lists

~/                  # Root dotfiles
├── .zshrc
├── .p10k.zsh
└── .gitconfig
```

## Notes

- Uses a bare git repo at `~/.darch` (cleaner than symlinks)
- Machine-specific files are gitignored (caches, credentials, hardware configs)
- Works with `paru` or `yay` AUR helpers
