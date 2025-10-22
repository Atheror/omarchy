# Omarchy Fedora Port

This document describes the Fedora-compatible version of the Omarchy installation scripts.

## Overview

The original Omarchy install script was designed for Arch Linux using `pacman` and AUR packages. This port adapts the installation process for Fedora Linux using `dnf`, RPM Fusion, COPR repositories, and GitHub sources where necessary.

## New Files Created

### 1. `install/packaging/base-fedora.sh`
Fedora-compatible version of `base.sh` that uses `dnf` instead of `pacman`.

**Key Changes:**
- Uses `dnf install -y` instead of `pacman -S --noconfirm --needed`
- Reads from `omarchy-base-fedora.packages` instead of `omarchy-base.packages`
- Skips packages marked with `!` (need manual installation)

### 2. `install/preflight/dnf.sh`
Fedora-compatible version of `preflight/pacman.sh`.

**Key Changes:**
- Installs "Development Tools" group instead of `base-devel`
- Enables RPM Fusion (Free and Nonfree) repositories
- Optionally enables COPR for Hyprland ecosystem
- Uses `dnf upgrade -y --refresh` instead of `pacman -Syu`

### 3. `install/omarchy-base-fedora.packages`
Fedora-compatible package list with inline documentation.

**Features:**
- Converted Arch package names to Fedora equivalents where applicable
- Packages marked with `!` are not available in standard repos
- Organized by category with comments
- ~80 packages available directly via dnf
- ~40 packages need alternative installation

**Examples of Name Changes:**
- `fd` → `fd-find`
- `man` → `man-db`
- `docker` → `docker-ce` (official Docker CE)
- `nvim` → `neovim`
- `mariadb-libs` → `mariadb-connector-c`
- `postgresql-libs` → `libpq`

### 4. `install/omarchy-base-fedora-alternatives.md`
Comprehensive guide for packages not available in Fedora repos.

**Covers:**
- Password Manager (Bitwarden)
- Hyprland ecosystem (via COPR or GitHub)
- Walker and Elephant plugins (GitHub)
- Wayland tools (SwayOSD, Satty, Wayfreeze, etc.)
- Development tools (LazyDocker, Mise, Gum)
- Applications (Joplin, LocalSend, etc.)
- Fonts (Nerd Fonts, iA Writer)
- System utilities (tzupdate, ufw-docker, uwsm)

## Usage

### Option 1: Modify Existing Scripts

Update `install/packaging/all.sh` to use Fedora scripts:
```bash
# Replace this line:
run_logged $OMARCHY_INSTALL/packaging/base.sh

# With:
run_logged $OMARCHY_INSTALL/packaging/base-fedora.sh
```

Update `install/preflight/all.sh` to use dnf:
```bash
# Replace:
run_logged $OMARCHY_INSTALL/preflight/pacman.sh

# With:
run_logged $OMARCHY_INSTALL/preflight/dnf.sh
```

### Option 2: Create Fedora-Specific Install Script

Create `install-fedora.sh`:
```bash
#!/bin/bash
set -eEo pipefail

export OMARCHY_PATH="$HOME/.local/share/omarchy"
export OMARCHY_INSTALL="$OMARCHY_PATH/install"
export OMARCHY_INSTALL_LOG_FILE="/var/log/omarchy-install.log"
export PATH="$OMARCHY_PATH/bin:$PATH"

# Install
source "$OMARCHY_INSTALL/helpers/all.sh"
source "$OMARCHY_INSTALL/preflight/all.sh"

# Use Fedora packaging scripts
run_logged $OMARCHY_INSTALL/preflight/dnf.sh
run_logged $OMARCHY_INSTALL/packaging/base-fedora.sh
run_logged $OMARCHY_INSTALL/packaging/fonts.sh
run_logged $OMARCHY_INSTALL/packaging/nvim.sh
run_logged $OMARCHY_INSTALL/packaging/icons.sh
run_logged $OMARCHY_INSTALL/packaging/webapps.sh
run_logged $OMARCHY_INSTALL/packaging/tuis.sh

source "$OMARCHY_INSTALL/config/all.sh"
source "$OMARCHY_INSTALL/login/all.sh"
source "$OMARCHY_INSTALL/post-install/all.sh"
```

