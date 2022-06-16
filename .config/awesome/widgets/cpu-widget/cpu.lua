local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local naughty = require("naughty")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local cpu_widget = {}

local function worker()

    local used_cpu = "bash -c /home/cd-r0m/.config/awesome/widgets/cpu-widget/cpu.sh"
    local bpytop_cpu = "alacritty --hold -e bpytop -b 'proc cpu'"

    cpu_widget.widget = wibox.widget {
        {
            {
                image = "/home/cd-r0m/.config/awesome/widgets/cpu-widget/cpu.png",
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
    local cpu_usage = 0
    local update_widget = function(widget, stdout, _, _, _)
        collectgarbage("collect")
        cpu_usage = tonumber(stdout)
        widget:set_value(cpu_usage)
    end

    function cpu_widget:set()
        spawn.easy_async(string.format(bpytop_cpu), function()
            spawn.easy_async(used_cpu, function(out)
                update_widget(cpu_widget.widget, out)
            end)
        end)
    end

    cpu_widget.widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function() cpu_widget:set() end)
        )
    )

    local function getCPUInfo()
        f = io.popen("lscpu | awk 'NR==8 {$1=$2=$4=$6=$7=$8=\"\"; print $0}'|xargs")
        local cpuModel = "┌[CPU]\n├Model:\t" .. f:read("a")
        local cpuUsage = "├Using:\t" .. cpu_usage .. "%\n"
        f = io.popen("echo $(acpi -t | tr ' ' '\n' | tr -d 'Thermal' | grep -m1 '.0')'°C'")
        local cpuTemp = "└Temp:\t" .. f:read("a")

        return cpuModel .. cpuUsage .. cpuTemp
    end

    local notification = nil
    function cpu_widget:hide()
        if notification ~= nil then
            naughty.destroy(notification)
            notification = nil
        end
    end

    function cpu_widget:show()
        cpu_widget:hide()

        notification = naughty.notify({
            icon_size = dpi(150),
            title     = getCPUInfo(),
            icon      = "/home/cd-r0m/.config/awesome/themes/default/icons/cpu.png",
            font      = "Jetbrains Mono Extra Bold Nerd Font 11",
            position  = "bottom_right",
        })
    end

    cpu_widget:attach()
    watch(used_cpu, 3, update_widget, cpu_widget.widget)
    return cpu_widget.widget
end

function cpu_widget:attach()
    cpu_widget.widget:connect_signal('mouse::enter', function() cpu_widget:show() end)
    cpu_widget.widget:connect_signal('mouse::leave', function() cpu_widget:hide() end)
    return cpu_widget.widget
end

return setmetatable(cpu_widget, { __call = function(_, ...) return worker() end })
