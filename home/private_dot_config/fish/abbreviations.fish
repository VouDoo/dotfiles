# https://fishshell.com/docs/current/cmds/abbr.html

abbr -a cd z
abbr -a find fd
abbr -a grep rg
abbr -a tree ls --tree
abbr -a vi nvim
abbr -a vim nvim
abbr -a lazygit lgit
abbr -a cm chezmoi
if type -q bluetoothctl
    abbr -a bluetooth bluetoothctl
end
if type -q iwctl
    abbr -a wifi iwctl
end
