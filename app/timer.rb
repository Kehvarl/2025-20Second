class Timer
    attr_accessor ended
    def initialize args={}
        @count_to = Time.now + (args.length || 20.0)
        @ended = false
    end

    def tick args
        timer = @count_to - Time.now
        if timer <= 0.00
            timer = 0.00
            @ended = true
        end
        color = {r:0, g:196, b:0}
    end

    def render
        out = []
        out
    end
end
