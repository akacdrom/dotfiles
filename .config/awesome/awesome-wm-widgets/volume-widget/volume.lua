-------------------------------------------------
-- The Ultimate Volume Widget for Awesome Window Manager
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/volume-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local spawn = require("awful.spawn")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local beautiful = require('beautiful')


local widget = {}

function widget.get_widget(widgets_args)
    local args = widgets_args or {}

    local size = 18

    return wibox.widget {
        {
            id = "icon",
            image = '/home/cd-r0m/.config/awesome/awesome-wm-widgets/volume-widget/icons/audio-volume-high-symbolic.svg',
            resize = true,
            widget = wibox.widget.imagebox,
        },
        max_value = 100,
        thickness = 2,
        start_angle = 4.71238898, -- 2pi*3/4
        forced_height = size,
        forced_width = size,
        bg = '#ffffff11',
        paddings = 2,
        widget = wibox.container.arcchart,
        set_volume_level = function(self, new_value)
            self.value = new_value
        end,
        mute = function(self)
            self.colors = { '#ff0000' }
        end,
        unmute = function(self)
            self.colors = { beautiful.fg_color }
        end
    }

end

local function GET_VOLUME_CMD() return 'pamixer --get-volume' end

local function INC_VOLUME_CMD() return 'pamixer -i 5 --set-limit 100' end

local function DEC_VOLUME_CMD() return 'pamixer -d 5' end

local function TOG_VOLUME_CMD() return 'pamixer -t' end

local volume = {}

local function worker(user_args)

    local args = user_args or {}


    volume.widget = widget.get_widget(args)


    local function update_graphic(widget, stdout)
        widget:set_volume_level(stdout)
    end

    function volume:inc()
        spawn.easy_async(INC_VOLUME_CMD(), function(stdout) update_graphic(volume.widget, stdout) end)
    end

    function volume:dec()
        spawn.easy_async(DEC_VOLUME_CMD(), function(stdout) update_graphic(volume.widget, stdout) end)
    end

    function volume:toggle()
        spawn.easy_async(TOG_VOLUME_CMD(), function(stdout) update_graphic(volume.widget, stdout) end)
    end

    function volume:mixer()
        spawn.easy_async('pavucontrol')
    end

    volume.widget:buttons(
        awful.util.table.join(
            awful.button({}, 4, function() volume:inc() end),
            awful.button({}, 5, function() volume:dec() end),
            awful.button({}, 2, function() volume:mixer() end),
            awful.button({}, 1, function() volume:toggle() end)
        )
    )

    watch(GET_VOLUME_CMD(), 1, update_graphic, volume.widget)

    return volume.widget
end

return setmetatable(volume, { __call = function(_, ...) return worker(...) end })
