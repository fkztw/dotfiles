-- <http://awesome.naquadah.org/wiki/FAQ>
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- vicious widgets library
local vicious = require("vicious")

awesome.font = "WenQuanYi Zen Hei Mono 12"


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/m157q/.config/awesome/themes/default/theme.lua")

-- default terminal and editor
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
-- modkey
modkey = "Mod4"





-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    -- delete useless layouts
    awful.layout.suit.tile,               -- 1 (tile.right)
    awful.layout.suit.max,                -- 2
    -- awful.layout.suit.tile.left,       --
    awful.layout.suit.tile.bottom,        -- 3
    -- awful.layout.suit.tile.top,           --
    -- awful.layout.suit.fair,               --
    -- awful.layout.suit.fair.horizontal,    --
    -- awful.layout.suit.spiral,             --
    -- awful.layout.suit.spiral.dwindle,     --
    -- awful.layout.suit.max.fullscreen,     --
    awful.layout.suit.magnifier,          -- 4
    -- awful.layout.suit.floating            --
}
-- }}}

-- {{{ Wallpaper

awful.util.spawn_with_shell("feh --no-fehbg --randomize --bg-fill /usr/share/archlinux/wallpaper/*")

--  beautiful.wallpaper = ""
-- if beautiful.wallpaper then
--     for s = 1, screen.count() do
--         gears.wallpaper.maximized(beautiful.wallpaper, s, true)
--     end
-- end
-- }}}

-- {{{ Tags
-- Each screen has its own tag table.
tags = {}
for s = 1, screen.count() do
    tags[s] = awful.tag(
        {"⌨", "☠", "☢", "☣", "☮", "✈", "✍", "♺", "(．＿．?)"},
        s,
        { layouts[1], layouts[1], layouts[1],
          layouts[1], layouts[1], layouts[1],
          layouts[1], layouts[1], layouts[1]
        }
    )
end

-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

awful.menu.menu_keys = { up    = { "k", "Up" }, down  = { "j", "Down" },
                         enter = { "Right" }, back  = { "h", "Left" },
                         exec  = { "l", "Return", "Right" },
                         close = { "q", "Escape" },
                       }

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu,
                                        beautiful.awesome_icon },
                                    { "Terminal", terminal },
                                    { "Vim", "urxvt -e vim" },
                                    { "emcas", "urxvt -e emacs" },
                                    { "ranger", "urxvt -e ranger" },
                                    { "alsamixer", "urxvt -e alsamixer" },
                                    { "www", "chromium" }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
-- Set the terminal for applications that require it
menubar.utils.terminal = terminal-- }}}

