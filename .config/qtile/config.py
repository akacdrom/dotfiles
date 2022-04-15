from typing import List  # noqa: F401

import os
from libqtile import bar, layout, widget, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "alacritty"

keys = [
    # Switch between windows
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Tab", lazy.group.next_window(), desc="Move window focus to other window"),
    Key([mod,"shift"], "Tab", lazy.group.prev_window(), desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle Groups
    Key([mod], "a", lazy.screen.prev_group(), desc="Left Group"),
    Key([mod], "d", lazy.screen.next_group(), desc="Right group"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),

    # Toggle between different layouts as defined below
    Key([mod], "s", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    #Key([mod], "m", lazy.window.toggle_maximize(), desc="Toggle maximaxed"),
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "space", lazy.prev_layout(), desc="Toggle previous layouts"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "shift"], "o", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "control"], "p", lazy.shutdown(), desc="Shutdown Qtile"),

    # Personal keys
    Key([mod], "Return", lazy.spawn("alacritty"), desc="Launch terminal"),
    Key([mod], "e", lazy.spawn("pcmanfm"), desc="Launch pcmanfm"),
    Key([mod], "q", lazy.spawn("rofi -show combi"), desc="Launch rofi"),
    Key([mod], "F12", lazy.spawn("bash /home/cd-r0m/.scripts/vol-not.sh up"), desc="Audio inc"),
    Key([mod], "F11", lazy.spawn("bash /home/cd-r0m/.scripts/vol-not.sh down"), desc="Audio desc"),
    Key([mod], "F10", lazy.spawn("pamixer -m"), desc="Take audio mute"),
    #Key([mod, "shift"], "F12", lazy.spawn("bash /home/cd-r0m/.scripts/mic-not.sh up"), desc="Launch rofi"),
    #Key([mod, "shift"], "F11", lazy.spawn("bash /home/cd-r0m/.scripts/mic-not.sh down"), desc="Launch rofi"),
    Key([],   "Print", lazy.spawn("bash /home/cd-r0m/.scripts/screenshot-full.sh"), desc="Screenshot fullscreen"),
    Key([mod],"Print", lazy.spawn("bash /home/cd-r0m/.scripts/screenshot-select.sh"), desc="Screenshot selected area"),
    Key([mod], "v", lazy.spawn("bash /home/cd-r0m/.scripts/green-clip.sh"), desc="Greenclip clipboard"),
    Key([mod], "F6" , lazy.spawn("bash /home/cd-r0m/.scripts/brightness-not.sh up"), desc="Brightness inc"),
    Key([mod], "F5", lazy.spawn("bash /home/cd-r0m/.scripts/brightness-not.sh down"), desc="Brightness desc"),
]

groups = [Group(i) for i in "12345678"]

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
#groups.extend([
    #        Group('1', spawn='google-chrome-stable', persist=True, matches=[Match(wm_class=['google-chrome'])]),
    #   ])

layout_theme = {"border_width": 1,
                "margin": 1,
                "border_focus": '#8f1fff',
                "border_normal": '#000000',
                "margin_on_single": 0
                }

layouts = [
    #layout.Bsp(border_focus = '#8f1fff',border_normal = '#333333', border_width = 2, margin = 0),
    #layout.Stack(num_stacks=2),
    layout.Columns(**layout_theme),
    layout.Floating(**layout_theme),
    layout.Max()
]

widget_defaults = dict(
    font='JetbrainsMonoExtraBold Nerd Font',
    fontsize=12,
    padding=0,
    background = '000000',
    foreground = 'bdbdbd'
)
extension_defaults = widget_defaults.copy()


screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.TextBox(
                    text = "",
                    padding = 13,
                    fontsize = 17,
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("rofi -show combi ")},
                    ),
                widget.TextBox(
                    text = " |",
                    fontsize = 10,
                    foreground = '#adadad', 
                    ),
                widget.GroupBox(
                    borderwidth = 3,
                    inactive = '#333333',
                    highlight_method = 'line',
                    highlight_color = '#000000',
                    this_current_screen_border = '#e8e8e8',
                    margin_y = 5,
                    padding_x = 5,
                    visible_groups = '[1,2,3,4,5,6,7,8]',
                    disable_drag = True,
                    ),
                widget.TextBox(
                    text = "|",
                    fontsize=10
                    ),
                widget.TaskList(
                    fontsize = 12,
                    foreground = "#777777",
                    focused_background= "#ffffff",
                    border = '#000000',
                    unfocused_border = '#0f0f1f',
                    highlight_method = 'block',
                    #title_width_method = 'uniform',
                    markup_focused = '<span foreground="#ffffff">{}</span>' ,
                    spacing = 0,
                    margin = 0,
                    padding_y = 3, 
                    padding_x = 15, 
                    borderwidth = 6,
                    icon_size = 0,
                    txt_floating = '🗗 ',
                    txt_maximized = '🗖 ',
                    txt_minimized = '🗕 ',
                ),
                widget.TextBox(
                    text = " | ",
                    fontsize = 10,
                    foreground = '#adadad', 
                    ),
                widget.TextBox(
                    text = " ",
                    fontsize = 12,
                    mouse_callbacks = {'Button1': lazy.spawn("/home/cd-r0m/.scripts/previous-notify.sh")},
                    ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.CheckUpdates(
                    custom_command = "checkupdates",
                    display_format = " {updates}",
                    no_update_string = " ",
                    execute = "alacritty --hold -t 'UPDATE MANAGER' -e paru --noconfirm --needed -Syu",
                    colour_have_updates = "#bdbdbd",
                    colour_no_updates = "#bdbdbd"

                    ),
                widget.Battery(
                    format = '|[{char} {percent:2.0%}]',
                    charge_char = '',
                    discharge_char = '',
                    full_char = '',
                    show_short_text = False,
                    hide_threshold = .99,
                    foreground = '#ff2b4d',
                    ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.Backlight(
                        fmt = ' {}',
                        backlight_name = "intel_backlight",
                        change_command = "brightnessctl s 10+%"
                        ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.TextBox(
                    text = "墳 ",
                    fontsize = 15,
                    mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn("pavucontrol")},
                    ),
                widget.Volume(
                    update_interval=0.5,
                    get_volume_command ="/home/cd-r0m/.config/qtile/scripts/volume.sh",
                    volume_up_command="pactl set-sink-volume @DEFAULT_SINK@ +5%",
                    volume_down_command="pactl set-sink-volume @DEFAULT_SINK@ -5%",
                    ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.TextBox(
                    text = " ",
                    fontsize = 14
                    ),
                widget.Memory(
                    format = '{MemUsed:.1f}{mm}',
                    mouse_callbacks = {'Button1': lazy.spawn("alacritty --hold -t 'TASK MANAGER' -e bpytop")},
                    measure_mem = 'G'
                        ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.CPU(
                    format = ' {load_percent}%',
                    mouse_callbacks = {'Button1': lazy.spawn("alacritty --hold -t 'TASK MANAGER' -e bpytop")},
                    ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.Wlan(
                    interface="wlp2s0",
                    format=" ",
                    disconnected_message="[OFFLINE]",
                    mouse_callbacks = {'Button1': lazy.spawn("/home/cd-r0m/.scripts/rofi-wifi-menu.sh")},
                    fontsize = 13
                    ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.Bluetooth(
                    fmt = ' {}',
                    hci = "/dev_60_AA_EF_5B_6D_BC",
                    mouse_callbacks = {'Button1': lazy.spawn("/home/cd-r0m/.scripts/rofi-bluetooth.sh")}
                    ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.TextBox(
                    text = " ",
                    mouse_callbacks = {'Button1': lazy.spawn("alacritty --hold -t '📅 GOOGLE CALENDAR' -e gcalcli calm")},
                    fontsize = 15
                    ),
                widget.Clock(
                    format='%d-%a-%b',
                    mouse_callbacks = {'Button1': lazy.spawn("alacritty --hold -t '📅 GOOGLE CALENDAR' -e gcalcli calm")},
                ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.TextBox(
                    text = " ",
                    mouse_callbacks = {'Button1': lazy.spawn("gsimplecal")},
                    fontsize = 14
                    ),
                widget.Clock(
                    format='%H:%M',
                    mouse_callbacks = {'Button1': lazy.spawn("gsimplecal")},
                    fontsize = 13,
                ),
                widget.TextBox(
                    text = "|",
                    foreground = "#ffffff",
                    fontsize=13
                    ),
                widget.CurrentLayoutIcon(
					custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                    scale = 0.75,
                    ),
                widget.Systray(
                    icon_size = 20,
                    padding = 1,
                    margin = 10,
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
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(**layout_theme ,float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(wm_class="feh"),
    Match(wm_class='xarchiver'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry

])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.

wmname = "LG3D"
