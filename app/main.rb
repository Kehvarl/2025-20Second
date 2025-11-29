require 'app/switch.rb'
require 'app/display.rb'

def init args
  args.state.game_over = false
  args.state.won = false
  args.state.switches = []
  (0...5).each do |x|
    args.state.switches << Toggle_Switch.new({x:x*50 + 220,y:640, w:48, h:96})
  end
  args.state.button = Pushbutton.new({x:500, y:640, w:96, h:96, source_w:64, source_h:32})
  args.state.display = Display.new()
  args.state.count_to = Time.now + 20.0

  args.state.target = rand(32)
end

def calculate args
  output = 0
  states = [0,0,0]

  args.state.switches.each_with_index do |s,i|
    expected = (args.state.target >> (args.state.switches.length - 1 - i)) & 1
    if s.status == expected
      states[0] += 1
    else
      states[2] += 1
    end
    if i > 0
      output <<= 1
    end
    output |= s.status
  end
  if args.inputs.keyboard.key_up.enter or args.state.button.status
    args.state.display.add_line(states)
    args.state.button.status = false
    if output == args.state.target
      args.state.won = true
    end
  end
  return output
end

def get_timer args
  timer = args.state.count_to - Time.now
  if timer <= 0.00
    timer = 0.00
    args.state.game_over = true
  end
  color = {r:0, g:196, b:0}
  case timer
  when 5.0 .. 10.0
      color = {r:196, g:196, b:0}
  when 0.0 .. 5.0
      color = {r:196, g:0, b:0}
  end
  if args.state.won
      color = {r:0, g:196, b:255}
  end

  return color, ("%.2f" % timer)
end

def game_over_tick args
    args.outputs.primitives << {x:0, y:0, w:720, h:1280, r:0, g:0, b:0}.solid!
    args.outputs.primitives << {x:280, y:800, w:50, h:50, r:0, g:196, b:0, size_enum: 30, text:"GAME"}.label!
    args.outputs.primitives << {x:280, y:700, w:50, h:50, r:0, g:196, b:0, size_enum: 30, text:"OVER"}.label!
    if not args.state.won
      args.outputs.primitives << {x:255, y:600, w:50, h:50, r:255, g:196, b:0, size_enum: 16, text:"You Lose!"}.label!
    else
      args.outputs.primitives << {x:255, y:600, w:50, h:50, r:255, g:196, b:0, size_enum: 16, text:"You Won!"}.label!
    end

end

def tick args
  if Kernel.tick_count <= 0
      init args
  end
  if args.state.game_over
    game_over_tick(args)
    return
  end

  args.state.switches.each {|s| s.tick(args)}
  args.state.button.tick(args)

  if args.state.button.status > 0
      calculate(args)
      args.state.button.status = 0
  end

  args.outputs.primitives << {x:0, y:0, w:720, h:1280, r:0, g:0, b:0}.solid!
  args.outputs.primitives << args.state.switches
  color, time = get_timer(args)
  args.outputs.primitives << {x:430, y:800, w:50, h:50, **color, size_enum: 20, text:"#{time}"}.label!
  args.outputs.primitives << args.state.display.render
  args.outputs.primitives << args.state.button
  args.outputs.primitives << {x:300, y:840, w:64, h:96, path:"sprites/7s-64x96.png"}.sprite!
end
