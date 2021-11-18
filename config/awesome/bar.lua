-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
-- Shape for widgets
--local shape = require("gears.shape")
-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- {{{ Wibar
-- Create a textclock widget
--
    local clock_shape = function(cr, width, height, radius)
      gears.shape.transform(gears.shape.rounded_rect) : translate(0,3) (cr, 72, 14, 4)
    end
                mytextclock = wibox.widget 
                { 
                     {{ widget =  wibox.widget.textclock("  %H:%M ")},
                        left = 5,
                        right = 5,
                        widget = wibox.container.margin},
                        bg = "#15152b",
                        shape = clock_shape,
                        widget = wibox.container.background,
                }
local month_calendar = awful.widget.calendar_popup.month(
              {
		long_weekdays     = true,
                margin            = 15,
                spacing           = 10,
                font              = "JetbrainsMono Nerd Font Bold 10 ",
                style_month       = {
			border_width    = 1,
                        bg_color 	= "#000000",
                        border_color    = "#4319c2",
                        padding         = 5,
		},
                style_header = {
                  bg_color = "#0d0d24",
                  fg_color = "#ff1737",
                  padding = 7,
                  shape  = gears.shape.rectangle,
                },
                style_weekday = {
                  bg_color = "#0d0d24",
                  fg_color = "#ff5100",
                  padding = 7,
                  shape  = gears.shape.rounded_rect,
                },
                style_focus = {
                  bg_color = "#17173d",
                  fg_color = "#ffffff",
                  padding = 10,
                  shape  = gears.shape.rounded_bar,
                },
                style_normal = {
                  border_width = 2,
                  border_color = "#17173d",
                  fg_color = "#ffffff",
                  padding = 10,
                  shape  = gears.shape.rounded_bar,
                },
              }
)
month_calendar:attach( mytextclock, "br")

local systray = wibox.layout.margin(wibox.widget.systray(true), 5, 5, 3, 3)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

awful.screen.connect_for_each_screen(function(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    
    -- Create a taglist widget
    --
    local taglist_shape = function(cr, width, height, radius)
      gears.shape.transform(gears.shape.rounded_rect) : translate(0,3) (cr, 114, 14, 4)
    end

    local focus_tag_shape = function(cr, width, height, radius)
      gears.shape.transform(gears.shape.rounded_rect) : translate(0,17) (cr, 25, 3, 0)
    end

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style = {
          shape_border_width = 0,
          shape  = focus_tag_shape,
        },
        layout  = {
            spacing = 5,
            layout  = wibox.layout.fixed.horizontal
            },
        buttons = taglist_buttons,
      }
    newtaglist = wibox.widget {
          { 
            { widget = s.mytaglist },
            left = 10,
            right = 10,
            widget = wibox.container.margin
          },
          bg = "#15152b",
          shape = taglist_shape,
          widget = wibox.container.background,
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style = 
          {
          align = "center",
          shape_border_width = 3,
          shape_border_color = "#000000",
          shape  = gears.shape.rounded_bar,
          },
        layout  = 
          {
          spacing = 5,
          layout  = wibox.layout.flex.horizontal
          },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s, height = 20})

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
          wibox.layout.margin(newtaglist,5,0,0,0),
        },
        wibox.layout.margin(s.mytasklist,10,0,0,0),
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            systray,
            wibox.layout.margin(mytextclock,0,5,0,0),
            wibox.layout.margin(s.mylayoutbox,0,5,2,2),
        },
    }
end)
