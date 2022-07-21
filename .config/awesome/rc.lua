-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
-- Declarative object management
local ruled = require("ruled")
-- Xresources and dpi
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
--Brightness widget
local brightness_widget = require("widgets.brightness-widget.brightness")
--Battery widget
local batteryarc_widget = require("widgets.batteryarc-widget.batteryarc")
--Volume widget
local volume_widget = require('widgets.volume-widget.volume')
--Wifi widget
local net_widgets = require("widgets.wireless-widget.wireless")
--Memory widget
local memory_widget = require("widgets.memory-widget.memory")
--CPU widget
local cpu_widget = require("widgets.cpu-widget.cpu")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message
    }
end)

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init("~/.config/awesome/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
local terminal = "alacritty"
-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- {{{ Tag layout
-- Table of layouts to cover with awful.layout.inc, order matters.
tag.connect_signal("request::default_layouts", function()
    awful.layout.append_default_layouts({
        awful.layout.suit.tile,
        awful.layout.suit.floating,
        awful.layout.suit.max,
    })
end)
-- }}}

-- {{{ Wallpaper
screen.connect_signal("request::wallpaper", function(s)
    awful.wallpaper {
        screen = s,
        widget = {
            {
                image     = beautiful.wallpaper,
                upscale   = true,
                downscale = true,
                widget    = wibox.widget.imagebox,
            },
            valign = "center",
            halign = "center",
            tiled  = true,
            widget = wibox.container.tile,
        }
    }
end)
-- }}}

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock("|  %H:%M")

local month_calendar = awful.widget.calendar_popup.month(
    {
        long_weekdays = true,
        margin        = 15,
        spacing       = 10,
        style_month   = {
            border_width = 10,
            bg_color     = "#0F0E17",
            border_color = "#0F0E17",
            padding      = 5,
            shape        = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 10)
            end
        },
        style_header  = {
            bg_color     = "#1E1C2E",
            fg_color     = "#ffffff",
            border_color = "1E1C2E",
            padding      = 7,
            shape        = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 10)
            end
        },
        style_weekday = {
            bg_color     = "#1E1C2E",
            fg_color     = "#ffffff",
            border_color = "1E1C2E",
            padding      = 7,
            shape        = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 10)
            end
        },
        style_focus   = {
            bg_color     = "#1E1C2E",
            fg_color     = "#ffffff",
            border_color = "1E1C2E",
            padding      = 10,
            shape        = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 10)
            end
        },
        style_normal  = {
            bg_color     = "#0F0E17",
            fg_color     = "#555",
            border_color = "0F0E17",
            padding      = 10,
            shape        = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 10)
            end
        },
        screen        = awful.screen.focused()
    }
)
month_calendar:attach(mytextclock, "br")

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ "", "", "", "", "", "", "", "", "" }, s, awful.layout.layouts[1])
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox {
        screen  = s,
        buttons = {
            awful.button({}, 1, function() awful.layout.inc(1) end),
            awful.button({}, 3, function() awful.layout.inc(-1) end),
            awful.button({}, 4, function() awful.layout.inc(-1) end),
            awful.button({}, 5, function() awful.layout.inc(1) end),
        }
    }
    -- Create a taglist widget
    local taglist_shape = function(cr, width, height, radius)
        gears.shape.transform(gears.shape.rounded_rect):translate(0, 0)(cr, width, height, 8)
    end
    s.mytaglist = awful.widget.taglist {
        screen          = s,
        filter          = awful.widget.taglist.filter.all,
        buttons         = {
            awful.button({}, 1, function(t) t:view_only() end),
            awful.button({ modkey }, 1, function(t)
                if client.focus then
                    client.focus:move_to_tag(t)
                end
            end),
            awful.button({}, 3, awful.tag.viewtoggle),
            awful.button({ modkey }, 3, function(t)
                if client.focus then
                    client.focus:toggle_tag(t)
                end
            end),
            awful.button({}, 4, function(t) awful.tag.viewprev(t.screen) end),
            awful.button({}, 5, function(t) awful.tag.viewnext(t.screen) end),
        },
        widget_template = {
            {
                {
                    id     = 'index_role',
                    widget = wibox.widget.textbox,
                },
                widget = wibox.container.margin,
            },
            id              = 'background_role',
            widget          = wibox.container.background,
            -- Add support for hover colors and an index label
            create_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('index_role')[1].markup = '<b> ' .. index .. ' </b>'
            end,
            update_callback = function(self, c3, index, objects) --luacheck: no unused args
                self:get_children_by_id('index_role')[1].markup = '<b> ' .. index .. ' </b>'
            end,
        },
    }
    local new_tag_list = wibox.widget {
        {
            { widget = s.mytaglist },
            left = 15,
            right = 15,
            top = 4,
            bottom = 4,
            widget = wibox.container.margin
        },
        bg = beautiful.bg_normal,
        shape_border_width = 4,
        border_color = "#000000",
        shape = taglist_shape,
        widget = wibox.container.background,
    }
    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen          = s,
        filter          = awful.widget.tasklist.filter.currenttags,
        buttons         = {
            awful.button({}, 1, function(c)
                c:activate { context = "tasklist", action = "toggle_minimization" }
            end),
            awful.button({}, 3, function() awful.menu.client_list { theme = { width = 250 } } end),
            awful.button({}, 4, function() awful.client.focus.byidx(-1) end),
            awful.button({}, 5, function() awful.client.focus.byidx(1) end),
        },
        style           = {
            shape = gears.shape.rounded_rect,
            shape_border_width = 2,
            shape_border_color = '#000000',
            align = "center"
        },
        layout          = {
            spacing = 2,
            --max_widget_size = awful.screen.focused().workarea.width * 0.40,
            layout  = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = "icon_role",
                            widget = wibox.widget.imagebox,
                        },
                        margins = 5,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.align.horizontal,
                },
                left   = 10,
                right  = 10,
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,
        }

    }
    -- Create the wibox
    s.mywibox = awful.wibar {
        position = "bottom",
        screen   = s,
        height   = 30,
        widget   = {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            { -- Left widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.container.margin(new_tag_list, 0, 0, 0, 0),
            },
            wibox.container.margin(s.mytasklist, 0, 0, 0, 0), -- Middle widget
            { -- Right widgets
                layout = wibox.layout.fixed.horizontal,
                wibox.container.margin(wibox.widget.systray(), 0, 0, 4, 4),
                wibox.container.margin(brightness_widget(), 5, 5, 0, 0),
                batteryarc_widget(),
                wibox.container.margin(volume_widget(), 5, 5, 0, 0),
                wibox.container.margin(net_widgets(), 0, 0, 0, 0),
                wibox.container.margin(memory_widget(), 5, 0, 0, 0),
                wibox.container.margin(cpu_widget(), 5, 0, 0, 0),
                wibox.container.margin(mytextclock, 5, 5, 0, 0),
                wibox.container.margin(s.mylayoutbox, 0, 0, 7, 7)
            },
        }
    }
