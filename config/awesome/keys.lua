 
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Hotkeys library
local hotkeys_popup = require("awful.hotkeys_popup")

-- Modkey --
modkey = "Mod4"

-- Key bindings
globalkeys = gears.table.join(
  -- Tags  
    awful.key({ modkey,}, "Escape", awful.tag.history.restore, {}),
  -- Client --
    awful.key({ modkey,}, "Left",function () awful.client.focus.bydirection( "left") end, {}),
    awful.key({ modkey,}, "Right",function () awful.client.focus.bydirection( "right") end, {}),
    awful.key({ modkey,}, "Down",function () awful.client.focus.bydirection( "down") end, {}),
    awful.key({ modkey,}, "Up",function () awful.client.focus.bydirection( "up") end, {}),
    awful.key({ modkey,}, "Tab", function () awful.client.focus.byidx( 1) end, {} ),
    awful.key({ modkey, "Control"}, "Tab", function () awful.client.focus.byidx( -1) end, {} ),
    -- Layout manipulation
    awful.key({ modkey, "Shift"}, "Tab", function () awful.client.swap.byidx(  1) end, {}),
    awful.key({ modkey, "Shift"}, "Left", function () awful.client.swap.bydirection( "left") end, {}),
    awful.key({ modkey, "Shift"}, "Right", function () awful.client.swap.bydirection( "right") end, {}),
    awful.key({ modkey, "Shift"}, "Down", function () awful.client.swap.bydirection( "down") end, {}),
    awful.key({ modkey, "Shift"}, "Up", function () awful.client.swap.bydirection( "up") end, {}),
    awful.key({ modkey,}, "u", awful.client.urgent.jumpto, {}),
    -- Window Size Adjust
    awful.key({ modkey, "Control"}, "Right", function () awful.tag.incmwfact( 0.10)end, {}),
    awful.key({ modkey, "Control"}, "Left", function () awful.tag.incmwfact(-0.10) end,{}),
    awful.key({ modkey, "Control"}, "Up", function () awful.client.incwfact(0.10, client.focus) end,{}),
    awful.key({ modkey, "Control"}, "Down", function () awful.client.incwfact(-0.10, client.focus) end,{}),
    -- Master Window
    awful.key({ modkey, "Shift"   }, "h", function () awful.tag.incnmaster( 1, nil, true) end, {}),
    awful.key({ modkey, "Shift"   }, "l", function () awful.tag.incnmaster(-1, nil, true) end, {}),
    -- Column Number
    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1, nil, true)    end, {}),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1, nil, true)    end, {}),
    -- Standard program
    awful.key({ modkey,}, "w", function () awful.spawn(terminal) end, {}),
    awful.key({ modkey,}, "q", function () awful.spawn("rofi -show combi") end, {}),
    awful.key({ modkey,}, "e", function () awful.spawn("pcmanfm") end, {}),
    awful.key({ modkey,}, "F12", function () awful.spawn("bash /home/cd-r0m/.scripts/vol-not.sh up") end, {}),
    awful.key({ modkey,}, "F11", function () awful.spawn("bash /home/cd-r0m/.scripts/vol-not.sh down") end, {}),
    awful.key({ modkey, "Shift"}, "F12", function () awful.spawn("bash /home/cd-r0m/.scripts/mic-not.sh up") end, {}),
    awful.key({ modkey, "Shift"}, "F11", function () awful.spawn("bash /home/cd-r0m/.scripts/mic-not.sh down") end, {}),
    awful.key({}, "Print", function () awful.spawn("bash /home/cd-r0m/.scripts/screenshot-full.sh") end, {}),
    awful.key({modkey,}, "Print", function () awful.spawn("bash /home/cd-r0m/.scripts/screenshot-select.sh") end, {}),
    awful.key({modkey,}, "v", function () awful.spawn("bash /home/cd-r0m/.scripts/green-clip.sh") end, {}),
    awful.key({modkey,}, "F6", function () awful.spawn("bash /home/cd-r0m/.scripts/brightness-not.sh up") end, {}),
    awful.key({modkey,}, "F5", function () awful.spawn("bash /home/cd-r0m/.scripts/brightness-not.sh down") end, {}),
  -- Awesome --
    awful.key({ modkey, "Shift"}, "r", awesome.restart, {}),
    awful.key({ modkey, "Shift"}, "q", awesome.quit, {}),
    awful.key({ modkey,}, "space", function () awful.layout.inc(1) end, {}),
    awful.key({ modkey, "Shift"}, "space", function () awful.layout.inc(-1) end, {}),
    awful.key({ modkey, "Control" }, "n", function () local c = awful.client.restore() if c then c:emit_signal("request::activate", "key.unminimize", {raise = true}) end end, {}) )
-- Layout and Window behaviour
clientkeys = gears.table.join(
    -- Fullscreen
    awful.key({ modkey,}, "f", function (c) c.fullscreen = not c.fullscreen c:raise() end, {}),
    awful.key({ modkey,}, "p",function (c) c:kill()end, {}),
    awful.key({ modkey,}, "s",  awful.client.floating.toggle,{}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,{}),
    awful.key({ modkey,}, "o",function (c) c:move_to_screen()end, {}),
    awful.key({ modkey,}, "t",function (c) c.ontop = not c.ontop end, {}),
    awful.key({ modkey,}, "n", function (c) c.minimized = true end , {}),
    awful.key({ modkey,}, "m", function (c) c.maximized = not c.maximized c:raise() end , {}),
    awful.key({ modkey, "Control" }, "m",function (c) c.maximized_vertical = not c.maximized_vertical c:raise() end , {}),
    awful.key({ modkey, "Shift"   }, "m", function (c) c.maximized_horizontal = not c.maximized_horizontal c:raise() end , {}) )
-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {})
    )
end

-- Mouse buttons
clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)
