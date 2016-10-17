class Rectangle
  def initialize(win, x, y, width, height)
    @win = win
    @x = x
    @y = y
    @width = width
    @height = height
  end

  def draw
      @win.draw_quad(
        @x, @y, Gosu::Color::WHITE,
        @x+@width, @y, Gosu::Color::WHITE,
        @x, @y+@height, Gosu::Color::WHITE,
        @x+@width, @y+@height, Gosu::Color::WHITE,
      )
  end

  def update
  end

  def hitTop?(ball)
    #check the top
    @hitTop = ((ball.getY+ball.getRadius >= @y) &&
              (ball.getY+ball.getRadius <= @y+@height)) &&
              ((ball.getX >= @x) && (ball.getX <= @x+@width))
  end
  
  def hitBot?(ball)
    #check the bottom
    @hitBot = ((ball.getY-ball.getRadius >= @y) &&
              (ball.getY-ball.getRadius <= @y+@height)) &&
  					((ball.getX+ball.getRadius >= @x) && 
  					(ball.getX-ball.getRadius <= @x+@width))
  end
  
  def hitLeft?(ball)
    #check the left
    @hitLeft = ((ball.getY >= @y) && (ball.getY <= @y+@height)) &&
               ((ball.getX+ball.getRadius >= @x) &&
               (ball.getX+ball.getRadius <= @x+@width))
  end
  
  def hitRight?(ball)
    #check the right
    @hitRight = ((ball.getY >= @y) && (ball.getY <= @y+@height)) &&
                ((ball.getX-ball.getRadius >= @x) &&
                (ball.getX-ball.getRadius <= @x+@width))
  end

  def getMaxX
    @x + @width
  end

  def getMaxY
    @y + @height
  end

  def getY
    @y
  end

  def getX
    @x
  end

end
