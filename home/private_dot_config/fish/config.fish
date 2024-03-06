if status is-interactive
    # Variable for Oh My Fish theme bobthefish
    set -g theme_powerline_fonts no
    set -g theme_nerd_fonts yes
    set -g theme_date_format "+%H:%M:%S"

    # Abbreviations
    abbr -a bluetooth bluetoothctl
    abbr -a wifi iwctl
    abbr -a vol get_volume
    abbr -a lock lock_x_session
    abbr -a ll ls -l
    abbr -a ssh TERM=xterm /usr/bin/ssh
    abbr -a find fd
    abbr -a grep rg
    abbr -a vi nvim
    abbr -a vim nvim
    abbr -a cm chezmoi
    abbr -a lgit lazygit
    abbr -a task go-task

    # Commands to run in interactive sessions can go here
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
        exec startx -- -keeptty
    end
end
