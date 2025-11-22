require 'app/toggle_switch.rb'

class Display_Line
  def initialize args={}
    @x = args.x || 0
    @y = args.y || 0
    @w = args.w || 720
    @h = args.h || 64
    @led_w = args.led_w || 16
    @led_h = args.led_h || 16
    @led_spacing = args.led_spacing || 8
    @segments = args.segments || 5
    @output = []
    @segments.times do |t|
      @output << make_segment(t, {r:128, g:128, b:128})
    end
  end

  def make_segment index, color
    segment_w = @w / @segments
    x = @x + index * segment_w + index * @led_spacing + (segment_w - @led_w) / 2
    y = @y + (@h - @led_h) / 2
    {x:x, y:y, w:@led_w, h:@led_h, path: "sprites/led_gs.png", **color}.sprite!
  end

  def store_state (correct, incorrect, invalid)
    @output = []
    correct.times {|t| @output << make_segment(t, {r:0, g:196, b:0})}
    incorrect.times {|t| @output << make_segment(t + correct, {r:196, g:196, b:0})}
    invalid.times {|t| @output << make_segment(t + correct + incorrect, {r:128, g:128, b:128})}
  end

  def render
    @output
  end
end

def init args
  args.state.switches = []
  (0...5).each do |x|
    args.state.switches << Toggle_Switch.new({x:x*50 + 220,y:640})
  end
  args.state.display = Display_Line.new({x:220, y:900, w:80, h:16})
end

def calculate args
  output = 0
  states = [0,0,0]
  args.state.switches.each_with_index do |s,i|
    if s.status == 1
      states[0] += 1
    else
      states[1] += 1
    end
    if i > 0
      output <<= 1
    end
    output |= s.status
  end
  args.state.display.store_state(states[0],states[1],states[2])
  return output
end

def tick args
  if Kernel.tick_count <= 0
      init args
  end
  args.state.switches.each {|s| s.tick(args)}

  args.outputs.primitives << args.state.switches
  args.outputs.primitives << {x:430, y:800, w:50, h:50, r:0, g:196, b:0,
                              size_enum: 20, text:"#{calculate(args)}"}.label!
  args.outputs.primitives << args.state.display.render
  args.outputs.primitives << {x:500, y:640, w:96, h:96, path:"sprites/button_gs.png", r:255, g:0, b:0}.sprite!
  args.outputs.primitives << {x:300, y:840, w:64, h:96, path:"sprites/7s-64x96.png"}.sprite!
end
