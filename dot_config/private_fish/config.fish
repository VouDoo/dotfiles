if status is-interactive
	# Variable for Oh My Fish theme bobthefish
	set -g theme_powerline_fonts no
	set -g theme_nerd_fonts yes
	set -g theme_date_format "+%H:%M:%S"

	# Commands to run in interactive sessions can go here
	if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
		exec startx -- -keeptty
	end
end
