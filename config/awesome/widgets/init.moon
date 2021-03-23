lain = require "lain"
awful = require "awful"
wibox = require "wibox"
xres = require "beautiful.xresources"
dpi = xres.apply_dpi
gears = require "gears"

theme = require "theme.theme"
colors = require "theme.colors"
clock = require "widgets.clock"

markup = lain.util.markup

os.setlocale(os.getenv("LANG"))

awful = require "awful"
require "keys"

tagbuttons = gears.table.join(
  awful.button({}, 1, awful.tag.viewonly)
  awful.button({modkey}, 1, awful.client.movetotag)
  awful.button({}, 3, awful.tag.viewtoggle)
)

taskbuttons = gears.table.join(
  awful.button({}, 1, (c) ->
    c.minimized = c == client.focus
    unless c == client.focus
      unless c\isvisible!
        awful.tag.viewonly c.first_tag
      client.focus = c
      c\raise!)

  awful.button({}, 2, (c) ->
    c\kill)
  awful.button({}, 3,  ->
    instance = nil
    if instance and instance.wibox.visible
      instance\hide!
      instance = nil
    else
      instance = awful.menu.clients theme: width: 250)

  awful.button({}, 4, -> awful.client.focus.byidx 1)
  awful.button({}, 5, -> awful.client.focus.byidx -1)
)


--- top wibar Widgets

-- Calendar
cal = lain.widget.cal {
  attach_to: mytextclock
  notification_preset: 
    font: "Terminus 10"
    fg: theme.fg_normal
    bg: theme.bg_normal
}

-- weather widget
weathericon = wibox.widget.imagebox theme.widget_weather
weather = lain.widget.weather({
  city_id: 3447212
  notification_preset: {
    font: "Terminus 10",
    fg: theme.fg_nomal
  }
  weather_na_markup: markup.fontfg theme.font, "#eca4c4", "N/A"
  settings: ->
    desc = weather_now["weather"][1]["description"]\lower!
    units = math.floor weather_now["main"]["temp"]
    widget\set_markup markup.fontfg theme.font, "#eca4c4", desc .. " @ " .. units .. "ºC"})

-- Alsa volume
volicon = wibox.widget.textbox " "
volume = lain.widget.alsa {
  settings: ->
    volume_now.level = volume_now.level .. "M" if volume_now.status == "off"

    widget\set_markup markup.fontfg theme.font, colors.indigo, volicon.text .. volume_now.level .. "%"
}

-- Net
neticons = 
  netdown: wibox.widget
    markup: markup.fontfg theme.font, colors.green, "<b>  </b>"
    widget: wibox.widget.textbox
  netup: wibox.widget
    markup: markup.fontfg theme.font, colors.red, "<b>  </b>"
    widget: wibox.widget.textbox

netdowninfo = wibox.widget.textbox!
netupinfo = lain.widget.net {
  settings: ->
    if iface ~= "network off" and string.match weather.widget.text, "N/A"
      weather.update!

    widget\set_markup markup.fontfg theme.font, colors.red, net_now.sent .. " "
    netdowninfo\set_markup markup.fontfg theme.font, colors.green, net_now.received .. " "
}

-- mem widget
memicon = wibox.widget 
  markup: markup.fontfg theme.font, colors.yellow, "<b> </b>"
  widget: wibox.widget.textbox

meminfo = lain.widget.mem {
  settings: ->
    widget\set_markup markup.fontfg theme.font, colors.yellow, mem_now.used .. "M "
}

-- cpu widget
cpuicon = wibox.widget
  markup: markup.fontfg theme.font, colors.pink, "<b> </b>"
  widget: wibox.widget.textbox

cpu = lain.widget.cpu
	settings: ->
	  widget\set_markup markup.fontfg theme.font, colors.pink, cpu_now.usage .. "% "

-- cpu temp widget
tempicon = wibox.widget.textbox ""
temp = lain.widget.temp
	settings: ->
	  widget\set_markup markup.fontfg theme.font, colors.orange, "" .. coretemp_now .. "ºC"

at_screen_connect = =>
		
		wallpaper = theme.wallpaper
		if type(wallaper) == "function"
		  wallpaper = wallpaper(@)

		gears.wallpaper.maximized(wallpaper, @, true)

		@mypromptbox = awful.widget.prompt!

		@mylayoutbox = with awful.widget.layoutbox(s)
		  \buttons gears.table.join(
		    awful.button({}, 1, -> awful.layout.inc 1)
		    awful.button({}, 3, -> awful.layout.inc -1))

		@mytaglist = awful.widget.taglist {
		  screen: @
		  filter: awful.widget.taglist.filter.all
		  buttons: tagbuttons
		}

		@mytasklist = awful.widget.tasklist {
		  screen: @
		  filter: awful.widget.tasklist.filter.currenttags
		  buttons: taskbuttons
		}

		with awful.wibar
		    position: "top"
		    screen: @
		    height: dpi 25
		  \setup {
		    layout: wibox.layout.align.horizontal
		    {
		      layout: wibox.layout.fixed.horizontal
		      @mytaglist
		      @mypromptbox
		    },
		    --@mytasklist,
		    nil,
		    {
		      layout: wibox.layout.fixed.horizontal
		      wibox.widget.systray!
		      neticons.netdown
		      netdowninfo
		      neticons.netup
		      netupinfo.widget
		      volume.widget
		      memicon
		      meminfo.widget
		      cpuicon
		      cpu.widget
		      temp.widget
		      clock.mytextclock
		      }
		  }

		with awful.wibar
		    position: "bottom"
		    screen: @
		    height: dpi 20
		  \setup {
		    layout: wibox.layout.align.horizontal
		    {
		      layout: wibox.layout.align.horizontal
		    }
		    @mytasklist
		    {
		      layout: wibox.layout.fixed.horizontal
		      @mylayoutbox
		    }
		  }


{
  :at_screen_connect 
  weather:
    :weather
    :weather_icon
  cpu_usage:
    :cpu
    :cpuicon
  cpu_temp:
    :temp
    :temp_icon
}