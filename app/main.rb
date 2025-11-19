require 'app/toggle_switch.rb'

def init args
  args.state.switches = []
  (0...5).each do |x|
    args.state.switches << Toggle_Switch.new({x:x*50 + 220,y:640})
  end
end

def calculate args
  output = 0
  args.state.switches.each_with_index do |s,i|
    output |= s.status
    if i < 4
      output = output << 1
    end
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
end
