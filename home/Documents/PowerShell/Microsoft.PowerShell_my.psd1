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
            Description = "Execute ripgrep (grep-like)"
        }
        @{
            Command     = "fd"
            Description = "Execute fd (find-like)"
        }
        @{
            Command     = "bat"
            Description = "Execute bat (cat-like)"
        }
        @{
            Command     = "lf"
            Description = "Execute lf (terminal file manager)"
        }
        @{
            Command     = "eza"
            Description = "Execute eza (ls-like)"
        }
        @{
            Command     = "jq"
            Description = "Execute jq (JSON processor)"
        }
        @{
            Command     = "tokei"
            Description = "Execute tokei (code stats)"
        }
        @{
            Command     = "fzf"
            Description = "Execute fzf (fuzzy finder)"
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
            Description = "Execute lazygit (GUI Git client)"
        }
    )
}
