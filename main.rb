require "io/console"
require_relative "eventbar.rb"

bar = EventBar.new

def enable_mouse_logging
  print "\e[?1000h"  # Enable mouse tracking
  print "\e[?1006h"  # Enable SGR (Select Graphic Rendition) mouse mode
  print "\e[?9h"     # Enable X10 mouse mode
  STDOUT.flush
end

def disable_mouse_logging
  print "\e[?9l"     # Disable X10 mouse mode
  print "\e[?1006l"  # Disable SGR mouse mode
  print "\e[?1000l"  # Disable mouse tracking
  STDOUT.flush
end

enable_mouse_logging

trap "SIGINT" do
  disable_mouse_logging
  exit 130
end

color = {
  :R => 255,
  :G => 255,
  :B => 255,
}
drawer = "@"
inEraser = false
loop do
  # Event bar on the top of the screen
  bar.writeBar("[EasyDraw] Eraser [#{inEraser ? "ON" : "OFF"}] : Color [\e[32;2;#{color[:R]};#{color[:G]};#{color[:B]}m#{drawer}\e[0m] Macros: D (Deleter) | C (Color) | L (Line tool) | B (Box tool) | Q (quit)")
  input = $stdin
  buffer = ""
  while true
    char = input.getch
    buffer << char
    #puts buffer.unpack("H*") # Hexdump of buffer
    case char
      when "d"
        inEraser = !inEraser
        drawer = inEraser ? " " : "@"
        break
      when "c"
        disable_mouse_logging
        bar.getBar("R: ")
        color[:R] = gets.chomp.to_i
        bar.getBar("G: ")
        color[:G] = gets.chomp.to_i
        bar.getBar("B: ")
        color[:B] = gets.chomp.to_i
        enable_mouse_logging
        break
      when 'q'
        disable_mouse_logging
        exit
      when "M" || "m"
        buffer.gsub!(/\e/, "")
        buffer = buffer.split(";")
        #puts "Mode: #{buffer[0].to_i} X: #{buffer[1].to_i} Y: #{buffer[2].to_i}"
        print("\e[#{buffer[2].to_i};#{buffer[1].to_i}H\e[32;2;#{color[:R]};#{color[:G]};#{color[:B]}m#{drawer}\e[0m")
        buffer = ""
        break

    end
    # if char == "M"
    #   buffer.gsub!(/\e/, "")
    #   buffer = buffer.split(";")
    #   #puts "Mode: #{buffer[0].to_i} X: #{buffer[1].to_i} Y: #{buffer[2].to_i}"
    #   print("\e[#{buffer[2].to_i};#{buffer[1].to_i}H\e[32;2;#{color[:R]};#{color[:G]};#{color[:B]}m#{drawer}\e[0m")
    #   buffer = ""
    #   break
    # end
  end
end
