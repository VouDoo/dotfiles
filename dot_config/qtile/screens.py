from libqtile import bar, widget
from libqtile.config import Screen

import fonts
import theme

widget_defaults = dict(
    font=fonts.regular,
    fontsize=15,
    padding=10,
    foreground=theme.foreground,
    background=theme.background,
)

extension_defaults = widget_defaults.copy()

config = [
    Screen(
        top=bar.Bar(
            widgets=[
                widget.GroupBox(
                    font=fonts.bold,
                    highlight_method="line",
                    highlight_color=[
                        theme.background,
                        theme.border_active,
                    ],
                    this_current_screen_border=theme.foreground,
                ),
                widget.CurrentLayoutIcon(
                    scale=0.8,
                ),
                widget.WindowName(),
                widget.Clock(
                    format="%d/%m/%y %H:%M",
                    font=fonts.bold,
                    foreground=theme.clock_foreground,
                    background=theme.clock_background,
                ),
            ],
            size=25,
            background=theme.background,
            border_width=[0, 0, 2, 0],
            border_color=theme.border_active,
        ),
        bottom=bar.Bar(
            widgets=[
                widget.Prompt(),
                widget.Spacer(),
                widget.Systray(),
                widget.Sep(
                    foreground=theme.separator,
                ),
            widget.Net(
                format="🖧 ↓{down}  ↑{up}",
                foreground=theme.network_monitor,
            ),
            widget.Sep(
                foreground=theme.separator,
            ),
            widget.CPU(
                format="CPU {load_percent}%",
                    update_interval=2.0,
                    foreground=theme.system_monitor,
                ),
                widget.Memory(
                    format="RAM {MemUsed:.0f}/{MemTotal:.0f}{mm}",
                    update_interval=2.0,
                    foreground=theme.system_monitor,
                ),
                widget.Sep(
                    foreground=theme.separator,
                ),
                widget.Battery(
                    battery=0,
                    format="{percent:2.0%}",
                    foreground=theme.battery_ok,
                    low_foreground=theme.battery_low,
                    low_percentage=0.2,
                ),
                widget.BatteryIcon(
                    battery=0,
                ),
                widget.Battery(
                    battery=1,
                    format="{percent:2.0%}",
                    foreground=theme.battery_ok,
                    low_foreground=theme.battery_low,
                    low_percentage=0.2,
                ),
                widget.BatteryIcon(
                    battery=1,
                ),
                widget.Spacer(
                    length=20,
                ),
                widget.Volume(
                    fmt="Vol: {}",
                    foreground=theme.volume_foreground,
                    background=theme.volume_background,
                ),
            ],
            size=25,
            background=theme.background,
            border_width=[2, 0, 0, 0],
            border_color=theme.border_active,
        ),
        wallpaper="~/.local/share/img/outerwilds.jpg",
        wallpaper_mode="stretch",
    ),
]
