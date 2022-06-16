---------------------------
-- Default awesome theme --
---------------------------
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local ruled = require("ruled")
local gears = require("gears")
local naughty = require("naughty")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font = "Jetbrains Mono Extra Bold Nerd Font 9"

theme.bg_normal   = "#0F0E17"
theme.bg_focus    = "#1E1C2E"
theme.bg_urgent   = "#ff0000"
theme.bg_minimize = "#000000"
theme.bg_systray  = "#000000"

local empty = "#333333"
theme.wibar_bg = "#000000"

theme.fg_normal   = "#aaaaaa"
theme.fg_focus    = "#ffffff"
theme.fg_urgent   = "#ffffff"
theme.fg_minimize = "#3d1414"

theme.useless_gap   = dpi(1)
theme.border_width  = dpi(0)
theme.border_normal = "#000000"
theme.border_focus  = "#483bad"
theme.border_marked = "#91231c"

--theme.tasklist_bg_focus = "#26243B"
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_disable_icon = false
theme.tasklist_disable_task_name = false
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_font = "noto display medium 9"

theme.taglist_spacing = 0
theme.taglist_fg_occupied = theme.fg_focus
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_fg_urgent = theme.fg_focus
theme.taglist_fg_empty = empty

theme.systray_icon_spacing = 5

local empty = "#333333"

-- Generate taglist squares:
local taglist_square_size = dpi(5)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- wallpaper
theme.wallpaper = "/home/cd-r0m/Pictures/wallpapers/city.jpg"

-- flash focus
theme.flash_focus_start_opacity = 0.7 -- the starting opacity
theme.flash_focus_step = 0.01 -- the step of animation

-- window switcher
theme.window_switcher_widget_bg = theme.bg_normal -- The bg color of the widget
theme.window_switcher_widget_border_width = 0 -- The border width of the widget
theme.window_switcher_widget_border_radius = 10 -- The border radius of the widget
theme.window_switcher_clients_spacing = 10 -- The space between each client item
theme.window_switcher_client_icon_horizontal_spacing = 5 -- The space between client icon and text
theme.window_switcher_client_width = 250 -- The width of one client widget
theme.window_switcher_client_height = 350 -- The height of one client widget
theme.window_switcher_client_margins = 10 -- The margin between the content and the border of the widget
theme.window_switcher_thumbnail_margins = 10 -- The margin between one client thumbnail and the rest of the widget
theme.thumbnail_scale = false -- If set to true, the thumbnails fit policy will be set to "fit" instead of "auto"
theme.window_switcher_name_margins = 10 -- The margin of one clients title to the rest of the widget
theme.window_switcher_name_valign = "center" -- How to vertically align one clients title
theme.window_switcher_name_forced_width = 200 -- The width of one title
theme.window_switcher_name_font = "noto medium 9" -- The font of all titles
theme.window_switcher_name_normal_color = empty -- The color of one title if the client is unfocused
theme.window_switcher_name_focus_color = theme.fg_focus -- The color of one title if the client is focused
theme.window_switcher_icon_valign = "center" -- How to vertically align the one icon
theme.window_switcher_icon_width = 40 -- The width of one icon

-- task preview
theme.task_preview_widget_border_radius = 20 -- Border radius of the widget (With AA)
theme.task_preview_widget_bg = theme.bg_normal -- The bg color of the widget
theme.task_preview_widget_border_width = 0 -- The border width of the widget
theme.task_preview_widget_margin = 10 -- The margin of the widget

--tag preview
theme.tag_preview_widget_border_radius = 10 -- Border radius of the widget (With AA)
theme.tag_preview_client_border_radius = 10 -- Border radius of each client in the widget (With AA)
theme.tag_preview_client_opacity       = 1 -- Opacity of each client
theme.tag_preview_client_bg            = theme.bg_focus -- The bg color of each client
theme.tag_preview_client_border_width  = 0 -- The border width of each client
theme.tag_preview_widget_bg            = theme.bg_normal -- The bg color of the widget
theme.tag_preview_widget_border_color  = theme.bg_normal -- The border color of the widget
theme.tag_preview_widget_border_width  = 10 -- The border width of the widget
theme.tag_preview_widget_margin        = 20 -- The margin of the widget

-- You can use your own layout icons like this:
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_max      = themes_path .. "default/layouts/maxw.png"
theme.layout_tile     = themes_path .. "default/layouts/tilew.png"

theme.gap_single_client     = false
theme.maximized_hide_border = true


-- {{{ Notifications
ruled.notification.connect_signal('request::rules', function()
    ruled.notification.append_rule {
        rule       = {},
        properties = {
            --position         = "bottom_right",
            margin           = dpi(16),
            max_width        = dpi(600),
            border_width     = 0,
            --icon_size        = dpi(100),
            implicit_timeout = 0
        }
    }
    ruled.notification.append_rule {
        rule       = { urgency = 'low' },
        properties = {
            bg = theme.bg_normal,
            fg = theme.fg_focus
        }
    }
    ruled.notification.append_rule {
        rule       = { urgency = 'normal' },
        properties = {
            bg = theme.bg_normal,
            fg = theme.fg_focus
        }
    }
    ruled.notification.append_rule {
        rule       = { urgency = 'critical' },
        properties = {
            bg = theme.bg_urgent,
            fg = theme.bg_focus
        }
    }
end)
naughty.config.padding = dpi(15)
naughty.config.spacing = dpi(5)
theme.notification_font = "Jetbrains Mono Extra Bold Nerd Font 10"
theme.notification_icon_size = dpi(100)
theme.notification_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 20)
end
-- naughty.connect_signal("request::display", function(n)
--     naughty.layout.box {
--         notification = n,
--     }
-- end)

-- }}}
return theme
