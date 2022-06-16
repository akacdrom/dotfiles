local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")
local spawn = require("awful.spawn")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local memory_widget = {}

local function worker()

    local used_memory = "bash -c /home/cd-r0m/.config/awesome/widgets/memory-widget/mem.sh"
    local bpytop_mem = "alacritty --hold -e bpytop -b 'mem'"

    memory_widget.widget = wibox.widget {
        {
            {
                image = "/home/cd-r0m/.config/awesome/widgets/memory-widget/mem.png",
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
    local mem_usage = 0
    local update_widget = function(widget, stdout, _, _, _)
        collectgarbage("collect")
        mem_usage = tonumber(stdout)
        widget:set_value(100 - mem_usage)
    end

    function memory_widget:set()
        spawn.easy_async(string.format(bpytop_mem), function()
            spawn.easy_async(used_memory, function(out)
                update_widget(memory_widget.widget, out)
            end)
        end)
    end

    memory_widget.widget:buttons(
        awful.util.table.join(
            awful.button({}, 1, function() memory_widget:set() end)
        )
    )

    local function getMemInfo()
        f = io.popen("free -h | awk 'NR==2{print $2}'")
        local totalMem = "┌[Memory]\n├Total:\t\t" .. f:read("a")
        f = io.popen("free -h | awk 'NR==2{print $3}'")
        local usedMem = "├Used:\t\t" .. f:read("a")
        f = io.popen("free -h | awk 'NR==2{print $7}'")
        local availableMem = "└Available:\t" .. f:read("a")
        return totalMem .. usedMem .. availableMem
    end

    local function getSwapInfo()
        f = io.popen("free -h | awk 'NR==3{print $2}'")
        local totallSwap = "┌[Swap]\n├Total:\t\t" .. f:read("a")
        f = io.popen("free -h | awk 'NR==3{print $3}'")
        local usedSwap = "├Used:\t\t" .. f:read("a")
        f = io.popen("free -h | awk 'NR==3{print $4}'")
        local availablelSwap = "└Available:\t" .. f:read("a")
        return totallSwap .. usedSwap .. availablelSwap
    end

    local notification_mem = nil
    local notification_swap = nil
    function memory_widget:hide()
        if notification_mem ~= nil then
            naughty.destroy(notification_mem)
            naughty.destroy(notification_swap)
            notification_mem = nil
            notification_swap = nil
        end
    end

    function memory_widget:show()
        memory_widget:hide()
        notification_mem = naughty.notify({
            icon      = "/home/cd-r0m/.config/awesome/widgets/memory-widget/memory.png",
            icon_size = dpi(150),
            title     = getMemInfo(),
            font      = "Jetbrains Mono Extra Bold Nerd Font 11",
            position  = "bottom_right",
        })
        notification_swap = naughty.notify({
            icon      = "/home/cd-r0m/.config/awesome/widgets/memory-widget/swap.png",
            icon_size = dpi(150),
            title     = getSwapInfo(),
            font      = "Jetbrains Mono Extra Bold Nerd Font 11",
            position  = "bottom_right",
        })
    end

    memory_widget:attach()
    watch(used_memory, 4, update_widget, memory_widget.widget)
    return memory_widget.widget
end

function memory_widget:attach()
    memory_widget.widget:connect_signal('mouse::enter', function() memory_widget:show() end)
    memory_widget.widget:connect_signal('mouse::leave', function() memory_widget:hide() end)
    return memory_widget.widget
end

return setmetatable(memory_widget, { __call = function(_, ...) return worker() end })
