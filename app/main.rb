require 'app/toggle_switch.rb'
require 'app/display.rb'

def init args
  args.state.switches = []
  (0...5).each do |x|
    args.state.switches << Toggle_Switch.new({x:x*50 + 220,y:640})
  end
  args.state.display = Display.new()
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
  if args.inputs.keyboard.key_up.enter
    args.state.display.add_line(states)
  end
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
