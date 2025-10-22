# Omarchy Installation Guide for Fedora

Quick start guide for installing Omarchy on Fedora Linux.

## Prerequisites

- Fedora 39, 40, or 41 (or newer)
- Root/sudo access
- Internet connection
- At least 10GB free disk space

## Quick Install

### Step 1: Clone Omarchy

```bash
git clone -b fedora-port https://github.com/Atheror/omarchy.git ~/.local/share/omarchy
cd ~/.local/share/omarchy
```

### Step 2: Run Fedora Installation Script

```bash
./install-fedora.sh
```

This will:
- ✅ Enable RPM Fusion repositories
- ✅ Install ~80 packages from Fedora repos
- ✅ Configure system settings
- ✅ Set up login manager
- ⚠️ **Note**: Some packages need manual installation (see Step 3)

### Step 3: Install Additional Packages

After the main installation completes, run the interactive helper:

```bash
./install-fedora-extras.sh
```

This interactive menu will guide you through installing:
- **Essential**: Hyprland, Waybar, Walker, Elephant
- **Development Tools**: Docker CE, Gum, LazyDocker, Mise
- **Desktop Apps**: Bitwarden, Joplin, LocalSend
- **System Tools**: SwayOSD, Satty
- **Fonts**: Nerd Fonts

## What Gets Installed

### Automatically (via dnf)
- Base system tools: `alacritty`, `btop`, `fastfetch`
- Development: `cargo`, `clang`, `github-cli`, `lazygit`
- Wayland tools: `grim`, `slurp`, `wl-clipboard`, `mako`
- Document tools: `evince`, `libreoffice`, `xournalpp`
- And ~70 more packages...

### Manually (via install-fedora-extras.sh)
- **Hyprland ecosystem** - Wayland compositor
- **Walker** - Application launcher
- **Elephant** - Walker plugins system
- **SwayOSD** - On-screen display
- **Satty** - Screenshot annotation
- **Bitwarden** - Password manager
- **Joplin** - Note-taking app
- And more...

## Package Sources

| Source | Count | Examples |
|--------|-------|----------|
| Fedora repos | ~80 | alacritty, btop, neovim |
| RPM Fusion | ~10 | multimedia codecs |
| COPR | ~15 | Hyprland, hyprlock |
| GitHub/Source | ~25 | Walker, Elephant, SwayOSD, Satty |
| Flatpak | ~5 | Bitwarden, Joplin, LocalSend |

## Troubleshooting

### Script fails with "not found" error
Make sure you're in the omarchy directory:
```bash
cd ~/.local/share/omarchy
```

### Package installation fails
Check if you have RPM Fusion enabled:
```bash
dnf repolist | grep rpmfusion
```

### Hyprland not available
Enable the COPR repository:
```bash
sudo dnf copr enable solopasha/hyprland
sudo dnf install hyprland
```

### Build failures
Install development tools:
```bash
sudo dnf groupinstall "Development Tools"
sudo dnf install cmake meson ninja-build
```

## Manual Installation

If you prefer to install packages manually instead of using the helper script, see the comprehensive guide:

```bash
cat install/omarchy-base-fedora-alternatives.md
```

This document contains detailed installation instructions for every package that's not in standard repos.

## Differences from Arch Version

| Aspect | Arch | Fedora |
|--------|------|--------|
| Package manager | `pacman` | `dnf` |
| AUR helper | `yay` | COPR |
| Base development | `base-devel` | Development Tools |
| Hyprland source | Official/AUR | COPR |
| Docker package | `docker` | `docker-ce` (official) |

## Files Structure

```
omarchy/
├── install-fedora.sh              # Main installation script
├── install-fedora-extras.sh       # Interactive helper for extra packages
├── FEDORA-PORT.md                 # Complete porting documentation
├── INSTALL-FEDORA.md             # This file
├── install/
│   ├── packaging/
│   │   ├── base-fedora.sh        # DNF-based package installation
│   │   └── ...
│   ├── preflight/
│   │   ├── dnf.sh                # Fedora system preparation
│   │   └── ...
│   ├── omarchy-base-fedora.packages          # Package list
│   └── omarchy-base-fedora-alternatives.md   # Manual installation guide
```

## Post-Installation

### 1. Log out and select Hyprland session
If SDDM is configured, you should see Hyprland in the session selector.

### 2. Configure keyboard layout
```bash
omarchy-menu
# Select "Settings" > "Keyboard Layout"
```

### 3. Install additional themes (optional)
```bash
omarchy-theme-install
```

### 4. Set up development environment (optional)
```bash
omarchy-install-dev-env
```

## Getting Help

- **Installation issues**: Check `FEDORA-PORT.md` for detailed information
- **Package alternatives**: See `install/omarchy-base-fedora-alternatives.md`
- **General omarchy help**: Run `omarchy-menu` after installation
- **Logs**: Check `/var/log/omarchy-install.log`

## Known Issues

1. **Elephant plugins** - Install Elephant after Walker for plugin functionality. Some plugins may need additional configuration
2. **Font Awesome WOFF2** - May need manual download
3. **GPU Screen Recorder** - Build process can be complex
4. **Some COPR packages** - Availability varies by Fedora version

## Contributing

Found an issue or improvement for the Fedora port?
1. Test the installation process
2. Document any missing dependencies
3. Submit corrections for package names
4. Share build instructions for packages built from source

## Next Steps

After installation:
1. ✅ Explore the omarchy interface
2. ✅ Customize your theme: `omarchy-theme-set`
3. ✅ Set your wallpaper: `omarchy-theme-bg-next`
4. ✅ Install webapps: They're already configured!
5. ✅ Check keybindings: `omarchy-menu-keybindings`

Enjoy Omarchy on Fedora! 🎉
