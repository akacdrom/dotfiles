local beautiful = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local batteryarc_widget = {}

local function worker()

    local size = 18

    local main_color = beautiful.fg_color
    local warning_msg_position = 'bottom_right'
    local charge_icon = '/home/cd-r0m/.config/awesome/themes/default/icons/battery.png'
    local disc_icon = '/home/cd-r0m/.config/awesome/themes/default/icons/battery-disc.png'
    local acpi = "acpi -b"

    batteryarc_widget.widget = wibox.widget {
        {
            image = "/home/cd-r0m/.config/awesome/widgets/batteryarc-widget/battery.png",
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

    local function show_battery_warning()
        naughty.notify {
            icon = disc_icon,
            icon_size = 100,
            text = 'Battery is dying',
            title = 'Houston, we have a problem',
            timeout = 25, -- show the warning for a longer time
            hover_timeout = 0.5,
            position = warning_msg_position,
            urgency = "critical"
        }
    end

    local function show_battery_warning_charging()
        naughty.notify {
            icon = charge_icon,
            icon_size = 100,
            text = "Battery is charging",
            title = "Houston, we don't have problem",
            timeout = 25, -- show the warning for a longer time
            hover_timeout = 0.5,
            position = warning_msg_position
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

    local function getBattInfo()
        f = io.popen("acpi | awk 'NR==1 {print $7}' | xargs")
        local unknown = f:read("l")
        local line
        if unknown == "unavailable" then
            line = "NR==2"
        else
            line = "NR==1"
        end

        f = io.popen("acpi -b | awk '" .. line .. " {print $3}'| tr -d ','")
        local status = "┌[Battery]\n├Status:\t" .. f:read("a")
        f = io.popen("acpi -b | awk '" .. line .. " {print $4}' | tr -d ','")
        local level = "├Level:\t\t" .. f:read("a")
        f = io.popen("acpi -b | awk '" .. line .. " {print $5,$6,$7}' | xargs")
        local time = "└Time:\t\t" .. f:read("a")

        return status .. level .. time
    end

    local notification = nil
    function batteryarc_widget:hide()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    function batteryarc_widget:show()
        batteryarc_widget:hide()
        notification = naughty.notify({
            icon_size = dpi(150),
            title     = getBattInfo(),
            icon      = "/home/cd-r0m/.config/awesome/themes/default/icons/battery.png",
            font      = "Jetbrains Mono Extra Bold Nerd Font 11"
        })
    end

    batteryarc_widget:attach()
    watch(acpi, 10, update_widget, batteryarc_widget.widget)
    return batteryarc_widget.widget

end

function batteryarc_widget:attach()
    batteryarc_widget.widget:connect_signal('mouse::enter', function() batteryarc_widget:show() end)
    batteryarc_widget.widget:connect_signal('mouse::leave', function() batteryarc_widget:hide() end)
    return batteryarc_widget.widget
end

return setmetatable(batteryarc_widget, { __call = function(_, ...) return worker() end })
