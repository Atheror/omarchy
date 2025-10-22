#!/bin/bash

# Omarchy Fedora - Extra Packages Installation Helper
# This script helps install packages not available in standard Fedora repos

set -e

OMARCHY_INSTALL="${OMARCHY_INSTALL:-$HOME/.local/share/omarchy/install}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

echo_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

echo_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

echo_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

prompt_install() {
    local package_name="$1"
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    read -p "Install $package_name? [y/N] " -n 1 -r
    echo
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    [[ $REPLY =~ ^[Yy]$ ]]
}

install_hyprland_copr() {
    if prompt_install "Hyprland (via COPR)"; then
        echo_info "Enabling Hyprland COPR..."
        sudo dnf copr enable -y solopasha/hyprland

        echo_info "Installing Hyprland ecosystem..."
        sudo dnf install -y hyprland hypridle hyprlock hyprpicker xdg-desktop-portal-hyprland

        echo_success "Hyprland installed!"
    fi
}

install_bitwarden() {
    if prompt_install "Bitwarden"; then
        echo "Choose installation method:"
        echo "1) RPM (recommended)"
        echo "2) Flatpak"
        read -p "Enter choice [1-2]: " -n 1 -r
        echo

        case $REPLY in
            1)
                echo_info "Downloading Bitwarden RPM..."
                cd /tmp
                wget 'https://vault.bitwarden.com/download/?app=desktop&platform=linux&variant=rpm' -O bitwarden.rpm
                sudo dnf install -y ./bitwarden.rpm
                rm -f bitwarden.rpm
                echo_success "Bitwarden installed via RPM!"
                ;;
            2)
                echo_info "Installing Bitwarden via Flatpak..."
                flatpak install -y flathub com.bitwarden.desktop
                echo_success "Bitwarden installed via Flatpak!"
                ;;
        esac
    fi
}

install_walker() {
    if prompt_install "Walker (application launcher)"; then
        echo_info "Cloning Walker repository..."
        cd /tmp
        git clone https://github.com/abenz1267/walker.git
        cd walker

        echo_info "Building Walker..."
        make

        echo_info "Installing Walker..."
        sudo make install

        cd /tmp
        rm -rf walker

        echo_success "Walker installed!"
    fi
}

install_elephant() {
    if prompt_install "Elephant (Walker plugins)"; then
        echo_info "Cloning Elephant repository..."
        cd /tmp
        git clone https://github.com/abenz1267/elephant.git
        cd elephant

        echo_info "Building Elephant..."
        make

        echo_info "Installing Elephant..."
        sudo make install

        cd /tmp
        rm -rf elephant

        echo_success "Elephant installed!"
        echo_info "Elephant plugins are now available for Walker."
    fi
}

install_docker_ce() {
    if prompt_install "Docker CE (Community Edition)"; then
        echo_info "Removing old Docker versions if present..."
        sudo dnf remove -y docker docker-client docker-client-latest docker-common \
                          docker-latest docker-latest-logrotate docker-logrotate \
                          docker-selinux docker-engine-selinux docker-engine \
                          podman runc 2>/dev/null || true

        echo_info "Setting up Docker CE repository..."
        sudo dnf install -y dnf-plugins-core
        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

        echo_info "Installing Docker CE, containerd, and Docker Compose..."
        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

        echo_info "Starting and enabling Docker service..."
        sudo systemctl start docker
        sudo systemctl enable docker

        echo_info "Adding current user to docker group..."
        sudo usermod -aG docker $USER

        echo_success "Docker CE installed!"
        echo_warn "You need to log out and back in for docker group membership to take effect."
        echo_info "After logging back in, test with: docker run hello-world"
    fi
}

