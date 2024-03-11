@{
    # Personal details
    Name          = "Maxence"
    Email         = "maxgrymonprez@live.fr"
    GitHubProfile = "VouDoo"
    # Development environment and tools
    Workspace     = "~\Workspace"
    TextEditor    = "code.cmd"  # VS Code
    KubeEditor    = "code.cmd --wait"  # VS Code
    # Oh My Posh
    OhMyPoshTheme = "material"  # Available themes: https://ohmyposh.dev/docs/themes
    # aide-memoire for commands and alias
    AideMemoire   = @(
        @{
            Command     = "rg"
            Description = "Execute ripgrep grep-like tool"
        }
        @{
            Command     = "fd"
            Description = "Execute fd find-like tool"
        }
        @{
            Command     = "bat"
            Description = "Execute bat cat-like tool"
        }
        @{
            Command     = "lf"
            Description = "Execute lf terminal file manager"
        }
        @{
            Command     = "eza"
            Description = "Execute eza ls-like like"
        }
        @{
            Command     = "jq"
            Description = "Execute jq JSON processor"
        }
        @{
            Command     = "tokei"
            Description = "Execute tokei code stats"
        }
        @{
            Command     = "fzf"
            Description = "Execute fzf fuzzy finder"
        }
        @{
            Command     = "git"
            Description = "Execute Git client"
        }
        @{
            Command     = "winget"
            Description = "Execute Windows Package Manager"
        }
        @{
            Command     = "scoop"
            Description = "Execute scoop package manager"
        }
        @{
            Command     = "choco"
            Description = "Execute Chocolatey package manager"
        }
        @{
            Command     = "lazygit"
            Description = "Execute lazygit GUI Git client"
        }
        @{
            Command     = "glow"
            Description = "Execute glow markdown render"
        }
        @{
            Command     = "nvim"
            Description = "Execute Neovim text editor"
        }
        @{
            Command     = "kubectl"
            Description = "Execute kubectl cmdline tool"
        }
        @{
            Command     = "kubectx"
            Description = "Execute kubectx cmdline tool"
        }
        @{
            Command     = "kubens"
            Description = "Execute kubens cmdline tool"
        }
        @{
            Command     = "k9s"
            Description = "Execute k9s TUI tool"
        }
        @{
            Command     = "kind"
            Description = "Execute KinD cmdline tool"
        }
    )
}
