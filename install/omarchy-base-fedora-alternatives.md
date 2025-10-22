# Fedora Package Alternatives and Installation Guide

This document lists all packages from the Arch Linux omarchy-base.packages that are **not available** in standard Fedora, RPM Fusion, or COPR repositories. For each package, we provide installation alternatives.

## Table of Contents
- [Password Manager](#password-manager)
- [Container Tools](#container-tools)
- [Hyprland Ecosystem](#hyprland-ecosystem)
- [Walker and Elephant Plugins](#walker-and-elephant-plugins)
- [Custom Omarchy Packages](#custom-omarchy-packages)
- [Wayland/Desktop Tools](#waylanddesktop-tools)
- [Development Tools](#development-tools)
- [Applications](#applications)
- [Fonts](#fonts)
- [System Utilities](#system-utilities)

---

## Password Manager

### Bitwarden
**Source:** https://bitwarden.com/download/?app=desktop&platform=linux&variant=rpm

```bash
# Download and install Bitwarden RPM
cd /tmp
wget 'https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=rpm' -O bitwarden.rpm
sudo dnf install -y ./bitwarden.rpm
rm -f bitwarden.rpm
```

**Alternative - Flatpak:**
```bash
flatpak install -y flathub com.bitwarden.desktop
```

---

## Container Tools

### Docker CE (Community Edition)
**Source:** https://docs.docker.com/engine/install/fedora/

The official Docker CE installation is recommended over moby-engine for full Docker functionality.

```bash
# Uninstall old versions (if any)
sudo dnf remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine \
                  podman \
                  runc

# Set up the repository
sudo dnf install -y dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

# Install Docker Engine, containerd, and Docker Compose
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to the docker group (optional, log out and back in for this to take effect)
sudo usermod -aG docker $USER

# Test Docker installation
sudo docker run hello-world
```

**Post-installation steps:**
```bash
# Enable Docker to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# Test with a non-root user (after logging out and back in)
docker run hello-world
```

---

## Hyprland Ecosystem

Most Hyprland-related packages can be installed via COPR.

### Enable Hyprland COPR
```bash
sudo dnf copr enable -y solopasha/hyprland
```

### Hyprland Core
```bash
sudo dnf install -y hyprland hyprpaper
```

### Hyprland Utilities
**Packages:** hypridle, hyprlock, hyprpicker, hyprsunset, hyprland-qtutils, xdg-desktop-portal-hyprland

```bash
# Most are available in the COPR
sudo dnf install -y hypridle hyprlock hyprpicker
```

**Note:** Some packages like `hyprsunset` and `hyprland-qtutils` may need to be built from source:

```bash
# hyprsunset
git clone https://github.com/hyprwm/hyprsunset.git
cd hyprsunset
make
sudo make install

# hyprland-qtutils
git clone https://github.com/hyprwm/hyprland-qtutils.git
cd hyprland-qtutils
cmake -B build
cmake --build build
sudo cmake --install build
```

### xdg-desktop-portal-hyprland
```bash
# Try COPR first
sudo dnf install -y xdg-desktop-portal-hyprland

# Or build from source
git clone https://github.com/hyprwm/xdg-desktop-portal-hyprland.git
cd xdg-desktop-portal-hyprland
cmake -B build -DCMAKE_INSTALL_LIBEXECDIR=/usr/libexec
cmake --build build
sudo cmake --install build
```

---

## Walker and Elephant Plugins

**Walker** is a Wayland-native application launcher. All elephant-* packages are plugins for Walker.

### Install Walker
**Source:** https://github.com/abenz1267/walker

```bash
# Build from source (currently the only installation method)
git clone https://github.com/abenz1267/walker.git
cd walker
make
sudo make install
```

**Note:** Walker is not available via Flatpak or official repositories. Building from source is required.

### Install Elephant (Walker Plugin System)
**Source:** https://github.com/abenz1267/elephant

Elephant provides plugins for Walker. It should be installed after Walker is set up.

```bash
# Build from source (currently the only installation method)
git clone https://github.com/abenz1267/elephant.git
cd elephant
make
sudo make install
```

**Note:** Elephant is not available via Flatpak or official repositories. Building from source is required.

**Individual Elephant Plugins:**

The following plugins are part of the Elephant ecosystem and may need to be installed separately depending on your needs:

- **elephant** - Core plugin system
- **elephant-bluetooth** - Bluetooth device management
- **elephant-calc** - Calculator
- **elephant-clipboard** - Clipboard manager
- **elephant-desktopapplications** - Desktop application launcher
- **elephant-files** - File browser
- **elephant-menus** - Menu system
- **elephant-providerlist** - Provider management
- **elephant-runner** - Command runner
- **elephant-symbols** - Symbol picker
- **elephant-todo** - Todo list manager
- **elephant-unicode** - Unicode character picker
- **elephant-websearch** - Web search integration

**Note:** Some plugins may be included with the main Elephant installation, while others might require separate installation. Check the Elephant repository for the latest plugin availability and installation instructions.

---

## Custom Omarchy Packages

### omarchy-chromium
This is likely a customized Chromium build. Install standard Chromium instead:
```bash
sudo dnf install -y chromium
```

Or use Google Chrome:
```bash
# Add Google Chrome repo
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf install -y google-chrome-stable
```

### omarchy-nvim
This is a custom Neovim configuration. The package likely just runs a setup script. Use the standard neovim and configure manually:
```bash
sudo dnf install -y neovim
# Then run the omarchy neovim setup if available
omarchy-nvim-setup
```

---

## Wayland/Desktop Tools

### Waybar
```bash
# Available in Fedora repos
sudo dnf install -y waybar
```

### SwayOSD
**Source:** https://github.com/ErikReider/SwayOSD

```bash
git clone https://github.com/ErikReider/SwayOSD.git
cd SwayOSD
meson setup build
ninja -C build
sudo ninja -C build install
```

### Satty (Screenshot annotation)
**Source:** https://github.com/gabm/satty

```bash
# Install via cargo
cargo install satty

# Or build from source
git clone https://github.com/gabm/satty.git
cd satty
cargo build --release
sudo cp target/release/satty /usr/local/bin/
```

### Wayfreeze
**Source:** https://github.com/Jappie3/wayfreeze

```bash
git clone https://github.com/Jappie3/wayfreeze.git
cd wayfreeze
cargo build --release
sudo cp target/release/wayfreeze /usr/local/bin/
```

### GPU Screen Recorder
**Source:** https://git.dec05eba.com/gpu-screen-recorder

```bash
git clone https://git.dec05eba.com/gpu-screen-recorder
cd gpu-screen-recorder
./build.sh
sudo ./install.sh
```

---

## Development Tools

### LazyDocker
**Source:** https://github.com/jesseduffield/lazydocker

```bash
# Install via Go
go install github.com/jesseduffield/lazydocker@latest

# Or download binary
curl -Lo lazydocker.tar.gz https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_$(uname -s)_$(uname -m).tar.gz
tar xzf lazydocker.tar.gz
sudo install lazydocker /usr/local/bin/
```

### Mise (formerly rtx)
**Source:** https://github.com/jdx/mise

```bash
# Install via script
curl https://mise.run | sh

# Or via cargo
cargo install mise
```

### Gum (Charmbracelet)
**Source:** https://github.com/charmbracelet/gum

```bash
# Try COPR
sudo dnf copr enable -y atim/charm
sudo dnf install -y gum

# Or download RPM
wget https://github.com/charmbracelet/gum/releases/latest/download/gum-*.x86_64.rpm
sudo dnf install -y ./gum-*.x86_64.rpm

# Or via Go
go install github.com/charmbracelet/gum@latest
```

---

## Applications

### Joplin
**Source:** https://joplinapp.org

```bash
# Install using official script
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
```

**Alternative - Flatpak:**
```bash
flatpak install -y flathub net.cozic.joplin_desktop
```

### LocalSend
**Source:** https://localsend.org

```bash
# Download and install
wget https://github.com/localsend/localsend/releases/latest/download/LocalSend-*-linux-x86-64.rpm
sudo dnf install -y ./LocalSend-*-linux-x86-64.rpm

# Or via Flatpak
flatpak install flathub org.localsend.localsend_app
```

### imv (Image Viewer)
**Source:** https://sr.ht/~exec64/imv/

```bash
# May be available in repos
sudo dnf install -y imv

# Or build from source
git clone https://git.sr.ht/~exec64/imv
cd imv
meson build
ninja -C build
sudo ninja -C build install
```

---

## Fonts

### Nerd Fonts
**Source:** https://github.com/ryanoasis/nerd-fonts

```bash
# Install all nerd fonts
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts
./install.sh CascadiaMono
./install.sh JetBrainsMono

# Or download specific fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
unzip CascadiaMono.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip JetBrainsMono.zip
fc-cache -fv
```

### iA Writer Font
**Source:** https://github.com/iaolo/iA-Fonts

```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/iaolo/iA-Fonts/archive/master.zip
unzip master.zip
cp iA-Fonts-master/iA\ Writer\ Mono/TTF/*.ttf .
fc-cache -fv
```

### Font Awesome (WOFF2)
```bash
# Install font-awesome-fonts package
sudo dnf install -y fontawesome-fonts

# Or download WOFF2 manually if needed
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://use.fontawesome.com/releases/v6.4.0/fontawesome-free-6.4.0-web.zip
unzip fontawesome-free-6.4.0-web.zip
cp fontawesome-free-6.4.0-web/webfonts/*.woff2 .
fc-cache -fv
```

---

## System Utilities

### asdcontrol
**Source:** https://github.com/Akoufakou/asdcontrol (or similar)

This is an Apple Silicon Display control utility. Search for the correct repository or alternative:
```bash
# May need to build from AUR source
git clone https://aur.archlinux.org/asdcontrol.git
cd asdcontrol
# Extract build instructions and adapt for Fedora
```

### tzupdate
**Source:** https://github.com/cdown/tzupdate

```bash
# Install via pip
pip install --user tzupdate

# Or via pipx
pipx install tzupdate
```

### ufw-docker
**Source:** https://github.com/chaifeng/ufw-docker

```bash
git clone https://github.com/chaifeng/ufw-docker.git
cd ufw-docker
sudo cp ufw-docker /usr/local/bin/
```

### uwsm (Universal Wayland Session Manager)
**Source:** https://github.com/Vladimir-csp/uwsm

```bash
git clone https://github.com/Vladimir-csp/uwsm.git
cd uwsm
sudo make install
```

### wiremix
Could not find clear source. This might be a custom mixer for WirePlumber.

**Alternative:** Use standard WirePlumber controls:
```bash
# WirePlumber is already in Fedora repos
sudo dnf install -y wireplumber
```

### impala
Could not identify this package. May be a custom tool.

### aether
Could not identify this package clearly. May be a custom tool or theme.

---

## Python Packages

### python-terminaltexteffects
```bash
pip install --user terminaltexteffects
```

### python-poetry-core
```bash
sudo dnf install -y python3-poetry-core
```

---

## Additional Notes

### Kvantum Theme Engine
```bash
sudo dnf install -y kvantum
```

### Package Manager Note: yay
**yay** is an AUR helper for Arch Linux and is **not needed** on Fedora. For Fedora, use:
- `dnf` for official repos
- `dnf copr` for community repos
- Manual builds from GitHub for packages not available elsewhere

---

## Summary Statistics

- **Total Packages in Original List:** 148
- **Available in Fedora/RPM Fusion:** ~80
- **Available via COPR:** ~15
- **Need Manual Installation (GitHub/Source):** ~40
- **Need Alternative Solution:** ~13

---

## Installation Script

You can create a helper script to automate installation of packages from GitHub:

```bash
#!/bin/bash
# omarchy-fedora-extras-install.sh

set -e

echo "Installing packages from GitHub sources..."

# Add your installation commands here
# Example:
# install_from_github "walker" "https://github.com/abenz1267/walker.git" "make && sudo make install"

echo "Done! Manual packages installed."
echo "Please review omarchy-base-fedora-alternatives.md for remaining packages."
```

---

## Recommendations

1. **Use Flatpak** for GUI applications when possible (Obsidian, Spotify, LocalSend)
2. **Enable COPR repos** carefully - only enable trusted COPR repositories
3. **Build from source** for development tools and Hyprland ecosystem
4. **Use cargo/go/pip** for language-specific tools
5. **Check Fedora repos first** - some packages may be named differently (e.g., `fd-find` instead of `fd`)