install_gum() {
    if prompt_install "Gum (Charmbracelet)"; then
        echo_info "Method 1: Trying COPR..."
        if sudo dnf copr enable -y atim/charm; then
            sudo dnf install -y gum
            echo_success "Gum installed via COPR!"
        else
            echo_warn "COPR method failed, trying binary download..."
            cd /tmp
            wget https://github.com/charmbracelet/gum/releases/latest/download/gum_*_linux_x86_64.rpm
            sudo dnf install -y ./gum_*.rpm
            rm -f gum_*.rpm
            echo_success "Gum installed via binary!"
        fi
    fi
}

install_lazydocker() {
    if prompt_install "LazyDocker"; then
        echo_info "Downloading LazyDocker..."
        cd /tmp
        curl -Lo lazydocker.tar.gz https://github.com/jesseduffield/lazydocker/releases/latest/download/lazydocker_$(uname -s)_$(uname -m).tar.gz
        tar xzf lazydocker.tar.gz
        sudo install lazydocker /usr/local/bin/
        rm -f lazydocker lazydocker.tar.gz

        echo_success "LazyDocker installed!"
    fi
}

install_mise() {
    if prompt_install "Mise (development environment manager)"; then
        echo_info "Installing Mise..."
        curl https://mise.run | sh

        echo_info "Adding Mise to shell configuration..."
        echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

        echo_success "Mise installed! Restart your shell to use it."
    fi
}

install_swayosd() {
    if prompt_install "SwayOSD"; then
        echo_info "Installing build dependencies..."
        sudo dnf install -y meson ninja-build gtk3-devel gtk-layer-shell-devel libpulse-devel

        echo_info "Cloning SwayOSD repository..."
        cd /tmp
        git clone https://github.com/ErikReider/SwayOSD.git
        cd SwayOSD

        echo_info "Building SwayOSD..."
        meson setup build
        ninja -C build

        echo_info "Installing SwayOSD..."
        sudo ninja -C build install

        cd /tmp
        rm -rf SwayOSD

        echo_success "SwayOSD installed!"
    fi
}

install_satty() {
    if prompt_install "Satty (screenshot annotation)"; then
        echo_info "Installing Satty via cargo..."
        cargo install satty

        echo_success "Satty installed!"
    fi
}

install_waybar() {
    if prompt_install "Waybar"; then
        echo_info "Installing Waybar..."
        sudo dnf install -y waybar

        echo_success "Waybar installed!"
    fi
}

install_joplin() {
    if prompt_install "Joplin"; then
        echo "Choose installation method:"
        echo "1) Official script (recommended)"
        echo "2) Flatpak"
        read -p "Enter choice [1-2]: " -n 1 -r
        echo

        case $REPLY in
            1)
                echo_info "Installing Joplin using official script..."
                wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
                echo_success "Joplin installed!"
                ;;
            2)
                echo_info "Installing Joplin via Flatpak..."
                flatpak install -y flathub net.cozic.joplin_desktop
                echo_success "Joplin installed via Flatpak!"
                ;;
        esac
    fi
}

install_localsend() {
    if prompt_install "LocalSend"; then
        echo "Choose installation method:"
        echo "1) RPM"
        echo "2) Flatpak"
        read -p "Enter choice [1-2]: " -n 1 -r
        echo

        case $REPLY in
            1)
                echo_info "Downloading LocalSend RPM..."
                cd /tmp
                wget https://github.com/localsend/localsend/releases/latest/download/LocalSend-*-linux-x86-64.rpm
                sudo dnf install -y ./LocalSend-*.rpm
                rm -f LocalSend-*.rpm
                echo_success "LocalSend installed via RPM!"
                ;;
            2)
                echo_info "Installing LocalSend via Flatpak..."
                flatpak install -y flathub org.localsend.localsend_app
                echo_success "LocalSend installed via Flatpak!"
                ;;
        esac
    fi
}

