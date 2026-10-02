#!/usr/bin/env sh

###############################################################################
# Arch Linux Post-Install & Environment Provisioning Script
#
# Description:
#   Automates the deployment of a minimal, modern Wayland development environment
#   on a fresh Arch Linux installation. This script synchronizes system packages,
#   deploys user dotfiles via Chezmoi (which also installs the curated stack of
#   packages), configures the Ly TUI display manager and sets Fish as default shell.
#
# Prerequisites:
#   - A fresh installation with an active internet connection.
#   - Target repository access for dotfiles deployment.
#
###############################################################################

set -e

if [ "$(id -u)" -eq 0 ]; then
  echo "Do not run this script as root."
  exit 1
fi

# System Synchronization
# Synchronize repositories and perform a full system upgrade.
sudo pacman -Syu --needed base-devel git chezmoi

# Dotfiles, Configuration & Packages
# Deploy personal configuration files using chezmoi directly from GitHub.
# chezmoi also installs paru and all system packages (see home/.chezmoiscripts/run_onchange_install-packages.sh).
chezmoi init --apply https://github.com/VouDoo/dotfiles.git

# Display Manager (Login Screen)
# Standard ly.service handles TTY switching automatically.
sudo systemctl enable ly@tty2.service

# Interactive Shell
FISH_PATH="$(command -v fish)"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$FISH_PATH" ]; then
  echo "Setting Fish as the default shell..."
  chsh --shell "$FISH_PATH"
fi

# Manual steps
echo "Manual setup required: run 'nwg-look' to configure GTK."
echo "  Widgets    -> adw-gtk3"
echo "  Icon theme -> Papirus"
echo "Manual setup required: run 'systemctl --user enable --now podman.socket' to use lazypodman."

echo "Base installation complete! Reboot your system to apply the changes and finish the setup."
