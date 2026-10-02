#!/usr/bin/env sh

###############################################################################
# System setup
#
# Description:
#   Installs paru (AUR helper) if missing, the curated stack of packages,
#   then configures the Ly display manager and sets Fish as default shell.
#   chezmoi re-runs this script on 'chezmoi apply' whenever its content changes,
#   so adding a package below and running 'chezmoi apply' installs it.
#   Every step is safe to run again.
#
# NOTE: Removing a package from this list does not uninstall it.
#
###############################################################################

set -e

# AUR helper
# Install Paru.
if ! command -v paru >/dev/null 2>&1; then
  sudo pacman -S --needed base-devel git
  PARU_BUILD_DIR="$(mktemp -d)"
  git clone https://aur.archlinux.org/paru.git "$PARU_BUILD_DIR"
  (cd "$PARU_BUILD_DIR" && makepkg -si --noconfirm)
  rm -rf "$PARU_BUILD_DIR"
fi

# Packages are collected per section, then installed with a single paru call.
PACKAGES=""
add_packages() {
  PACKAGES="$PACKAGES $*"
}

# Package managers
# Install Mise
add_packages mise

# Display Manager (Login Screen)
# Ly manages user logins.
add_packages ly

# Desktop Environment (Wayland Window Manager & Portal)
# Niri is a scrollable-tiling compositor.
# XDG portals handle screensharing and file dialogues.
# kanshi allows you to define output profiles that are automatically enabled and disabled on hotplug.
add_packages niri xwayland-satellite xdg-desktop-portal xdg-desktop-portal-gnome xdg-desktop-portal-gtk kanshi hyprpicker

# Desktop Shell & Theming
# Nerd Font for UI iconography and Noctalia desktop shell.
add_packages ttf-0xproto-nerd noctalia
# GTK theme
# NOTE: Noctalia manages the global theme and can dynamically apply its colors to GTK apps with adw-gtk3.
add_packages adw-gtk-theme
# Icon theme
add_packages papirus-icon-theme
# GTK configuration
# nwg-look provides a GUI to configure GTK themes and icons.
add_packages nwg-look

# Clipboard Management
# wl-clipboard provides copy/paste backends.
# cliphist acts as the local clipboard history daemon.
add_packages wl-clipboard cliphist

# Desktop Notifications
# libnotify provides notify-send to send notifications from scripts (displayed by Noctalia).
add_packages libnotify

# Interactive Shell
add_packages fish

# Modern CLI Tooling
# Some utilities replace standard coreutils (ls -> eza, cat -> bat, cd -> zoxide, etc.).
add_packages starship bat btop eza fd fzf ripgrep zoxide rsync git-delta git-lfs tealdeer fastfetch

# Essential compression/archiving tools
add_packages tar zip unzip gzip xz bzip2

# Text Editors
# Neovim with dependencies for terminal-based editing.
add_packages neovim tree-sitter-cli

# Terminal User Interfaces (TUI)
# Console dashboards for managing network, bluetooth, audio, files, and git.
add_packages impala bluetui pavucontrol yazi lazygit lazydocker

# Containers
# Podman is a daemonless Docker alternative (also used by lazydocker via the lazypodman wrapper).
add_packages podman

# Core Productivity Apps
# Ghostty (Terminal), Brave Origin (Browser), KeePassXC (Credentials), Rclone (Cloud Storage Sync), and Taskwarrior (ToDo list).
add_packages ghostty brave-origin-bin keepassxc qt5-wayland rclone task

# Multimedia Apps
# FFmpeg (Multimedia libs and programs), imv (Image viewer), and mpv (Media player)
add_packages ffmpeg imv mpv

# Extra AUR packages
add_packages localsend-bin marktext-bin

# Install everything at once (word splitting of $PACKAGES is intended)
paru -S --needed $PACKAGES

# Display Manager (Login Screen)
# Standard ly.service handles TTY switching automatically.
if ! systemctl is-enabled --quiet ly@tty2.service; then
  echo "Enabling Ly display manager..."
  sudo systemctl enable ly@tty2.service
fi

# Interactive Shell
# Set Fish as the default shell.
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
