function fish_greeting --description 'Set welcome message in interactive shells'
    # Datetime
    set_color brblack --dim
    set -l time_string (date "+%H:%M")
    set -l date_string (date "+%A %d %B %Y")
    echo "$time_string $date_string"
    set_color normal

    # System information
    # Full fastfetch once per login session, a one-line summary afterwards
    # (and always the summary when there is no login session to track)
    set -l login_marker
    if test -n "$XDG_SESSION_ID" -a -n "$XDG_RUNTIME_DIR"
        set login_marker $XDG_RUNTIME_DIR/fish_greeting_$XDG_SESSION_ID
    end
    set -l distro_string (string match -r '^PRETTY_NAME="?([^"]+)"?$' < /etc/os-release)[2]
    set -l user_string $USER@(prompt_hostname)
    if test -n "$login_marker"; and not test -e $login_marker
        touch $login_marker
        echo
        fastfetch --logo small
        echo
    else
        set_color brblack
        echo "$user_string ($distro_string) "(uptime -p)
        set_color normal
    end

    # WarGames-style greeting based on the time of day
    set -l hour (date +%-H)
    set_color bryellow --bold
    if test $hour -ge 6 -a $hour -lt 8
        # Early morning
        echo "Cognitive systems warming up..."
    else if test $hour -ge 8 -a $hour -lt 10
        # Morning
        echo "Good morning, operator. Shall we begin?"
    else if test $hour -ge 10 -a $hour -lt 16
        # Daytime
        echo "Systems ready. Shall we play a game?"
    else if test $hour -ge 16 -a $hour -lt 18
        # Late afternoon
        echo "Systems operational. Awaiting further instructions."
    else if test $hour -ge 18 -a $hour -lt 22
        # Evening
        echo "Systems nominal. Shall we see what happens?"
    else if test $hour -ge 22 -o $hour -lt 1
        # Night
        echo "Operator detected. Sleep protocols recommended."
    else
        # Very late
        echo "Operator still active. Sleep protocols overridden?"
    end
    set_color normal
end
