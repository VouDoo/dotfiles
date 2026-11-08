function __wifi_tui --description 'Print the Wi-Fi TUI for the running backend'
    if systemctl is-active --quiet iwd.service; and type -q impala
        echo impala
    else if type -q nmtui
        echo nmtui
    else if type -q iwctl
        echo iwctl
    else
        return 1
    end
end