## Installation Steps

1. **Prepare System**
   ```bash
   # Clone omarchy
   git clone <omarchy-repo> ~/.local/share/omarchy
   cd ~/.local/share/omarchy
   ```

2. **Install Fedora Scripts** (if not already in repo)
   ```bash
   # Copy the Fedora-specific files to the install directory
   cp install/packaging/base-fedora.sh install/packaging/
   cp install/preflight/dnf.sh install/preflight/
   cp install/omarchy-base-fedora.packages install/
   ```

3. **Run Installation**
   ```bash
   ./install-fedora.sh
   ```

4. **Install Missing Packages**
   ```bash
   # Review the alternatives document
   cat install/omarchy-base-fedora-alternatives.md

   # Install packages from GitHub/sources as needed
   ```

## Package Statistics

| Category | Count |
|----------|-------|
| Total packages in original list | 148 |
| Available in Fedora/RPM Fusion | ~80 |
| Available via COPR | ~15 |
| Need manual installation | ~40 |
| Need alternative solution | ~13 |

## Key Differences: Arch vs Fedora

| Aspect | Arch Linux | Fedora |
|--------|------------|--------|
| Package Manager | pacman | dnf |
| AUR equivalent | yay/paru | COPR |
| Base development | base-devel | Development Tools group |
| Additional repos | AUR | RPM Fusion, COPR |
| Hyprland | Official repos/AUR | COPR (solopasha/hyprland) |
| Docker | docker | docker-ce (official) |
| Neovim | nvim | neovim |

## Known Issues and Limitations

1. **Hyprland Ecosystem**: Some packages like `hyprsunset` may need manual building
2. **Walker & Elephant**: Not in any repo, must build from source. Elephant provides plugins for Walker
3. **Custom Packages**: `omarchy-chromium` and `omarchy-nvim` may need adaptation
4. **Font Awesome WOFF2**: Standard package only includes TTF/OTF, may need manual download
5. **Some Tools**: `wiremix`, `impala`, `aether` - unclear sources, may need alternatives

## Repository Requirements

### Essential Repositories

1. **RPM Fusion (Free)**
   ```bash
   sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
   ```

2. **RPM Fusion (Nonfree)**
   ```bash
   sudo dnf install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
   ```

3. **Hyprland COPR** (optional)
   ```bash
   sudo dnf copr enable solopasha/hyprland
   ```

### Recommended COPRs

- `atim/charm` - For Charmbracelet tools (gum)
- Check `omarchy-base-fedora-alternatives.md` for more

## Testing

This port has been created based on package availability research. Testing is recommended for:
- [ ] Base package installation
- [ ] Hyprland setup from COPR
- [ ] Walker installation from source
- [ ] Elephant installation from source
- [ ] Custom omarchy tools compatibility
- [ ] Configuration scripts (may reference pacman)

## Contributing

If you find issues or improvements for the Fedora port:
1. Test the installation process
2. Document any missing dependencies
3. Submit corrections for package names
4. Add build instructions for packages built from source

## Additional Resources

- [Fedora Packages Search](https://packages.fedoraproject.org/)
- [RPM Fusion Packages](https://rpmsearch.rpmfusion.org/)
- [Fedora COPR](https://copr.fedorainfracloud.org/)
- [Hyprland COPR by solopasha](https://copr.fedorainfracloud.org/coprs/solopasha/hyprland/)

## Future Work

- Create automated build script for GitHub packages
- Package more tools as RPMs for easier installation
- Create COPR repository for omarchy-specific packages
- Test on different Fedora versions (39, 40, 41)
- Adapt config scripts that reference pacman/AUR
