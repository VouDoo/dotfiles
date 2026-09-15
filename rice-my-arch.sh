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

set -e

if [ "$(id -u)" -eq 0 ]; then
  echo "Do not run this script as root."
  exit 1
fi

# System Synchronization
# Synchronize repositories and perform a full system upgrade.
sudo pacman -Syu --needed base-devel git

# AUR helper
# Install Paru.
if ! command -v paru >/dev/null 2>&1; then
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  (cd /tmp/paru && makepkg -si --noconfirm)
  rm -rf /tmp/paru
fi

# Helper function to invoke paru command
_paru() {
  paru -S --needed "$@"
}

# Package managers
# Install Mise
_paru mise

# Dotfiles & Configuration
# Deploy personal configuration files using chezmoi directly from GitHub.
_paru chezmoi
chezmoi init --apply https://github.com/VouDoo/dotfiles.git

# Display Manager (Login Screen)
# Ly manages user logins. Standard ly.service handles TTY switching automatically.
_paru ly
sudo systemctl enable ly@tty2.service

# Desktop Environment (Wayland Window Manager & Portal)
# Niri is a scrollable-tiling compositor.
# XDG portals handle screensharing and file dialogues.
# kanshi allows you to define output profiles that are automatically enabled and disabled on hotplug.
_paru niri xwayland-satellite xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk kanshi hyprpicker

# Desktop Shell & Theming
# Nerd Font for UI iconography and Noctalia desktop shell.
_paru ttf-0xproto-nerd noctalia
# GTK theme
# NOTE: Noctalia manages the global theme and can dynamically apply its colors to GTK apps with adw-gtk3.
_paru adw-gtk-theme
# Icon theme
_paru papirus-icon-theme
# GTK configuration
# nwg-look provides a GUI to configure GTK themes and icons.
_paru nwg-look
echo "Manual setup required: run 'nwg-look' to configure GTK."
echo "  Widgets    -> adw-gtk3"
echo "  Icon theme -> Papirus"

# Clipboard Management
# wl-clipboard provides copy/paste backends.
# cliphist acts as the local clipboard history daemon.
_paru wl-clipboard cliphist

# Interactive Shell
_paru fish
FISH_PATH="$(command -v fish)"
if [ "$(getent passwd "$USER" | cut -d: -f7)" != "$FISH_PATH" ]; then
  echo "Setting Fish as the default shell..."
  chsh --shell "$FISH_PATH"
fi

# Modern CLI Tooling
# Some utilities replace standard coreutils (ls -> eza, cat -> bat, cd -> zoxide, etc.).
_paru starship bat btop eza fd fzf ripgrep zoxide rsync git-delta tealdeer fastfetch

# Essential compression/archiving tools
_paru tar zip unzip gzip xz bzip2

# Text Editors
# Neovim and Helix for modal terminal-based editing.
_paru neovim helix

# Terminal User Interfaces (TUI)
# Console dashboards for managing network, bluetooth, audio, files, and git.
_paru impala bluetui pavucontrol yazi lazygit

# Core Productivity Apps
# Ghostty (Terminal), Brave Origin (Browser), KeePassXC (Credentials), and Rclone (Cloud Storage Sync).
_paru ghostty brave-origin-bin keepassxc qt5-wayland rclone

# Multimedia Apps
# FFmpeg (Multimedia libs and programs), imv (Image viewer), and mpv (Media player)
_paru ffmpeg imv mpv

# Extra AUR packages
_paru localsend-bin marktext-bin

echo "Base installation complete! Reboot your system to apply the changes and finish the setup."
