wibox = require "wibox"
markup = require "lain.util.markup"
xresources = require "beautiful.xresources"
dpi = xresources.apply_dpi
theme = require "theme.theme"

clockicon = wibox.widget.textbox "  " 
mytextclock = wibox.widget.textclock markup "#7788af", clockicon.text .. "%A %d %B" .. markup "#ab7367", ">" .. markup "#de5e1e", "%H:%M"
mytextclock.font = theme.font

ClockPanel = (s, offset) ->
	offsetx = 0
	offsety = dpi 12 if offset
	panel = wibox
		ontop: false
		screen: s
		height: dpi 32
		width: dpi 55
		x: s.geometry.width - dpi 202
		y: s.geometry.y + offsety
		stretch: false
		bg: theme.menu_bg_normal
		fg: theme.menu_fg_normal
		struts: top: dpi 32

	panel\setup {
		layout: wibox.layout.fixed.horizontal
		mytextclock
	}

	panel

{:clockicon,:mytextclock}
