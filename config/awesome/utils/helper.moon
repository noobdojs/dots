import shape from require "gears"
import spawn from require "awful"

rrect = (radius) ->
  return (cr, width, height)->
    shape.rounded_rect(cr,width,height, radius)

partial_rrect = (size, direction) ->
  if direction == 'ltr'
    return (cr, width, height) ->
      shape.partially_rounded_rect cr, width, height, true, false, true, false, size
  else
    return (cr, width, height) ->
      shape.partially_rounded_rect cr, width, height, size

colorize_text = (text,color) ->
  return "<span foreground='"..color.."'>"..text.."</span>"

volume_control = (step) ->
  local cmd
  if step == 0
    cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
  else
    sign = step > 0 and "+" or ""
    cmd = "pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ "..sign..tostring step.."%"
  spawn.with_shell cmd

set_volume = (level) ->
  local cmd
  if level == 0
    cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
  else
    cmd =  "pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ "..tostring level.."%"
  spawn.with_shell cmd

set_wallpaper_symlink = (img) ->
  cmd = "ln -sf "..img.." ~/.config/awesome/theme/wall.jpg"
  spawn.with_shell cmd

add_hover_cursor = (w, hover_cursor) ->
  original_cursor = "left_ptr"

  w\connect_signal "mouse::enter", () ->
    local w
    w = mouse.current_wibox
    if w
      w.cursor = hover_cursor

  w\connect_signal "mouse::leave", () ->
    local w
    w = mouse.current_wibox
    if w
      w.cursor = original_cursor

{
  :colorize_text
  :partial_rrect, :rrect
  :volume_control, :set_volume
  :add_hover_cursor
  :set_wallpaper_symlink
}