install_nerd_fonts() {
    if prompt_install "Nerd Fonts (CascadiaMono, JetBrainsMono)"; then
        echo_info "Creating fonts directory..."
        mkdir -p ~/.local/share/fonts
        cd ~/.local/share/fonts

        echo_info "Downloading CascadiaMono Nerd Font..."
        wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip
        unzip -o CascadiaMono.zip
        rm CascadiaMono.zip

        echo_info "Downloading JetBrainsMono Nerd Font..."
        wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
        unzip -o JetBrainsMono.zip
        rm JetBrainsMono.zip

        echo_info "Refreshing font cache..."
        fc-cache -fv

        echo_success "Nerd Fonts installed!"
    fi
}

install_tzupdate() {
    if prompt_install "tzupdate (timezone auto-updater)"; then
        echo_info "Installing tzupdate via pip..."
        pip install --user tzupdate

        echo_success "tzupdate installed!"
    fi
}

# Main menu
show_menu() {
    clear
    echo "=========================================="
    echo "  Omarchy Fedora - Extra Packages"
    echo "=========================================="
    echo ""
    echo "This script helps install packages not available"
    echo "in standard Fedora repositories."
    echo ""
    echo "Categories:"
    echo "  1) Essential (Hyprland, Waybar, Walker, Elephant)"
    echo "  2) Development Tools (Docker CE, Gum, LazyDocker, Mise)"
    echo "  3) Desktop Apps (Bitwarden, Joplin, LocalSend)"
    echo "  4) System Tools (SwayOSD, Satty)"
    echo "  5) Fonts (Nerd Fonts)"
    echo "  6) All of the above"
    echo "  7) Custom selection"
    echo "  q) Quit"
    echo ""
    read -p "Enter choice: " choice
}

install_essential() {
    echo_info "Installing essential packages..."
    install_hyprland_copr
    install_waybar
    install_walker
    install_elephant
}

install_dev_tools() {
    echo_info "Installing development tools..."
    install_docker_ce
    install_gum
    install_lazydocker
    install_mise
}

install_desktop_apps() {
    echo_info "Installing desktop applications..."
    install_bitwarden
    install_joplin
    install_localsend
}

install_system_tools() {
    echo_info "Installing system tools..."
    install_swayosd
    install_satty
    install_tzupdate
}

install_fonts() {
    echo_info "Installing fonts..."
    install_nerd_fonts
}

install_custom() {
    echo ""
    echo "Available packages:"
    echo "  1) Hyprland ecosystem"
    echo "  2) Walker"
    echo "  3) Elephant (Walker plugins)"
    echo "  4) Waybar"
    echo "  5) Docker CE"
    echo "  6) Bitwarden"
    echo "  7) Gum"
    echo "  8) LazyDocker"
    echo "  9) Mise"
    echo " 10) SwayOSD"
    echo " 11) Satty"
    echo " 12) Joplin"
    echo " 13) LocalSend"
    echo " 14) Nerd Fonts"
    echo " 15) tzupdate"
    echo ""

    install_hyprland_copr
    install_walker
    install_elephant
    install_waybar
    install_docker_ce
    install_bitwarden
    install_gum
    install_lazydocker
    install_mise
    install_swayosd
    install_satty
    install_joplin
    install_localsend
    install_nerd_fonts
    install_tzupdate
}

# Main loop
while true; do
    show_menu

    case $choice in
        1)
            install_essential
            ;;
        2)
            install_dev_tools
            ;;
        3)
            install_desktop_apps
            ;;
        4)
            install_system_tools
            ;;
        5)
            install_fonts
            ;;
        6)
            echo_info "Installing all packages..."
            install_essential
            install_dev_tools
            install_desktop_apps
            install_system_tools
            install_fonts
            ;;
        7)
            install_custom
            ;;
        q|Q)
            echo ""
            echo_success "Installation helper finished!"
            echo ""
            echo "For more information on remaining packages, see:"
            echo "$OMARCHY_INSTALL/omarchy-base-fedora-alternatives.md"
            echo ""
            exit 0
            ;;
        *)
            echo_error "Invalid choice. Please try again."
            sleep 2
            ;;
    esac

    echo ""
    read -p "Press Enter to continue..."
done
