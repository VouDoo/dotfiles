function agegh --description 'Encrypt a file for GitHub SSH keys with age, or decrypt it with local SSH keys'
    argparse h/help d/decrypt 'u/user=' 'o/output=' -- $argv
    or return

    if set -q _flag_help
        echo 'Usage: agegh [-u USER] [-o OUTPUT] FILE
       agegh -d [-o OUTPUT] FILE.age

Encrypt FILE for the SSH keys of a GitHub user, or decrypt it with your local SSH keys.

  -d, --decrypt         Decrypt FILE with ~/.ssh/id_ed25519 and ~/.ssh/id_rsa
  -u, --user USER       GitHub user to encrypt for (default: $GITHUB_USER)
  -o, --output OUTPUT   Output file (default: FILE.age, or FILE without .age when decrypting)
  -h, --help            Show this help

Examples:
  agegh notes.txt              encrypt for yourself into notes.txt.age
  agegh -u someone report.pdf  encrypt for someone into report.pdf.age
  agegh -d notes.txt.age       decrypt into notes.txt'
        return 0
    end

    if test (count $argv) -ne 1
        echo 'Usage: agegh [-d] [-u USER] [-o OUTPUT] FILE (see agegh --help)' >&2
        return 1
    end
    set -l file $argv[1]

    __agegh_require age; or return

    if not test -f $file
        echo "agegh: no such file '$file'" >&2
        return 1
    end

    if set -q _flag_decrypt
        set -l output $_flag_output
        if test -z "$output"
            set output (string replace -rf '\.age$' '' -- $file)
            or begin
                echo "agegh: '$file' does not end in .age, choose an output with -o" >&2
                return 1
            end
        end
        __agegh_check_output $output; or return

        set -l identities
        for key in ~/.ssh/id_ed25519 ~/.ssh/id_rsa
            test -f $key; and set -a identities -i $key
        end
        if test -z "$identities"
            echo 'agegh: no SSH private key found (~/.ssh/id_ed25519 or ~/.ssh/id_rsa)' >&2
            return 1
        end

        age -d $identities -o $output -- $file
        return
    end

    __agegh_require curl; or return

    set -l user $GITHUB_USER
    set -q _flag_user; and set user $_flag_user
    if test -z "$user"
        echo 'agegh: no GitHub user, set $GITHUB_USER or use -u' >&2
        return 1
    end
    set -l output $_flag_output
    test -n "$output"; or set output $file.age
    __agegh_check_output $output; or return

    set -l keys (curl -fsS -m 10 -- https://github.com/(string escape --style=url -- $user).keys)
    or begin
        echo "agegh: could not fetch SSH keys for GitHub user '$user'" >&2
        return 1
    end
    if test -z "$keys"
        echo "agegh: GitHub user '$user' has no SSH keys" >&2
        return 1
    end

    # age skips unsupported key types (ecdsa, sk-*) with a warning
    printf '%s\n' $keys | age -R - -o $output -- $file
    and echo "agegh: encrypted for $user into $output"
end

function __agegh_check_output --description 'Fail if the output file already exists (age overwrites it)'
    test -e $argv[1]; or return 0
    echo "agegh: '$argv[1]' already exists, remove it or choose another output with -o" >&2
    return 1
end

function __agegh_require --description 'Fail unless every given command is installed'
    set -l missing (for cmd in $argv; type -q $cmd; or echo $cmd; end)
    test -z "$missing"; and return
    echo "agegh: missing required command(s): $missing" >&2
    return 127
end
