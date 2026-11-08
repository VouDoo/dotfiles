# $ ~/\.files

<p align="center">
  <a href="https://archlinux.org/"><img src="https://img.shields.io/badge/Arch_Linux-1793D1?logo=archlinux&logoColor=white" alt="Arch Linux"></a>
  <a href="https://www.chezmoi.io/"><img src="https://img.shields.io/badge/managed_with-chezmoi-4B91E2" alt="Managed with chezmoi"></a>
  <a href="./LICENSE"><img src="https://img.shields.io/badge/license-GPL--2.0-green" alt="License: GPL-2.0"></a>
</p>

**A whole desktop environment, set up in one command.**

My personal [dotfiles](https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#Unix_and_Unix-like_environments), managed with [chezmoi](https://www.chezmoi.io/).

## 🧰 What's inside

- 🪟 **Desktop**: tiling Wayland compositors, [Noctalia](https://github.com/noctalia-dev) desktop shell
- 🎨 **Theme**: Everforest, applied across apps
- 🐚 **Shell**: [fish](https://fishshell.com/) with [Starship](https://starship.rs/) prompt
- 🖥️ **Terminal**: [Ghostty](https://ghostty.org/)
- 📝 **Editor**: [Neovim](https://neovim.io/)
- ⚙️ **Tools**: modern replacements for everyday commands, plus a few TUIs ([full list](./home/.chezmoiscripts/run_onchange_setup-system.sh.tmpl))

## 🚀 Highlights

- **Themed end to end**: one color scheme across the desktop, terminal and TUIs.
- **Asks, doesn't assume**: a few questions at install time, and optional features (Podman, Kubernetes, Steam) are opt-in.
- **Safe to re-run**: every setup step checks before acting, and `chezmoi apply` only re-runs the setup script when it changes.
- **Plays nice with your system**: network, audio and Bluetooth stay as your installer set them up.

## ✨ Quick start

On a fresh Arch Linux (or Arch-based) install, log in as your user and run:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/VouDoo/dotfiles/main/rice-my-arch.sh)"
```

Read the [full instructions](./SETUP.md) before you start.

## 🍴 Make it yours

Fork it and rice away.