end)
-- }}}

-- {{{ Key bindings
-- General Awesome keys
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift" }, "o", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Control", "q" }, "p", awesome.quit,
        { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" })
})

-- Tags related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "a", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "d", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),
})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ "Mod1", }, "Tab",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "Tab",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, "Shift" }, "Tab",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey, "Control" }, "Right", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "Left", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" })
})
-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift" }, "Right", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "Left", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, }, "Right", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "Left", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, }, "Up", function() awful.client.incwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "Down", function() awful.client.incwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),
})
-- Standard custom program
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, }, "q", function() awful.spawn("rofi -show drun") end,
        { description = "open rofi", group = "launcher" }),
    awful.key({ modkey, }, "e", function() awful.spawn("pcmanfm") end,
        { description = "open pcmanfm", group = "launcher" }),
    awful.key({ modkey, }, "F12", function()
        naughty.destroy_all_notifications()
        local volume = "N/A"
        local headphones = 0
        awful.spawn("pamixer -i 5 --allow-boost")
        f = io.popen("pamixer --get-volume")
        volume = f:read("n")
        f = io.popen("pamixer --get-default-sink | grep 'FreeBuds' | wc -c")
        headphones = f:read("n")
        local text = ""
        local icon = "/home/cd-r0m/.config/awesome/themes/default/icons/volume.png"
        if headphones > 1 then
            icon = "/usr/share/icons/Papirus-Dark/48x48/devices/audio-headphones.svg"
            text = "Huawei 4i Earpods Using"
        end
        naughty.config.padding = dpi(100)
        naughty.notify {
            icon = icon,
            title = "Volume: " .. volume .. "%",
            text = text,
            timeout = 2, -- show the warning for a longer time
            hover_timeout = 1,
            position = "bottom_middle",
        }
        naughty.config.padding = dpi(15)
    end,
        { description = "increase volume", group = "launcher" }),
    awful.key({ modkey, }, "F11", function()
        naughty.destroy_all_notifications()
        local volume = "N/A"
        local headphones = 0
        awful.spawn("pamixer -d 5 --allow-boost")
        f = io.popen("pamixer --get-volume")
        volume = f:read("n")
        f = io.popen("pamixer --get-default-sink | grep 'FreeBuds' | wc -c")
        headphones = f:read("n")
        local text = ""
        local icon = "/home/cd-r0m/.config/awesome/themes/default/icons/volume.png"
        if headphones > 1 then
            icon = "/usr/share/icons/Papirus-Dark/48x48/devices/audio-headphones.svg"
            text = "Huawei 4i Earpods Using"
        end
        naughty.config.padding = dpi(100)
        naughty.notify {
            icon = icon,
            title = "Volume: " .. volume .. "%",
            text = text,
            timeout = 2, -- show the warning for a longer time
            hover_timeout = 1,
            position = "bottom_middle",
        }
        naughty.config.padding = dpi(15)
    end,
        { description = "decrease volume", group = "launcher" }),
    awful.key({ modkey, }, "F10", function() awful.spawn("pamixer -t") end,
        { description = "mute volume", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "F10", function() awful.spawn("playerctl play-pause") end,
        { description = "", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "F12", function() awful.spawn("playerctl next") end,
        { description = "", group = "launcher" }),
    awful.key({ modkey, "Shift" }, "F11", function() awful.spawn("playerctl previous") end,
        { description = "", group = "launcher" }),
    awful.key({}, "Print", function() awful.spawn("/home/cd-r0m/.scripts/screenshot-full.sh") end,
        { description = "full screenshot", group = "launcher" }),
    awful.key({ modkey, }, "Print", function() awful.spawn("/home/cd-r0m/.scripts/screenshot-select.sh") end,
        { description = "selected screenshot", group = "launcher" }),
    awful.key({ modkey, }, "v", function() awful.spawn("/home/cd-r0m/.scripts/green-clip.sh") end,
        { description = "clipboard", group = "launcher" }),
    awful.key({ modkey, }, "F5", function()
        naughty.destroy_all_notifications()
        local brightness = "N/A"
        awful.spawn("brightnessctl set 5%-")
        f = io.popen('bash -c "brightnessctl -m | cut -d, -f4 | tr -d %"')
        brightness = f:read("n")
        local icon = "/home/cd-r0m/.config/awesome/themes/default/icons/brightness.png"
        naughty.config.padding = dpi(100)
        naughty.notify {
            icon = icon,
            title = "Brightness: " .. brightness .. "%",
            timeout = 2, -- show the warning for a longer time
            hover_timeout = 1,
            position = "bottom_middle",
        }
        naughty.config.padding = dpi(15)
    end,
        { description = "decrease brightness", group = "launcher" }),
    awful.key({ modkey, }, "F6", function()
        naughty.destroy_all_notifications()
        local brightness = "N/A"
        awful.spawn("brightnessctl set 5%+")
        f = io.popen('bash -c "brightnessctl -m | cut -d, -f4 | tr -d %"')
        brightness = f:read("n")
        local icon = "/home/cd-r0m/.config/awesome/themes/default/icons/brightness.png"
        naughty.config.padding = dpi(100)
        naughty.notify {
            icon = icon,
            title = "Brightness: " .. brightness .. "%",
            timeout = 2, -- show the warning for a longer time
            hover_timeout = 1,
            position = "bottom_middle",
        }
        naughty.config.padding = dpi(15)
    end,
        { description = "increase brightness", group = "launcher" }),
})

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control" },
        keygroup    = "numrow",
        description = "toggle tag",
        group       = "tag",
        on_press    = function(index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey, "Control", "Shift" },
        keygroup    = "numrow",
        description = "toggle focused client on tag",
        group       = "tag",
        on_press    = function(index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function(index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({}, 1, function(c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function(c)
            c:activate { context = "mouse_click", action = "mouse_move" }
        end),
        awful.button({ modkey }, 3, function(c)
            c:activate { context = "mouse_click", action = "mouse_resize" }
        end),
    })
end)

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey, }, "f",
            function(c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            { description = "toggle fullscreen", group = "client" }),
        awful.key({ modkey, "Shift" }, "q", function(c) c:kill() end,
            { description = "close", group = "client" }),
        awful.key({ modkey, }, "s", awful.client.floating.toggle,
            { description = "toggle floating", group = "client" }),
        awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
            { description = "move to master", group = "client" }),
        awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
            { description = "move to screen", group = "client" }),
        awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
            { description = "toggle keep on top", group = "client" }),
        awful.key({ modkey, }, "n",
            function(c)
                -- The client currently has the input focus, so it cannot be
                -- minimized, since minimized clients can't have the focus.
                c.minimized = true
            end,
            { description = "minimize", group = "client" }),
        awful.key({ modkey, }, "m",
            function(c)
                c.maximized = not c.maximized
                c:raise()
            end,
            { description = "(un)maximize", group = "client" }),
        awful.key({ modkey, "Control" }, "m",
            function(c)
                c.maximized_vertical = not c.maximized_vertical
                c:raise()
            end,
            { description = "(un)maximize vertically", group = "client" }),
        awful.key({ modkey, "Shift" }, "m",
            function(c)
                c.maximized_horizontal = not c.maximized_horizontal
                c:raise()
            end,
            { description = "(un)maximize horizontally", group = "client" })
    })
