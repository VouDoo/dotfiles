#!/usr/bin/env sh

###############################################################################
# Arch Linux Post-Install & Environment Provisioning Script
#
# Description:
#   Bootstraps a fresh Arch Linux installation: installs chezmoi and deploys
#   the dotfiles. chezmoi then takes care of the rest (packages, display
#   manager, default shell), see home/.chezmoiscripts/run_onchange_setup-system.sh.
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
# Synchronize repositories, perform a full system upgrade and install chezmoi.
sudo pacman -Syu --needed git chezmoi

# Dotfiles & System Setup
# Deploy personal configuration files using chezmoi directly from GitHub.
chezmoi init --apply https://github.com/VouDoo/dotfiles.git

echo "Base installation complete! Reboot your system to apply the changes and finish the setup."
