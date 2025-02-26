# Setup `windows`

- [Setup `windows`](#setup-windows)
  - [Before you start](#before-you-start)
  - [Install Package managers](#install-package-managers)
    - [Windows Package Manager](#windows-package-manager)
    - [Scoop](#scoop)
    - [Chocolatey _(optional)_](#chocolatey-optional)
  - [Manage core applications](#manage-core-applications)
    - [Install applications](#install-applications)
    - [Upgrade applications](#upgrade-applications)
  - [Initialize dotfiles with chezmoi](#initialize-dotfiles-with-chezmoi)
  - [Configure PowerShell profile](#configure-powershell-profile)
  - [Install Visual Studio Code](#install-visual-studio-code)

---

## Before you start

This guide will assist you in setting up your Windows environment, ideally following a fresh Windows installation.

**All commands in this guide should be executed in a PowerShell console.**

## Install Package managers

**Windows Package Manager (winget)** and **Scoop** package managers are required for the next action steps.

### Windows Package Manager

Windows Package Manager (winget) is the official package management tool for the Windows operating system.

_Think of it as a command-line alternative to the Microsoft Store._

**This command-line tool is bundled with modern versions of Windows (starting from Windows 10).**
**Chances are, you won’t need to install it.**

🔗 [How to install winget](https://docs.microsoft.com/en-us/windows/package-manager/winget/#install-winget)

### Scoop

Scoop installs packaged applications as non-Administrator (by default) inside user directory.

🔗 [How to install scoop](https://scoop.sh/)

### Chocolatey _(optional)_

Chocolatey installs packaged applications as Administrator in conventional installation locations.

🔗 [How to install Chocolatey](https://chocolatey.org/install)

## Manage core applications

### Install applications

```sh
# install winget packages
winget install -s winget --id Microsoft.Powershell       # PowerShell Core - most popular Windows shell
winget install -s winget --id Microsoft.WindowsTerminal  # Windows Terminal - Windows Terminal emulator
winget install -s winget --id Microsoft.PowerToys        # PowerToys - set of utilities for power users

# install scoop packages (main bucket)
scoop install main/git       # Git - official Git client
scoop install main/7zip      # 7-Zip - file archiver
scoop install main/chezmoi   # chezmoi - dotfiles manager
scoop install main/ripgrep   # ripgrep - grep-clone tool
scoop install main/fd        # fd - find-clone tool
scoop install main/bat       # bat - cat-clone tool
scoop install main/fzf       # fzf - fuzzy finder
scoop install main/starship  # Starship - cross-shell prompt
scoop install main/neovim    # Neovim - text editor program

# install scoop packages (extra bucket)
scoop bucket add extras
scoop install extras/lazygit         # lazygit - terminal UI for git commands
scoop install extras/posh-git        # posh-git - PowerShell module that integrates Git and PowerShell
scoop install extras/terminal-icons  # Terminal-Icons - PowerShell module that displays file and folder icons in terminal
scoop install extras/PSFzf           # psfzf - PowerShell module that provides a wrapper for fzf

# install scoop packages (nerd-fonts bucket)
scoop bucket add nerd-fonts
scoop install nerd-fonts/CascadiaCode-NF-Mono  # Cascadia Code Mono - coding font
```

_Feel free to check out this [catalog file](./catalog.md), which provides a list of packages/applications organized by specific usage._

### Upgrade applications

```sh
# Upgrade winget packages individually
winget upgrade --id Microsoft.Powershell
winget upgrade --id Microsoft.WindowsTerminal
winget upgrade --id Microsoft.PowerToys

# Upgrade all Scoop packages, skipping the cache to avoid unnecessary disk usage
scoop update --all --no-cache
```

## Initialize dotfiles with chezmoi

To set up chezmoi and apply the dotfiles, follow these steps:

_This requires an SSH key pair to connect to GitHub._

To generate an SSH key, use this command:

_Skip it if you already have a key pair._

```sh
sh-keygen -t ed25519 -C "Generated on $(Get-date -Format 'yyyy-MM-dd HH:mm:ss')"
```

Then, add the generated public key to your [GitHub SSH keys](https://github.com/settings/keys).

Finally, initialize and apply your dotfiles with:

```sh
chezmoi init --apply --verbose git@github.com:VouDoo/dotfiles.git
```

## Configure PowerShell profile

_The PowerShell profile files are maintained by [chezmoi](https://www.chezmoi.io/)._

Once you've applied the files with chezmoi, you'll need to install the requirements for the PowerShell profile.
Open a new PowerShell session and execute the following command:

```powershell
Install-MyModules
```

## Install Visual Studio Code

Download and install from <https://code.visualstudio.com/download>.

Then, synchronize the configuration with your GitHub account.
