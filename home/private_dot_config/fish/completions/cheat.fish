# Clear rules from an earlier version of this file, in case the shell already loaded it
complete -c cheat -e
complete -c cheat -f
complete -c cheat -s h -l help -d 'Show help'
complete -c cheat -s w -l web -d 'Skip tldr and query cheat.sh'
complete -c cheat -s o -l offline -d 'Use tldr only, never the network'
complete -c cheat -s u -l update -d 'Update the tldr cache and cheat.sh topics'

# First argument: tldr pages and cheat.sh topics, unless -w or -o rules one out
function __cheat_complete_topic
    __fish_seen_argument -s w -l web
    or tldr --list 2>/dev/null | string replace -r '$' '\ttldr'
    __fish_seen_argument -s o -l offline
    or __cheatsh_topics 2>/dev/null | string match -v '*/*' | string replace -r '$' '\tcheat.sh'
end

# Second argument: tldr subcommand pages (git-log -> log) and cheat.sh sub-topics (python/lambda -> lambda)
function __cheat_complete_subtopic
    # The topic is the first word after "cheat" that is not a flag
    set -l topic (commandline -xpc | string match -v -- '-*')[2]
    set topic (string escape --style=regex -- $topic)
    __fish_seen_argument -s w -l web
    or tldr --list 2>/dev/null | string replace -rf "^$topic-(.+)" '$1\ttldr'
    __fish_seen_argument -s o -l offline
    or __cheatsh_topics 2>/dev/null | string replace -rf "^$topic/(.+)" '$1\tcheat.sh'
end

complete -c cheat -n '__fish_is_nth_token 1; and not __fish_seen_argument -s u -l update' \
    -a '(__cheat_complete_topic)'
complete -c cheat -n '__fish_is_nth_token 2; and not __fish_seen_argument -s u -l update' \
    -a '(__cheat_complete_subtopic)'
