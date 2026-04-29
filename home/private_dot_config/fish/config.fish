#  https://fishshell.com/docs/current/index.html

# Add to PATH environment variable - https://fishshell.com/docs/current/cmds/fish_add_path.html
fish_add_path -m ~/.local/bin
fish_add_path -m ~/.npm-global/bin

# Environment variables - https://fishshell.com/docs/current/cmds/set.html
set -gx EDITOR nvim
set -gx PAGER less
set -gx XDG_CONFIG_HOME "$HOME/.config"

if status is-interactive
    source $XDG_CONFIG_HOME/fish/abbreviations.fish
    if type -q starship
        set -gx STARSHIP_CONFIG "$XDG_CONFIG_HOME/starship.toml"
        starship init fish | source
    end
    if type -q zoxide
        zoxide init fish | source
    end
    if type -q thefuck
        thefuck --alias | source
    end
end