end)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
-- Rules to apply to new clients.
ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = {},
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
        }
    }

    -- Floating clients.
    ruled.client.append_rule {
        id         = "floating",
        rule_any   = {
            instance = { "copyq", "pinentry" },
            class    = {
                "Arandr", "Blueman-manager", "Gpick", "Kruler", "Sxiv",
                "Tor Browser", "Wpa_gui", "veromix", "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name     = {
                "Event Tester", -- xev.
            },
            role     = {
                "AlarmWindow", -- Thunderbird's calendar.
                "ConfigManager", -- Thunderbird's about:config.
                "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
            }
        },
        properties = { floating = true }
    }

    -- Set Chrome to always map on the tag named "1" on screen 1.
    --ruled.client.append_rule {
    --    rule       = { class = "Google-chrome" },
    --    properties = { tag = screen[1].tags[4] }
    --}
end)

-- }}}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

-- Remove border on single client
-- local function set_border(c)
--     local s = awful.screen.focused()
--     if c.maximized
--         or (#s.tiled_clients == 1 and not c.floating)
--         or (s.selected_tag and s.selected_tag.layout.name == 'max')
--     then
--         c.border_width = 0
--     else
--         c.border_width = beautiful.border_width
--     end
-- end
-- client.connect_signal("request::border", set_border)
-- client.connect_signal("property::maximized", set_border)

awful.spawn.with_shell("/home/cd-r0m/.config/awesome/autorun.sh")
gears.timer {
    timeout = 30,
    autostart = true,
    callback = function() collectgarbage() end
}
