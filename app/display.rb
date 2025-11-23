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

class Display
    def initialize
        @x = 110
        @y = 400
        @w = 500
        @h = 380
        @lines = []
    end

    def render
        out = []
        out << {x:@x, y:@y, w:@w, h:@h. r:128, g:128, b:128}.solid!
        out << {x:@x, y:@y, w:@w, h:@h. r:192, g:192, b:192}.border!
        @lines.each do |l|
            out << l.render()
        end

        out
    end
end
