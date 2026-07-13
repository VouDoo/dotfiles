#!/usr/bin/env sh

###############################################################################
# Arch Linux Post-Install & Environment Provisioning Script
#
# Description:
#   Automates the deployment of a minimal, modern Wayland development environment
#   on a fresh Arch Linux installation. This script synchronizes system packages,
#   deploys user dotfiles via Chezmoi, configures the Ly TUI display manager,
#   and installs a curated stack of modern CLI tools, TUIs, and core applications.
#
# Prerequisites:
#   - A fresh installation with an active internet connection.
#   - Target repository access for dotfiles deployment.
#
###############################################################################

# Exit immediately if any command fails
set -e

# System Synchronization
# Install base packages and sync the entire system packages.
sudo pacman -Syu --needed base-devel git

# AUR helper
# Install Paru.
if ! command -v paru >/dev/null 2>&1; then
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  (cd /tmp/paru && makepkg -si --noconfirm)
  rm -rf /tmp/paru
fi

# Dotfiles & Configuration
# Deploy personal configuration files using chezmoi directly from GitHub.
paru -S --needed chezmoi
chezmoi init --apply https://github.com/VouDoo/dotfiles.git

# Display Manager (Login Screen)
# Ly manages user logins. Standard ly.service handles TTY switching automatically.
paru -S --needed ly
sudo systemctl enable ly@tty2.service

# Desktop Environment (Wayland Window Manager & Portal)
# Niri is a scrollable-tiling compositor. XDG portals handle screensharing and file dialogues.
paru -S --needed niri xwayland-satellite xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk

# Core Shell & Aesthetics
# Installs 0xProto Nerd Font for UI iconography, and Noctalia as the top-bar/shell.
paru -S --needed ttf-0xproto-nerd noctalia-git

# Clipboard Management
# wl-clipboard provides copy/paste backends; cliphist acts as the local clipboard history daemon.
paru -S --needed wl-clipboard cliphist

# Modern CLI Tooling
# Modern terminal utilities replacing standard coreutils (ls -> eza, cat -> bat, cd -> zoxide, etc.)
paru -S --needed fish starship bat btop eza fd fzf ripgrep zoxide rsync git-delta tlrc-bin fastfetch

# Text Editors
# Neovim and Helix for modal terminal-based editing.
paru -S --needed neovim helix

# Terminal User Interfaces (TUI)
# Console dashboards for managing network, bluetooth, audio, files, and git.
paru -S --needed impala bluetui pavucontrol yazi lazygit

# Core Productivity Apps
# Ghostty (Terminal), Zen (Browser), KeePassXC (Credentials), and Rclone (Cloud Storage Sync).
paru -S --needed ghostty zen-browser-bin keepassxc qt5-wayland rclone

echo "Set Fish as default shell for your user:"
chsh --shell /usr/bin/fish

echo "Base installation complete! Please reboot your system."
