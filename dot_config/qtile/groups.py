from libqtile.lazy import lazy
from libqtile.config import Group, Key

from keys import mod

config = [Group(i) for i in "123"]
extra_keys = []
for group in config:
    extra_keys.extend(
        [
            # mod + letter of group = switch to group
            Key(
                [mod],
                group.name,
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            # mod + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                group.name,
                lazy.window.togroup(group.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
        ]
    )
