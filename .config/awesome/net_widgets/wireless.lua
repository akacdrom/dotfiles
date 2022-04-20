local wibox       = require("wibox")
local awful       = require("awful")
local beautiful   = require("beautiful")
local naughty     = require("naughty")
local gears       = require("gears")
local module_path = (...):match("(.+/)[^/]+$") or ""

local wireless = {}
local function worker(args)
    local args = args or {}

    widgets_table = {}
    local connected = false

    -- Settings
    local interface = "wlp2s0"
    local widget    = args.widget == nil and wibox.layout.fixed.horizontal() or args.widget == false and nil or args.widget

    local net_icon = wibox.widget.imagebox()
    local signal_level = 0
    local connection_lost = false
    local first_request = true
    local function show_wifi_connect()
        naughty.notify {
            icon = "/home/cd-r0m/.config/awesome/awesome-wm-widgets/batteryarc-widget/spaceman.jpg",
            icon_size = 100,
            text = "I'm feeling online :)",
            title = "Houston, we have a good new",
            timeout = 5, -- show the warning for a longer time
            hover_timeout = 1,
            position = "bottom_right",
            bg = "#448047",
            fg = "#EEE9EF",
            width = 400,
        }
    end

    local function show_wifi_lost()
        naughty.notify {
            icon = "/home/cd-r0m/.config/awesome/awesome-wm-widgets/batteryarc-widget/spaceman.jpg",
            icon_size = 100,
            text = "Wifi connection is lost :(",
            title = "Houston, we have a problem",
            timeout = 5, -- show the warning for a longer time
            hover_timeout = 1,
            position = "bottom_right",
            bg = "#F06060",
            fg = "#EEE9EF",
            width = 400,
        }
    end

    local signal_level = 0
    local function net_update()
        awful.spawn.easy_async("awk 'NR==3 {printf \"%3.0f\" ,($3/70)*100}' /proc/net/wireless", function(stdout)
            signal_level = tonumber(stdout)
        end)
        if signal_level == nil then
            if connection_lost then
                show_wifi_lost()
                connection_lost = false
            end
            connected = false
            net_icon:set_image("/home/cd-r0m/.config/awesome/net_widgets/icons/no-wifi.png")
        else
            if not connection_lost and not first_request then
                show_wifi_connect()
            end
            connected = true
            net_icon:set_image("/home/cd-r0m/.config/awesome/net_widgets/icons/wifi.png")
            connection_lost = true
            first_request = false
        end
    end

    net_update()
    gears.timer.start_new( 10, function () net_update() return true end )

    widgets_table["imagebox"] = net_icon
    if widget then
        widget:add(net_icon)
        -- Hide the text when we want to popup the signal instead
        wireless:attach(widget)
    end

    local function text_grabber()
        local msg = ""
        if connected then
            local mac     = "N/A"
            local essid   = "N/A"
            local bitrate = "N/A"
            local inet    = "N/A"

            -- Use iw/ip
            local f = io.popen("iw dev " .. interface .. " link")
            for line in f:lines() do
                -- Connected to 00:01:8e:11:45:ac (on wlp1s0)
                mac     = string.match(line, "Connected to ([0-f:]+)") or mac
                -- SSID: 00018E1145AC
                essid   = string.match(line, "SSID: (.+)") or essid
                -- tx bitrate: 36.0 MBit/s
                bitrate = string.match(line, "tx bitrate: (.+/s)") or bitrate
            end
            f:close()

            f = io.popen("ip addr show " .. interface)
            for line in f:lines() do
                inet = string.match(line, "inet (%d+%.%d+%.%d+%.%d+)") or inet
            end
            f:close()

            msg = "<span font_desc=\"JetbrainsMono ExtraBold Nerd Font 9\">" ..
                "┌[" .. interface .. "]\n" ..
                "├ESSID:\t\t" .. essid .. "\n" ..
                "├IP:\t\t" .. inet .. "\n" ..
                "├BSSID\t\t" .. mac .. "\n" ..
                "└Bit rate:\t" .. bitrate .. "</span>"
        else
            msg = "Wireless network is disconnected"
        end

        return msg
    end

    local notification = nil
    function wireless:hide()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    function wireless:show()
        wireless:hide()
        notification = naughty.notify({
            text = text_grabber(),
            timeout = 0,
            position = "bottom_right"
        })
    end

    return widget or widgets_table
end

function wireless:attach(widget)
    widget:connect_signal('mouse::enter', function() wireless:show() end)
    widget:connect_signal('mouse::leave', function() wireless:hide() end)
    return widget
end

return setmetatable(wireless, { __call = function(_, ...) return worker(...) end })
