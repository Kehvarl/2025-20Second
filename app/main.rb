require 'app/toggle_switch.rb'

def init args
  args.state.switch = Toggle_Switch.new({x:360,y:640})
end

def tick args
  if Kernel.tick_count <= 0
      init args
  end
  args.state.switch.tick args

  args.outputs.primitives << args.state.switch
end
