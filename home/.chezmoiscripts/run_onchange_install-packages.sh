#!/usr/bin/env sh

###############################################################################
# System packages
#
# Description:
#   Installs the curated stack of packages with paru.
#   chezmoi re-runs this script on 'chezmoi apply' whenever its content changes,
#   so adding a package below and running 'chezmoi apply' installs it.
#
# NOTE: Removing a package from this list does not uninstall it.
#
###############################################################################

set -e

# Helper function to invoke paru command
_paru() {
  paru -S --needed "$@"
}

# Package managers
# Install Mise
_paru mise

# Display Manager (Login Screen)
# Ly manages user logins.
_paru ly

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

# Clipboard Management
# wl-clipboard provides copy/paste backends.
# cliphist acts as the local clipboard history daemon.
_paru wl-clipboard cliphist

# Desktop Notifications
# libnotify provides notify-send to send notifications from scripts (displayed by Noctalia).
_paru libnotify

# Interactive Shell
_paru fish

# Modern CLI Tooling
# Some utilities replace standard coreutils (ls -> eza, cat -> bat, cd -> zoxide, etc.).
_paru starship bat btop eza fd fzf ripgrep zoxide rsync git-delta git-lfs tealdeer fastfetch

# Essential compression/archiving tools
_paru tar zip unzip gzip xz bzip2

# Text Editors
# Neovim with dependencies for terminal-based editing.
_paru neovim tree-sitter-cli

# Terminal User Interfaces (TUI)
# Console dashboards for managing network, bluetooth, audio, files, and git.
_paru impala bluetui pavucontrol yazi lazygit lazydocker

# Containers
# Podman is a daemonless Docker alternative (also used by lazydocker via the lazypodman wrapper).
_paru podman

# Core Productivity Apps
# Ghostty (Terminal), Brave Origin (Browser), KeePassXC (Credentials), Rclone (Cloud Storage Sync), and Taskwarrior (ToDo list).
_paru ghostty brave-origin-bin keepassxc qt5-wayland rclone task

# Multimedia Apps
# FFmpeg (Multimedia libs and programs), imv (Image viewer), and mpv (Media player)
_paru ffmpeg imv mpv

# Extra AUR packages
_paru localsend-bin marktext-bin
