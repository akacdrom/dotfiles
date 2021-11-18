-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")
beautiful.init("/home/cd-r0m/.config/awesome/mytheme.lua")

-- Error handling --
require("error_handling")

-- Default editor and terminal
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Layouts
require("layouts")

-- Wibar
require("bar")

-- Keybindings
require("keys")

-- Set keys
root.keys(globalkeys)

-- Rules
require("rules")

-- Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Border Colors
client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- Remove borders when it's only one window or maximized
screen.connect_signal("arrange", function (s)
    local only_one_any = #s.clients == 1
    for _, c in pairs(s.clients) do
        if (c.maximized ) then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

