import keys as _keys
import layouts as _layouts
import screens as _screens
import groups as _groups

groups = _groups.config
layouts = _layouts.config
screens = _screens.config
keys = _keys.config
keys.extend(_groups.extra_keys)

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
