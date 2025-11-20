require 'app/toggle_switch.rb'

class Display_Line
  def initialize args={}
    @x = args.x || 0
    @y = args.y || 0
    @w = args.w || 720
    @h = args.h || 64
    @segments = args.segments || 5
    @output = []
    @segments.times do |t|
      puts t
      @output << make_segment(t, {r:128, g:128, b:128})
    end
  end

  def make_segment index, color
    w = @w / @segments
    {x:index*w+@x, y:@y, w:w, h:@h, **color}.solid!
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
  args.state.display = Display_Line.new({x:220, y:900, w:280, h:64})
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
end
