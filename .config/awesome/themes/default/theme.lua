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

theme.font = "Jetbrains Mono Extra Bold Nerd Font 11"

theme.bg_normal   = "#1e2030"
theme.bg_focus    = "#2e3359"
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
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = "#353969"
theme.border_marked = "#91231c"

--theme.tasklist_bg_focus = "#26243B"
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_bg_normal = theme.bg_normal
theme.tasklist_disable_icon = false
theme.tasklist_disable_task_name = false
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_fg_normal = theme.fg_normal
theme.tasklist_font = "noto display medium 11"

theme.taglist_spacing = 0
theme.taglist_fg_occupied = theme.fg_focus
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_fg_urgent = theme.fg_focus

theme.systray_icon_spacing = 5

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
            bg = "#0F0E17",
            fg = theme.fg_focus
        }
    }
    ruled.notification.append_rule {
        rule       = { urgency = 'normal' },
        properties = {
            bg = "#0F0E17",
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
theme.notification_font = "Jetbrains Mono Extra Bold Nerd Font 11"
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
