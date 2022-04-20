-------------------------------------------------
-- Battery Arc Widget for Awesome Window Manager
-- Shows the battery level of the laptop
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/batteryarc-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local batteryarc_widget = {}

local function worker()

    local size = 18

    local main_color = beautiful.fg_color
    local warning_msg_position = 'bottom_right'
    local warning_msg_icon = '/home/cd-r0m/.config/awesome/awesome-wm-widgets/batteryarc-widget/spaceman.jpg'

    batteryarc_widget = wibox.widget {
        {
            image = "/home/cd-r0m/.config/awesome/awesome-wm-widgets/batteryarc-widget/battery.png",
            resize = true,
            widget = wibox.widget.imagebox,
        },
        max_value = 100,
        rounded_edge = true,
        thickness = 2,
        start_angle = 4.71238898, -- 2pi*3/4
        forced_height = size,
        forced_width = size,
        bg = '#ffffff11',
        paddings = 2,
        widget = wibox.container.arcchart
    }

    local last_battery_check = os.time()

    --[[ Show warning notification ]]
    local function show_battery_warning()
        naughty.notify {
            icon = warning_msg_icon,
            icon_size = 100,
            text = 'Battery is dying',
            title = 'Houston, we have a problem',
            timeout = 25, -- show the warning for a longer time
            hover_timeout = 0.5,
            position = warning_msg_position,
            bg = "#F06060",
            fg = "#EEE9EF",
            width = 400,
        }
    end

    local function show_battery_warning_charging()
        naughty.notify {
            icon = warning_msg_icon,
            icon_size = 100,
            text = "Battery is charging",
            title = "Houston, we don't have problem",
            timeout = 25, -- show the warning for a longer time
            hover_timeout = 0.5,
            position = warning_msg_position,
            bg = "#448047",
            fg = "#EEE9EF",
            width = 400,
        }
    end

    local discharging = false
    local function update_widget(widget, stdout)
        local charge = 0
        local status
        for s in stdout:gmatch("[^\r\n]+") do
            local cur_status, charge_str, _ = string.match(s, '.+: (%a+), (%d?%d?%d)%%,?(.*)')
            if cur_status ~= nil and charge_str ~= nil then
                local cur_charge = tonumber(charge_str)
                if cur_charge > charge then
                    status = cur_status
                    charge = cur_charge
                end
            end
        end

        widget.value = charge

        if status == 'Charging' then
            main_color = '#43a047'
            if discharging then
                show_battery_warning_charging()
            end
            discharging = false
        elseif status == 'Discharging' then
            main_color = '#e53935'
            if not discharging then
                show_battery_warning()
            end
            discharging = true
        else
            main_color = beautiful.fg_color
            discharging = false
        end

        widget.colors = { main_color }

    end

    watch("acpi", 2, update_widget, batteryarc_widget)

    -- Popup with battery info
    local notification
    local function show_battery_status()
        awful.spawn.easy_async([[bash -c 'acpi']],
            function(stdout, _, _, _)
                naughty.destroy(notification)
                notification = naughty.notify {
                    text = stdout,
                    title = "Battery status",
                    timeout = 0,
                    position = "bottom_right"
                }
            end)
    end

    batteryarc_widget:connect_signal("mouse::enter", function() show_battery_status() end)
    batteryarc_widget:connect_signal("mouse::leave", function() naughty.destroy(notification) end)

    return batteryarc_widget

end

return setmetatable(batteryarc_widget, { __call = function(_, ...)
    return worker()
end })
