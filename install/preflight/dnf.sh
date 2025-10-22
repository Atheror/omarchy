#!/bin/bash
# Fedora DNF configuration and system update
# Replaces preflight/pacman.sh for Fedora systems

if [[ -n ${OMARCHY_ONLINE_INSTALL:-} ]]; then
  # Install development tools (equivalent to base-devel on Arch)
  sudo dnf groupinstall -y "Development Tools"
  sudo dnf install -y rpm-build rpmdevtools

  # Enable RPM Fusion repositories (needed for many multimedia packages)
  sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
  sudo dnf install -y https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

  # Enable COPR for Hyprland ecosystem (if not already enabled)
  # sudo dnf copr enable -y solopasha/hyprland

  # Update all system packages
  sudo dnf upgrade -y --refresh
fi
