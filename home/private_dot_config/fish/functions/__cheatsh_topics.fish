function __cheatsh_topics --description 'List cheat.sh topics from a local cache, --update to refresh it'
    set -l cache_home $XDG_CACHE_HOME
    test -n "$cache_home"; or set cache_home ~/.cache
    set -l cache $cache_home/fish/cheatsh_topics

    if test "$argv[1]" = --update; or not test -s $cache
        type -q curl; or return 127
        # RFC pages are thousands of entries nobody completes
        set -l topics (curl -fsS -m 10 cht.sh/:list); or return
        mkdir -p (path dirname $cache)
        string match -rv '^rfc/' -- $topics >$cache
    end

    test "$argv[1]" = --update; or cat $cache
end
