local awful = require("awful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require('beautiful')
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local volume_widget = {}

local function worker()

    local get_volume_cmd = 'pamixer --get-volume'
    local inc_volume_cmd = 'pamixer -i 5 --set-limit 100'
    local dec_volume_cmd = 'pamixer -d 5'
    local tog_volume_cmd = 'pamixer -t'
    local get_mute_status = 'pamixer --get-mute'
    local notify_icon = '/home/cd-r0m/.config/awesome/widgets/volume-widget/spaceman.jpg'
    local notify_position = 'bottom_right'

    volume_widget.widget = wibox.widget {
        {
            {
                image = "/home/cd-r0m/.config/awesome/widgets/volume-widget/volume.svg",
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

    local function show_mute_warning()
        naughty.notify {
            icon = notify_icon,
            icon_size = 100,
            text = 'some silence...',
            title = 'Volume Is Muted',
            timeout = 5,
            hover_timeout = 0.5,
            position = notify_position,
            width = 400,
        }
    end

    local function show_unmute_warning()
        naughty.notify {
            icon = notify_icon,
            icon_size = 100,
            text = 'careful there...',
            title = 'Volume Is Unmuted',
            timeout = 5,
            hover_timeout = 0.5,
            position = notify_position,
            width = 400,
        }
    end

    local update_widget_color = function(widget)
        spawn.easy_async(get_mute_status, function(mute_status)
            if mute_status:gsub("%s+", "") == 'true' then
                show_mute_warning()
                widget.colors = { '##ffffff11' }
            else
                show_unmute_warning()
                widget.colors = { beautiful.fg_color }
            end
        end)
    end

    local update_widget = function(widget, out)
        spawn.easy_async(get_mute_status, function(mute_status)
            if mute_status:gsub("%s+", "") == 'true' then
                widget.colors = { '##ffffff11' }
            else
                widget.colors = { beautiful.fg_color }
            end
        end)
        widget:set_value(out)
    end

    function volume_widget:inc()
        spawn.easy_async(inc_volume_cmd, function()
            spawn.easy_async(get_volume_cmd, function(out)
                update_widget(volume_widget.widget, out)
            end)
        end)
    end

    function volume_widget:dec()
        spawn.easy_async(dec_volume_cmd, function()
            spawn.easy_async(get_volume_cmd, function(out)
                update_widget(volume_widget.widget, out)
            end)
        end)
    end

    function volume_widget:toggle()
        spawn(tog_volume_cmd)
        update_widget_color(volume_widget.widget)
    end

    function volume_widget:mixer()
        spawn('pavucontrol')
    end

    volume_widget.widget:buttons(
        awful.util.table.join(
            awful.button({}, 4, function() volume_widget:inc() end),
            awful.button({}, 5, function() volume_widget:dec() end),
            awful.button({}, 1, function() volume_widget:mixer() end),
            awful.button({}, 2, function() volume_widget:toggle() end)
        )
    )

    local function text_grabber()
        f = io.popen("pamixer --get-default-sink | awk 'NR==2 {print $1=$2=\"\";print $0}' | xargs")
        local sink = "┌[Volume]\n├Sink:\t" .. f:read("a")
        f = io.popen("pamixer --get-volume-human")
        local level = "├Level:\t" .. f:read("a")
        f = io.popen("pamixer --get-mute")
        local mute = "└Mute:\t" .. f:read("a")
        return sink .. level .. mute
    end

    local notification = nil
    function volume_widget:hide()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    function volume_widget:show()
        volume_widget:hide()

        notification = naughty.notify({
            icon_size = dpi(150),
            title     = text_grabber(),
            icon      = "/home/cd-r0m/.config/awesome/themes/default/icons/loud-speaker.png",
            font      = "Jetbrains Mono Extra Bold Nerd Font 11"
        })
    end

    volume_widget:attach()
    watch(get_volume_cmd, 4, update_widget, volume_widget.widget)
    return volume_widget.widget
end

function volume_widget:attach()
    volume_widget.widget:connect_signal('mouse::enter', function() volume_widget:show() end)
    volume_widget.widget:connect_signal('mouse::leave', function() volume_widget:hide() end)
    return volume_widget.widget
end

return setmetatable(volume_widget, { __call = function(_, ...) return worker() end })
