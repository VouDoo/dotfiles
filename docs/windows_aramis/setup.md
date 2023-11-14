# Setup `windows/aramis`

- [Setup `windows/aramis`](#setup-windowsaramis)
  - [Install Package managers](#install-package-managers)
    - [Windows Package Manager](#windows-package-manager)
    - [Scoop](#scoop)
    - [Chocolatey](#chocolatey)
  - [Install essential applications](#install-essential-applications)
  - [Initialize dotfiles - chezmoi](#initialize-dotfiles---chezmoi)
  - [Initialize PowerShell profile](#initialize-powershell-profile)

---

## Install Package managers

I mainly use `winget` and `scoop`. So these package managers are required for the next action steps.

I only use `Chocolatey` in some cases for specific packages.

### Windows Package Manager

Windows Package Manager (winget) is the official package manager on Windows OS.

_It's basically the command-line version of the Microsoft Store._

**This command-line tool is bundled with modern versions of Windows (from Windows 10).**

🔗 [How to install winget](https://docs.microsoft.com/en-us/windows/package-manager/winget/#install-winget)

### Scoop

Scoop installs packaged applications as non-Administrator (by default) inside user directory.

🔗 [How to install scoop](https://scoop.sh/)

### Chocolatey

Chocolatey installs packaged applications as Administrator in conventional installation locations.

🔗 [How to install Chocolatey](https://chocolatey.org/install)

## Install essential applications

```sh
# install winget packages
winget install -s winget --id Microsoft.Powershell       # PowerShell Core - shell
winget install -s winget --id Microsoft.WindowsTerminal  # Windows Terminal - terminal emulator
winget install -s winget --id Git.Git                    # Git - Git client

# install scoop packages (main bucket)
scoop install main/7zip     # 7-Zip - file archiver
scoop install main/chezmoi  # chezmoi - dotfiles manager
scoop install main/neovim   # Neovim - text editor
scoop install main/ripgrep  # ripgrep - grep-clone tool
scoop install main/fd       # fd - find-clone tool
scoop install main/bat      # bat - cat-clone tool
scoop install main/lf       # lf - terminal file manager
scoop install main/eza      # eza - ls-clone tool
scoop install main/jq       # jq - JSON processor
scoop install main/tokei    # tokei - code stats

scoop bucket add extras
scoop install extras/lazygit  # lazygit - terminal UI for git commands

scoop bucket add nerd-fonts
scoop install nerd-fonts/CascadiaCode-NF-Mono  # Cascadia Code Mono - coding font
```

## Initialize dotfiles - chezmoi

To initialize `chezmoi` and apply the dotfiles, run:

```sh
chezmoi init --apply --verbose https://github.com/VouDoo/dotfiles.git
```

## Initialize PowerShell profile

_The PowerShell profile files are maintained by `chezmoi`._

To install the requirements for the PowerShell profile,
run these PowerShell commands:

```powershell
Install-OhMyPosh -Method "winget"  # or scoop
Install-MyModules
```
