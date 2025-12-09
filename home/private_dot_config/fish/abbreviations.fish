# https://fishshell.com/docs/current/cmds/abbr.html

abbr -a cd z
abbr -a find fd
abbr -a grep rg
abbr -a cat bat
abbr -a tree ls --tree
abbr -a lazygit lgit
abbr -a cm chezmoi
if type -q nvim
    abbr -a vi nvim
    abbr -a vim nvim
end
if type -q helix
    abbr -a hx helix
end
if type -q bluetoothctl
    abbr -a bluetooth bluetoothctl
end
if type -q impala
    abbr -a wifi impala
else
    abbr -a wifi iwctl
end
