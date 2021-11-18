-- Standard awesome library
local awful = require("awful")

-- Layouts --

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {

    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
    --awful.layout.suit.fair,
}
