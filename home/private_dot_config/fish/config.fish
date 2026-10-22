#  https://fishshell.com/docs/current/index.html
# NOTE: Personal config is sourced from here rather than from conf.d, so it runs in the order below.
#       conf.d is left to packages and plugins (it runs before this file).

# Environment (PATH and variables)
source $__fish_config_dir/env.fish

if type -q mise
    mise activate fish | source
end

# Interactive setup (prompt, key bindings, functions, abbreviations)
source $__fish_config_dir/interactive.fish
