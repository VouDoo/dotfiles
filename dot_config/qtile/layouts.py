from libqtile import layout
import theme

config = [
    layout.Tile(
        margin=10,
        border_focus=theme.border_active,
        border_normal=theme.border_inactive,
    ),
    layout.Max(),
]
