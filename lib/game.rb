class Game < Gosu::Window
  def initialize
    @width = 1920
    @height = 1080
    super @width, @height, false
    @ball = Ball.new(self)
    @platforms = [Rectangle.new(self, 200, 200, 200, 200),
                  Rectangle.new(self, 1520, 200, 200, 200),
                  Rectangle.new(self, 300, 400, 300, 100),
                  Rectangle.new(self, 1320, 400, 300, 100),
                  Rectangle.new(self, 840, 650, 240, 130),
                  Rectangle.new(self, 300, 880, 300, 100),
                  Rectangle.new(self, 0, 930, 300, 100),
                  Rectangle.new(self, 1320, 880, 300, 100),
                  Rectangle.new(self, 1620, 930, 300, 100)]
  end

  def update
    @ball.move(@platforms)
  end

  def draw
    @ball.draw
    @platforms.each{|item| item.draw}
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end
