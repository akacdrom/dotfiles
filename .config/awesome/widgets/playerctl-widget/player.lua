local awful = require("awful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require('beautiful')
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local bling = require("bling")

local player_widget = {}
local default_art = "/home/cd-r0m/.config/awesome/themes/default/icons/video.png";

local function worker()
    local playerctl = bling.signal.playerctl.lib()

    player_widget.widget = wibox.widget {
        --image = "/home/cd-r0m/.config/awesome/themes/default/icons/player.png",
        text = " |",
        widget = wibox.widget.textbox,
    }

    -- Get Song Info
    local t = "";
    local a = "";
    local art = default_art;
    local p_n = "";
    local al = "";

    playerctl:connect_signal("metadata",
        function(_, title, artist, album_path, album, new, player_name)
            -- Set art widget
            art = gears.surface.load_uncached(album_path)
            -- Set player name, title and artist widgets
            p_n = player_name
            t = title
            a = artist
            al = " • " .. album
        end)

    local notification = nil
    function player_widget:hide()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    function player_widget:show()
        player_widget:hide()

        if p_n == "" or p_n == "chromium" then
            art = default_art;
        end

        notification = naughty.notify({
            icon_size = dpi(150),
            title     = "[" .. p_n .. "]" .. "\n\n" .. t .. al .. "\n\n" .. "[" .. a .. "]",
            icon      = art,
            font      = "Jetbrains Mono Extra Bold Nerd Font 10",
            position  = "bottom_right"
        })
    end

    function player_widget:toggle()
        spawn('playerctl play-pause')
    end

    player_widget.widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function() player_widget:toggle() end)
        )
    )
    player_widget:attach()
    return player_widget.widget
end

function player_widget:attach()
    player_widget.widget:connect_signal('mouse::enter', function() player_widget:show() end)
    player_widget.widget:connect_signal('mouse::leave', function() player_widget:hide() end)
    return player_widget.widget
end

return setmetatable(player_widget, { __call = function(_, ...) return worker() end })
