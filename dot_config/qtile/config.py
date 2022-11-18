from libqtile import bar, layout, widget
from libqtile.config import Group, Key, Screen  # ,Click ,Drag, Match
from libqtile.lazy import lazy

# Super key binding
mod = "mod4"  # Windows key :)

# Applications
terminal = "/usr/bin/alacritty"
browser = "/usr/bin/brave"

# Font collection
fonts = {
    "regular": "Hack Nerd Font",
    "bold": "Hack Nerd Font Bold",
    "italic": "Hack Nerd Font Italic",
    "mono": "Hack Nerd Font Mono",
}

# Color scheme
# Colors are defined by hex code
# Do not include the hashtag in the hex code
# Note:
# fg = foreground
# bg = background
colors = {
    "global_fg": "ffffff",
    "global_bg": "000000",
    "border_active": "295662",
    "border_inactive": "383838",
    "separator": "383838",
    "clock_fg": "aececf",
    "clock_bg": "152447",
    "netmon_fg": "c59d6c",
    "sysmon_fg": "f18b37",
    "batmon_fg": "b3a852",
    "volmon_fg": "ffffff",
    "volmon_bg": "363e37",
}

# Key bindings
keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Move window to the right",
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Launch applications
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "shift"], "Return", lazy.spawn(browser), desc="Launch Browser"),
]

# Groups
groups = [Group(i) for i in "123"]
for i in groups:
    keys.extend(
        [
            # mod + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

# Layouts
layouts = [
    layout.Tile(
        margin=10,
        border_focus=colors["border_active"],
        border_normal=colors["border_inactive"],
    ),
    layout.Max(),
]

# Screens and Widgets
widget_defaults = dict(
    font=fonts["regular"],
    fontsize=15,
    padding=10,
    foreground=colors["global_fg"],
    background=colors["global_bg"],
)
extension_defaults = widget_defaults.copy()
screens = [
    Screen(
        top=bar.Bar(
            widgets=[
                widget.GroupBox(
                    font=fonts["bold"],
                    highlight_method="line",
                    highlight_color=[
                        colors["global_bg"],
                        colors["border_active"],
                    ],
                    this_current_screen_border=colors["global_fg"],
                ),
                widget.CurrentLayoutIcon(
                    scale=0.8,
                ),
                widget.WindowName(),
                widget.Systray(),
                widget.Clock(
                    format="%d/%m/%y %H:%M",
                    font=fonts["bold"],
                    foreground=colors["clock_fg"],
                    background=colors["clock_bg"],
                ),
            ],
            size=25,
            background=colors["global_bg"],
            border_width=[0, 0, 2, 0],
            border_color=colors["border_active"],
        ),
        bottom=bar.Bar(
            widgets=[
                widget.Prompt(),
                widget.Spacer(),
                widget.Sep(
                    foreground=colors["separator"],
                ),
                widget.Net(
                    format="🖧 ↓{down}  ↑{up}",
                    foreground=colors["netmon_fg"],
                ),
                widget.Sep(
                    foreground=colors["separator"],
                ),
                widget.CPU(
                    format="CPU {load_percent}%",
                    update_interval=2.0,
                    foreground=colors["sysmon_fg"],
                ),
                widget.Memory(
                    format="RAM {MemUsed:.0f}/{MemTotal:.0f}{mm}",
                    update_interval=2.0,
                    foreground=colors["sysmon_fg"],
                ),
                widget.Sep(
                    foreground=colors["separator"],
                ),
                widget.Battery(
                    battery=0,
                    format="{percent:2.0%}",
                    foreground=colors["batmon_fg"],
                ),
                widget.BatteryIcon(
                    battery=0,
                ),
                widget.Battery(
                    battery=1,
                    format="{percent:2.0%}",
                    foreground=colors["batmon_fg"],
                ),
                widget.BatteryIcon(
                    battery=1,
                ),
                widget.Spacer(
                    length=20,
                ),
                widget.PulseVolume(
                    emoji=True,
                    foreground=colors["volmon_fg"],
                    background=colors["volmon_bg"],
                ),
            ],
            size=25,
            background=colors["global_bg"],
            border_width=[2, 0, 0, 0],
            border_color=colors["border_active"],
        ),
        wallpaper="~/.local/share/img/outerwilds.jpg",
        wallpaper_mode="stretch",
    ),
]

# Floating layouts settings
""" Disabled, as I do not use it...
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]
floating_layout = layout.Floating(
   float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
"""

# Other settings
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "Qtile"
