function mkcd --wraps mkdir --description 'Create a directory and change into it'
    if test (count $argv) -ne 1
        echo 'Usage: mkcd DIRECTORY' >&2
        return 1
    end
    mkdir -p -- $argv[1]
    and builtin cd -- $argv[1]
end
