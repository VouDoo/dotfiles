#  https://fishshell.com/docs/current/index.html

# Environment variables - https://fishshell.com/docs/current/cmds/set.html
set -gx EDITOR "nvim"
set -gx PAGER "less"
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
end
