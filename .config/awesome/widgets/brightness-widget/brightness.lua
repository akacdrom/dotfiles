local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local brightness_widget = {}

local function worker()

    local get_brightness_cmd = 'bash -c "brightnessctl -m | cut -d, -f4 | tr -d %"'
    local set_brightness_cmd = 'brightnessctl set %d%%'
    local inc_brightness_cmd = 'brightnessctl set 5%+'
    local dec_brightness_cmd = 'brightnessctl set 5%-'

    brightness_widget.widget = wibox.widget {
        {
            {
                image = "/home/cd-r0m/.config/awesome/widgets/brightness-widget/brightness.svg",
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
    local brightness_level = 0
    local update_widget = function(widget, stdout, _, _, _)
        brightness_level = tonumber(stdout)
        widget:set_value(brightness_level)
    end

    function brightness_widget:set(value)
        spawn.easy_async(string.format(set_brightness_cmd, value), function()
            spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness_widget.widget, out)
            end)
        end)
    end

    function brightness_widget:inc()
        spawn.easy_async(inc_brightness_cmd, function()
            spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness_widget.widget, out)
            end)
        end)
    end

    function brightness_widget:dec()
        spawn.easy_async(dec_brightness_cmd, function()
            spawn.easy_async(get_brightness_cmd, function(out)
                update_widget(brightness_widget.widget, out)
            end)
        end)
    end

    brightness_widget.widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function() brightness_widget:set(100) end),
            awful.button({}, 4, function() brightness_widget:inc() end),
            awful.button({}, 5, function() brightness_widget:dec() end)
        )
    )

    local function get_bright_info()
        f = io.popen("brightnessctl | awk 'NR==1 {print $2}'")
        local device = "┌[Brightness]\n├Device:\t" .. f:read("a")
        f = io.popen(get_brightness_cmd)
        local level = "└Level:\t\t" .. f:read("l") .. "%"
        return device .. level
    end

    local notification = nil
    function brightness_widget:hide()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    function brightness_widget:show()
        brightness_widget:hide()
        notification = naughty.notify({
            icon      = "/home/cd-r0m/.config/awesome/themes/default/icons/disco-light.png",
            icon_size = dpi(150),
            title     = get_bright_info(),
            font      = "Jetbrains Mono Extra Bold Nerd Font 11"
        })

    end

    brightness_widget:attach()
    watch(get_brightness_cmd, 6, update_widget, brightness_widget.widget)

    return brightness_widget.widget
end

function brightness_widget:attach()
    brightness_widget.widget:connect_signal('mouse::enter', function() brightness_widget:show() end)
    brightness_widget.widget:connect_signal('mouse::leave', function() brightness_widget:hide() end)
    return brightness_widget.widget
end

return setmetatable(brightness_widget, { __call = function(_, ...) return worker() end })
