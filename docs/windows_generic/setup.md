# Setup `windows`

- [Setup `windows`](#setup-windows)
  - [Install Package managers](#install-package-managers)
    - [Windows Package Manager (required)](#windows-package-manager-required)
    - [Scoop (required)](#scoop-required)
    - [Chocolatey _(optional)_](#chocolatey-optional)
  - [Manage my core applications](#manage-my-core-applications)
    - [Install applications](#install-applications)
    - [Update applications](#update-applications)
  - [Initialize dotfiles - chezmoi](#initialize-dotfiles---chezmoi)
  - [Initialize PowerShell profile](#initialize-powershell-profile)
  - [Install Visual Studio Code](#install-visual-studio-code)

---

## Install Package managers

I mainly use `winget` and `scoop`. So these package managers are required for the next action steps.

I only use `Chocolatey` in some cases for specific packages.

### Windows Package Manager (required)

Windows Package Manager (winget) is the official package manager on Windows OS.

_It's basically the command-line version of the Microsoft Store._

**This command-line tool is bundled with modern versions of Windows (from Windows 10).**

🔗 [How to install winget](https://docs.microsoft.com/en-us/windows/package-manager/winget/#install-winget)

### Scoop (required)

Scoop installs packaged applications as non-Administrator (by default) inside user directory.

🔗 [How to install scoop](https://scoop.sh/)

### Chocolatey _(optional)_

Chocolatey installs packaged applications as Administrator in conventional installation locations.

🔗 [How to install Chocolatey](https://chocolatey.org/install)

## Manage my core applications

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

scoop bucket add extras
scoop install extras/lazygit         # lazygit - terminal UI for git commands
scoop install extras/posh-git        # posh-git - PowerShell module that integrates Git and PowerShell
scoop install extras/terminal-icons  # Terminal-Icons - PowerShell module that displays file and folder icons in terminal
scoop install extras/PSFzf           # psfzf - PowerShell module that provides a wrapper for fzf

scoop bucket add nerd-fonts
scoop install nerd-fonts/CascadiaCode-NF-Mono  # Cascadia Code Mono - coding font
```

My extra applications are listed in [`extra_packages` directory](./extra_packages):

- [Packages for Kubernetes](./extra_packages/k8s.md)

### Update applications

```sh
winget upgrade --id Microsoft.Powershell
winget upgrade --id Microsoft.WindowsTerminal
winget upgrade --id Microsoft.PowerToys
scoop update --all --no-cache
```

## Initialize dotfiles - chezmoi

To initialize `chezmoi` and apply the dotfiles, run:

_This requires an SSH key pair to connect GitHub._

```sh
chezmoi init --apply --verbose git@github.com:VouDoo/dotfiles.git
```

## Initialize PowerShell profile

_The PowerShell profile files are maintained by `chezmoi`._

To install the requirements for the PowerShell profile,
run these PowerShell commands:

```powershell
Install-MyModules
```

## Install Visual Studio Code

Download and install from <https://code.visualstudio.com/download>.

Then, synchronize the configuration with the GitHub account.
