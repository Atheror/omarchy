#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -eEo pipefail

# Define Omarchy locations
export OMARCHY_PATH="$HOME/.local/share/omarchy"
export OMARCHY_INSTALL="$OMARCHY_PATH/install"
export OMARCHY_INSTALL_LOG_FILE="/var/log/omarchy-install.log"
export PATH="$OMARCHY_PATH/bin:$PATH"

# Set Fedora-specific flag
export OMARCHY_FEDORA=1

# Verify we're on Fedora
if [ ! -f /etc/fedora-release ]; then
  echo "ERROR: This script is designed for Fedora Linux."
  echo "Detected OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d= -f2 | tr -d '\"')"
  echo "Please use install.sh for Arch Linux or check your distribution."
  exit 1
fi

echo "=========================================="
echo "Omarchy Installation for Fedora"
echo "=========================================="
echo ""
echo "Detected: $(cat /etc/fedora-release)"
echo ""
echo "This will install Omarchy and its dependencies."
echo "Some packages will need manual installation after this script completes."
echo "See: $OMARCHY_INSTALL/omarchy-base-fedora-alternatives.md"
echo ""
read -p "Press Enter to continue or Ctrl+C to cancel..."

# Install helpers and preflight checks
source "$OMARCHY_INSTALL/helpers/all.sh"
source "$OMARCHY_INSTALL/preflight/all.sh"

# Run Fedora-specific preflight
run_logged $OMARCHY_INSTALL/preflight/dnf.sh

# Install packages using Fedora scripts
echo ""
echo "Installing base packages..."
run_logged $OMARCHY_INSTALL/packaging/base-fedora.sh

echo ""
echo "Installing fonts..."
run_logged $OMARCHY_INSTALL/packaging/fonts.sh

echo ""
echo "Setting up Neovim..."
run_logged $OMARCHY_INSTALL/packaging/nvim.sh

echo ""
echo "Installing icons..."
run_logged $OMARCHY_INSTALL/packaging/icons.sh

echo ""
echo "Installing webapps..."
run_logged $OMARCHY_INSTALL/packaging/webapps.sh

echo ""
echo "Installing TUIs..."
run_logged $OMARCHY_INSTALL/packaging/tuis.sh

# Run configuration
echo ""
echo "Configuring system..."
source "$OMARCHY_INSTALL/config/all.sh"

# Setup login manager
echo ""
echo "Setting up login manager..."
source "$OMARCHY_INSTALL/login/all.sh"

# Post-install
echo ""
echo "Running post-install tasks..."
source "$OMARCHY_INSTALL/post-install/all.sh"

echo ""
echo "=========================================="
echo "Omarchy Installation Complete!"
echo "=========================================="
echo ""
echo "IMPORTANT: Some packages require manual installation."
echo "Please review: $OMARCHY_INSTALL/omarchy-base-fedora-alternatives.md"
echo ""
echo "Key packages that need manual setup:"
echo "  - Hyprland ecosystem (enable COPR: solopasha/hyprland)"
echo "  - Walker application launcher (build from GitHub)"
echo "  - SwayOSD, Satty, Wayfreeze (build from source)"
echo "  - Various other tools (see alternatives guide)"
echo ""
echo "Installation log: $OMARCHY_INSTALL_LOG_FILE"
echo ""
