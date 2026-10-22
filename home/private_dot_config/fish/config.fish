#  https://fishshell.com/docs/current/index.html

# Environment (PATH and variables)
source $__fish_config_dir/env.fish

if type -q mise
    mise activate fish | source
end
