---------------------------
-- Default awesome theme --
---------------------------

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

theme.font          = "Ubuntu Mono Nerd Font Bold 10"

theme.bg_normal     = "#000000"
theme.bg_focus      = "#e8e8e8"
theme.bg_urgent     = "#bd2c40"
theme.bg_minimize   = "#000000"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#e8e8e8"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#333"

theme.useless_gap   = dpi(3)
theme.border_width  = dpi(1)
theme.border_normal = "#000000"
theme.border_focus  = "#8f1fff"
theme.border_marked = "#91231c"


theme.taglist_bg_focus = "#c2372b"
theme.taglist_fg_focus = "#ffffff"
theme.taglist_fg_occupied = "#e8e8e8"
theme.taglist_bg_urgent = theme.bg_urgent
theme.taglist_fg_urgent = "#ffffff"
theme.taglist_fg_empty = "#333"

theme.tasklist_fg_focus = "#f55f16"
theme.tasklist_bg_focus = "#000000"
theme.tasklist_bg_normal = "#15152b"
theme.tasklist_fg_normal = "#e8e8e8"
theme.tasklist_disable_icon = true


theme.systray_icon_spacing = 5

-- You can use your own layout icons like this:
theme.layout_floating  = "/home/cd-r0m/.config/awesome/floatingw.png"
theme.layout_max = "/home/cd-r0m/.config/awesome/layout-max.png"
theme.layout_tile = "/home/cd-r0m/.config/awesome/tilew.png"


return theme