-- {{{ Wibox
-- return the command output for tooltips below
local function tooltip_func_text(command)
    local fd = io.popen(command)
    local lines = fd:read('*a')
    fd:close()
    return command .. ' :\n\n' .. lines
end

 -- network usage
 netwidget = wibox.widget.textbox()
 wireless_interface = 'wlp3s0'
 wired_interface = 'ens9'
 vicious.register(netwidget, vicious.widgets.net,
                 '<span color="#CC9090">⇩${' .. wireless_interface .. ' down_kb}</span>' ..
                 '<span color="#7F9F7F">⇧${' .. wireless_interface .. ' up_kb}</span>' ..
                 '<span color="#CC9090">⇩${' .. wired_interface .. ' down_kb}</span>' ..
                 '<span color="#7F9F7F">⇧${' .. wired_interface .. ' up_kb}</span>', 3)

 -- clock
 clockwidget = awful.widget.textclock(" %a %b %d %H:%M:%S ", 1)
 clockwidget_t = awful.tooltip( {
     objects = {clockwidget},
     timer_function = function ()
         return tooltip_func_text('cal -3')
     end
 })


 -- CPU usage
 cpuwidget = wibox.widget.textbox()
 cpuwidget_t = awful.tooltip( {
     objects = {cpuwidget},
     timer_function = function ()
         return tooltip_func_text('top -b -n 1 | head -n 15')
     end
 })
 vicious.register(cpuwidget, vicious.widgets.cpu,
                  '<span color="#CC0000">$1% </span>[$2:$3:$4:$5]' , 2)

 -- memory usage
 memwidget = wibox.widget.textbox()
 memwidget_t = awful.tooltip( {
     objects = {memwidget},
     timer_function = function ()
         return tooltip_func_text('free -h')
     end
 })
 vicious.register(memwidget, vicious.widgets.mem,
                  '$2MB/$3MB (<span color="#00EE00">$1%</span>)', 5)

 -- battery status
 batwidget = wibox.widget.textbox()
 batwidget_t = awful.tooltip( {
     objects = {batwidget},
     timer_function = function ()
         return tooltip_func_text('acpi -V')
     end
 })
 vicious.register(batwidget, vicious.widgets.bat, '$2% $3[$1]', 2, 'BAT0')
 batwidget:buttons(
     awful.util.table.join(
         awful.button({}, 1, function()
             naughty.notify( {title='Ouch!!',
                              text="you click me!",
                              timeout=10})
         end)
     )
 )

-- widget separator
separator = wibox.widget.textbox()
separator:set_text(" | ")


-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()

    -- only display systray on screen 1
    if s == 1 then right_layout:add(wibox.widget.systray()) end

    -- add my widgets (on screen 2 when i use dual screen)
    if screen.count() == 2 then
        if s == 2 then
            right_layout:add(netwidget)
            right_layout:add(separator)
            right_layout:add(cpuwidget)
            right_layout:add(separator)
            right_layout:add(memwidget)
        end
    else
        right_layout:add(netwidget)
        right_layout:add(separator)
        right_layout:add(cpuwidget)
        right_layout:add(separator)
        right_layout:add(memwidget)
    end
    right_layout:add(separator)
    right_layout:add(batwidget)
    right_layout:add(clockwidget)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    -- these two lines are useless for me XD
    -- awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    -- awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),

    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    -- spawn a new terminal
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    -- resize the client (on the focus)
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),

    -- what the fuck?
    -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    -- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    -- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey, "Control"   }, "h", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Control"   }, "l", function () awful.client.swap.byidx( -1)    end),

    -- change window layouts
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- i can move and click my mouse with hotkeys!!
    awful.key({ modkey, "Shift"   }, "h", function () local mc = mouse.coords()
                mouse.coords({x = mc.x-15, y = mc.y}) end),
    awful.key({ modkey, "Shift"   }, "j", function () local mc = mouse.coords()
                mouse.coords({x = mc.x, y = mc.y+15}) end),
    awful.key({ modkey, "Shift"   }, "k", function () local mc = mouse.coords()
                mouse.coords({x = mc.x, y = mc.y-15}) end),
    awful.key({ modkey, "Shift"   }, "l", function () local mc = mouse.coords()
                mouse.coords({x = mc.x+15, y = mc.y}) end),
    awful.key({ modkey, "Shift"   }, "u", function () awful.util.spawn("xdotool click 1") end),
    awful.key({ modkey, "Shift"   }, "i", function () awful.util.spawn("xdotool click 3") end),

    -- restore the minimized client
    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    -- run a piece of lua code
    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end),

    -- lock my screen
    awful.key({ modkey }, "F12",
        function () awful.util.spawn("xscreensaver-command -lock")
    end),

    -- shutter as printscreen tools    http://shutter-project.org/
    awful.key({ }, "Print", function () awful.util.spawn("shutter -a -e -n") end),

    -- MacBook Air function keys
    awful.key({ }, "XF86MonBrightnessDown",
        function ()
            awful.util.spawn("xbacklight -dec 10")
        end
    ),
    awful.key({ }, "XF86MonBrightnessUp",
        function ()
            awful.util.spawn("xbacklight -inc 10")
        end
    ),
    awful.key({ }, "XF86LaunchA",
        function ()
            awful.util.spawn("xrandr --output eDP1 --auto --output DP1 --mode 1920x1080_60.00 --left-of eDP1")
        end
    ),
    awful.key({ }, "XF86LaunchB",
        function ()
            awful.util.spawn("xrandr --output eDP1 --auto --output DP1 --mode 1920x1080_60.00 --same-as eDP1")
        end
    ),
    awful.key({ }, "XF86KbdBrightnessDown",
        function ()
            awful.util.spawn("kbdlight down 10")
        end
    ),
    awful.key({ }, "XF86KbdBrightnessUp",
        function ()
            awful.util.spawn("kbdlight up 10")
        end
    ),
    awful.key({ }, "XF86AudioMute",
        function ()
            awful.util.spawn("pactl set-sink-mute 0 toggle")
        end
    ),
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            awful.util.spawn("pactl set-sink-mute 0 false")
            awful.util.spawn("pactl set-sink-volume 0 -5%")
        end
    ),
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            awful.util.spawn("pactl set-sink-mute 0 false")
            awful.util.spawn("pactl set-sink-volume 0 +5%")
        end
   )

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          keys = clientkeys,
          buttons = clientbuttons
     }
    },

    -- Start these clients to the currently focused tag, as floating
    { rule = { class = "MPlayer" },     properties = { floating = true }},
    { rule = { class = "pinentry" },    properties = { floating = true }},
    { rule = { class = "gimp" },        properties = { floating = true }},

    -- Start these clients on specific tag
    { rule = { instance = "rxvt" },
      callback = function(c) awful.client.movetotag(
          tags[mouse.screen][1], c
      ) end
    },
    { rule = { class = "Chromium" },
      callback = function(c) awful.client.movetotag(
          tags[mouse.screen][2], c
      ) end
    },
    { rule = { class = "Firefox" },
      callback = function(c) awful.client.movetotag(
          tags[mouse.screen][3], c
      ) end
    },
    { rule = { class = "Vlc" },
      callback = function(c) awful.client.movetotag(
          tags[mouse.screen][4], c
      ) end
    },
    { rule = { class = "Wicd" },
      callback = function(c) awful.client.movetotag(
          tags[mouse.screen][9], c
      ) end
    },
    { rule = { class = "Pavucontrol" },
      callback = function(c) awful.client.movetotag(
          tags[mouse.screen][9], c
      ) end
    },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus c.opacity = 1 end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal c.opacity = 1 end)
-- }}}

-- vim:set fdm=marker:
