local wibox = require("wibox")
local watch = require("awful.widget.watch")
local naughty = require("naughty")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wireless_widget = {}

local function worker()
    local connected      = false
    local interface      = "wlan0"
    local icon           = "/home/cd-r0m/.config/awesome/widgets/wireless-widget/wifi.png"
    local no_wifi_icon   = "/home/cd-r0m/.config/awesome/widgets/wireless-widget/no-wifi.png"
    local get_signal_cmd = "awk 'NR==3 {printf \"%.0f\" ,($3/70)*100}' /proc/net/wireless"

    wireless_widget.widget = wibox.widget {
        {
            {
                image = "/home/cd-r0m/.config/awesome/widgets/wireless-widget/icons/wifi.svg",
                resize = true,
                widget = wibox.widget.imagebox,
            },
            valign = 'center',
            layout = wibox.container.place
        },
        max_value = 100,
        thickness = 2,
        start_angle = 4.71238898, -- 2pi*3/4
        forced_height = 18,
        forced_width = 18,
        bg = '#ffffff11',
        paddings = 2,
        widget = wibox.container.arcchart,
        set_value = function(self, level)
            self:set_value(level)
        end
    }

    local function show_wifi_connect()
        naughty.notify {
            icon = icon,
            text = "I'm feeling online :)",
            title = "Houston, we have a good new",
            timeout = 5, -- show the warning for a longer time
            hover_timeout = 1,
            position = "bottom_right"
        }
    end

    local function show_wifi_lost()
        naughty.notify {
            icon = no_wifi_icon,
            text = "Wifi connection is lost :(",
            title = "Houston, we have a problem",
            timeout = 5, -- show the warning for a longer time
            hover_timeout = 1,
            position = "bottom_right",
        }
    end

    local connection_lost = false
    local first_request = true
    local signal_level = 0
    local update_widget = function(widget, stdout, _, _, _)
        collectgarbage("collect")
        signal_level = tonumber(stdout)
        if signal_level == nil then
            connected = false
            if connection_lost then
                show_wifi_lost()
                connection_lost = false
            end
            widget:set_value(100)
            widget.colors = { "#ff0000" }
        else
            if not connection_lost and not first_request then
                show_wifi_connect()
            end
            connected = true
            widget:set_value(signal_level)
            connection_lost = true
            first_request = false
            widget.colors = { beautiful.fg_color }
        end
    end

    function net_stats(card, which)
        local prefix = {
            [0] = "",
            [1] = "K",
            [2] = "M",
            [3] = "G",
            [4] = "T"
        }

        local function readAll(file)
            local f = assert(io.open(file, "rb"))
            local content = f:read()
            f:close()
            return content
        end

        local function round(num, numDecimalPlaces)
            local mult = 10 ^ (numDecimalPlaces or 0)
            return math.floor(num * mult + 0.5) / mult
        end

        if (which == "d") then
            f = readAll("/sys/class/net/" .. card .. "/statistics/rx_bytes")
        else if (which == "u") then
                f = readAll("/sys/class/net/" .. card .. "/statistics/tx_bytes")
            end
        end

        local count = 0
        local stat = tonumber(f)
        while (stat > 1024) do
            stat = (stat / 1024)
            count = count + 1
        end

        local result = (round(stat, 2) .. " " .. prefix[count] .. "B")
        return result
    end

    local notify_icon
    local function text_grabber()
        local msg = ""
        if connected then
            local mac     = "N/A"
            local essid   = "N/A"
            local bitrate = "N/A"
            local inet    = "N/A"

            -- Use iw/ip
            f = io.popen("iw dev " .. interface .. " link")
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

            local signal       = "├Strength\t" .. signal_level .. "\n"
            local tdown        = net_stats(interface, "d")
            local tup          = net_stats(interface, "u")
            local metrics_down = "├DOWN:\t\t" .. tdown .. "\n"
            local metrics_up   = "├UP:\t\t" .. tup .. "\n"


            msg         = "┌[" .. interface .. "]\n" ..
                "├ESSID:\t\t" .. essid .. "\n" ..
                "├IP:\t\t" .. inet .. "\n" ..
                "├BSSID\t\t" .. mac .. "\n" ..
                "" .. metrics_down ..
                "" .. metrics_up ..
                "" .. signal ..
                "└Bit rate:\t" .. bitrate
            notify_icon = icon
        else
            notify_icon = no_wifi_icon
            msg = "Wireless network is disconnected"
        end

        return msg
    end

    local notification = nil
    function wireless_widget:hide()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    function wireless_widget:show()
        wireless_widget:hide()

        notification = naughty.notify({
            icon_size = dpi(150),
            title     = text_grabber(),
            icon      = notify_icon,
            font      = "Jetbrains Mono Extra Bold Nerd Font 11",
            position  = "bottom_right",
        })
    end

    wireless_widget:attach()
    watch(get_signal_cmd, 5, update_widget, wireless_widget.widget)
    return wireless_widget.widget
end

function wireless_widget:attach()
    wireless_widget.widget:connect_signal('mouse::enter', function() wireless_widget:show() end)
    wireless_widget.widget:connect_signal('mouse::leave', function() wireless_widget:hide() end)
    return wireless_widget.widget
end

return setmetatable(wireless_widget, { __call = function(_, ...) return worker() end })
