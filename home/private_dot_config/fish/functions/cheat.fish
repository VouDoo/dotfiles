function cheat --description 'Show a cheat sheet from offline tldr, falling back to cheat.sh'
    argparse --exclusive w,o h/help w/web o/offline u/update -- $argv
    or return

    if set -q _flag_help
        echo 'Usage: cheat [-w | -o] [COMMAND [SUBCOMMAND | QUERY...]]
       cheat -u

Show the offline tldr page for COMMAND, or ask cheat.sh if there is none.
With no COMMAND, pick a tldr page with fzf.

  -w, --web       Skip tldr and query cheat.sh
  -o, --offline   Use tldr only, never the network
  -u, --update    Update the tldr cache and cheat.sh topics
  -h, --help      Show this help

Examples:
  cheat tar                    tldr page for tar
  cheat git log                tldr page for git-log
  cheat python reverse list    cheat.sh answer (cht.sh/python/reverse+list)'
        return 0
    end

    if set -q _flag_update
        __cheat_require tldr curl; or return
        tldr --update; and __cheatsh_topics --update
        return
    end

    if test (count $argv) -eq 0
        __cheat_require tldr fzf; or return
        set -l page (tldr --list | fzf --prompt 'cheat> ' \
            --preview 'tldr --no-auto-update --color always {}' \
            --preview-window 'right,65%,wrap')
        or return
        set argv $page
    end

    if not set -q _flag_web; and type -q tldr
        tldr --no-auto-update --quiet $argv 2>/dev/null
        and return
    end

    if set -q _flag_offline
        __cheat_require tldr; or return
        echo "cheat: no tldr page for '$argv'" >&2
        return 1
    end

    __cheat_require curl; or return

    # cht.sh/<topic>/<query+words>, each word URL-encoded
    set -l words (string escape --style=url -- $argv)
    set -l url cht.sh/(string join / -- $words[1] (string join + -- $words[2..]))

    # Plain text when not printing to a terminal
    isatty stdout; or set url "$url?T"

    set -l sheet (curl -fsS -m 10 -- $url)
    or begin
        echo "cheat: could not reach cheat.sh" >&2
        return 1
    end

    if string match -q 'Unknown topic.*' -- $sheet[1]
        echo "cheat: no cheat sheet found for '$argv'" >&2
        printf '%s\n' $sheet >&2
        return 1
    end

    if not isatty stdout
        printf '%s\n' $sheet
        return
    end

    # $PAGER may carry arguments (e.g. 'less -S'), default to less
    test -n "$PAGER"; or set -l PAGER less
    # Keep colors and quit if one screen, without overriding $LESS
    set -lx LESS "-RFX $LESS"
    printf '%s\n' $sheet | eval $PAGER
end

function __cheat_require --description 'Fail unless every given command is installed'
    set -l missing (for cmd in $argv; type -q $cmd; or echo $cmd; end)
    test -z "$missing"; and return
    echo "cheat: missing required command(s): $missing" >&2
    return 127
end
