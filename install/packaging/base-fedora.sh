#!/bin/bash
# Install all base packages for Fedora
# This script replaces the Arch Linux pacman-based installation with dnf

# Read packages from the Fedora package list
mapfile -t packages < <(grep -v '^#' "$OMARCHY_INSTALL/omarchy-base-fedora.packages" | grep -v '^$' | grep -v '^!')

# Install packages that are available in Fedora repos
if [ ${#packages[@]} -gt 0 ]; then
  sudo dnf install -y "${packages[@]}"
fi

# Note: Packages marked with ! in the package list need special handling
# See omarchy-base-fedora-alternatives.md for installation instructions
