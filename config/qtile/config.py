from typing import List  # noqa: F401

import os
import subprocess
from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook

mod = "mod4"
terminal = "alacritty"

keys = [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.group.next_window(),
        desc="Move window focus to other window"),
    Key([mod,"shift"], "Tab", lazy.group.prev_window(),
        desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle Groups
    Key([mod], "Right", lazy.screen.next_group(), desc="Right group"),
    Key([mod], "Left", lazy.screen.prev_group(), desc="Left Group"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),

    # Toggle between different layouts as defined below
    Key([mod], "s", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "m", lazy.window.toggle_maximize(), desc="Toggle maximaxed"),
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "space", lazy.prev_layout(), desc="Toggle previous layouts"),
    Key([mod], "p", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # Personal keys
    Key([mod], "w", lazy.spawn("alacritty"), desc="Launch terminal"),
    Key([mod], "e", lazy.spawn("pcmanfm"), desc="Launch pcmanfm"),
    Key([mod], "q", lazy.spawn("rofi -show combi"), desc="Launch rofi"),
    Key([mod, "shift"], "Up", lazy.spawn("bash /home/cd-r0m/.scripts/vol-not.sh up"), desc="Launch rofi"),
    Key([mod, "shift"], "Down", lazy.spawn("bash /home/cd-r0m/.scripts/vol-not.sh down"), desc="Launch rofi"),
    Key([mod, "shift"], "Right", lazy.spawn("bash /home/cd-r0m/.scripts/mic-not.sh up"), desc="Launch rofi"),
    Key([mod, "shift"], "Left", lazy.spawn("bash /home/cd-r0m/.scripts/mic-not.sh down"), desc="Launch rofi"),
    Key([],   "Print", lazy.spawn("bash /home/cd-r0m/.scripts/screenshot-full.sh"), desc="Launch rofi"),
    Key([mod],"Print", lazy.spawn("bash /home/cd-r0m/.scripts/screenshot-select.sh"), desc="Launch rofi"),
    Key([mod], "v", lazy.spawn("bash /home/cd-r0m/.scripts/green-clip.sh"), desc="Launch rofi"),
    Key([],   "XF86MonBrightnessUp", lazy.spawn("bash /home/cd-r0m/.scripts/brightness-not.sh up"), desc="Launch rofi"),
    Key([],   "XF86MonBrightnessDown", lazy.spawn("bash /home/cd-r0m/.scripts/brightness-not.sh down"), desc="Launch rofi"),

]

groups = [Group(i) for i in "12345"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

layouts = [
    layout.Columns(
        border_focus = '#8f1fff',
        border_normal = '#000000',
        border_width = 1,
        margin = 3,
        margin_on_single = 0
        ),
    layout.Floating(
        border_focus = '#8f1fff',
        border_normal = '#000000',
        border_width = 1,
        ),
    layout.Max()
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='JetbrainsMonoExtraBold Nerd Font',
    fontsize=12,
    padding=0,
    background = '000000',
    foreground = 'e8e8e8'
)
extension_defaults = widget_defaults.copy()


screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.TextBox(
					text=" ",
					padding = 0,
				),
                widget.TextBox(
					text="",
					foreground='#0f0f1f',
					fontsize=17,
					padding=0,
				),
                widget.GroupBox(
                    borderwidth = 3,
                    inactive = '#333333',
                    disable_drag = True,
                    highlight_method = 'line',
                    highlight_color = '#0f0f1f',
                    this_current_screen_border = '#ff2b4d',
                    background = '#0f0f1f',
                    margin = 0,
                    padding = 0,
                    margin_y = 5,
                    padding_x = 5,
                    visible_groups = '[1,2,3,4,5]'
                    ),
                widget.TextBox(
					text="",
					foreground='#0f0f1f',
					fontsize=17,
					padding=0,
				),
                widget.TextBox(
					text=" ",
					padding=0,
				),
                widget.TaskList(
                    fontsize = 12,
                    foreground = '#f55f16',
                    margin = 0,
                    padding = 0,
                    margin_y= 0,
                    margin_x = 0,
                    padding_x = 20,
                    padding_y = 3, 
                    borderwidth = 0,
                    icon_size = 0,
                    highlight_method = 'block',
                    title_width_method = 'uniform',
                    border = '#000000',
                    unfocused_border = '#0f0f1f',
                    spacing = 8,
                    rounded = False,
                    txt_floating = '🗗 ',
                    txt_maximized = '🗖 ',
                    txt_minimized = '🗕 ',
                ),
                widget.Systray(
                    icon_size = 14,
                    padding = 5,
                ),
                widget.TextBox(
					text=" ",
					padding = 0,
				),
                widget.TextBox(
					text="",
					foreground='#0f0f1f',
					fontsize=17,
					padding=0,
				),
                widget.Clock(
                    format='  %H:%M ',
                    background = '#0f0f1f'
                ),
                widget.CurrentLayoutIcon(
					custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                    scale = 0.75,
                    background = '#0f0f1f',
                    ),
                widget.TextBox(
					text="",
					foreground='#0f0f1f',
					fontsize=17,
					padding=0,
				),
                widget.TextBox(
					text=" ",
					padding = 0,
				),
            ],
            20,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])
