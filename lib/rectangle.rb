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

  # Returns 0 if no collision, or (X,Y) where collision will occur
  # TODO need to check all 4 faces of rectangle. 
  #   - Break into 4 methods, one per face. 
  #   - (Set the rx / ry / bx / by in each and then call shared method & return it's value .)
  def willCollide?(ball, dx, dy)
    #Vectors:
    rx = @width 
    ry = @height
    bx = dx - ball.getX
    by = dy - ball.getY 

    #Determinant Check (Parallel or collinear)
    return 0 if (rx * by) - (bx * ry) == 0

    #Paramters:
    t = ((@y - dy) * bx - by * (x - dx)) / ((rx * by) - (bx * ry))
    u = ((@y - dy) * rx - ry * (x - dx)) / ((rx * by) - (bx * ry))

    #Collison check
    return [x+(t*rx), y+(t*ry)] if u.between?(0,1) && t.between?(0,1)
    return 0
  end
end
