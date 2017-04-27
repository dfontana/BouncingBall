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
    def horizontalCollision?(ball, dx, dy)
      bx = dx - ball.getX   #p4.x - p3.x
      by = dy - ball.getY   #p4.y - p3.y

      #left
      coor = intersection(@x, @y, 0, @height, bx, by, dx, dy)
      return coor if coor.is_a?(Array)

      #right
      return intersection(@x+@width, @y, 0, @height, bx, by, dx, dy)
    end

    def verticalCollision?(ball, dx, dy)
      bx = dx - ball.getX   #p4.x - p3.x
      by = dy - ball.getY   #p4.y - p3.y

      #top
      coor = intersection(@x, @y, @width, 0, bx, by, dx, dy)
      return coor if coor.is_a?(Array)
      
      # bottom
      return intersection(@x+@height, @y, @width, 0, bx, by, dx, dy)
    end

    def intersection(x, y,rx, ry, bx, by, dx, dy)
      #Determinant Check (Parallel or collinear)
      return 0 if (rx * by) - (bx * ry) == 0
      
      #Paramters:
      # t = ((p1.y-p4.y) * bx) - (by * (p1.x-p4.x)) / ((rx*by) - (bx*ry))
      # u = ((p1.y-p4.y) * rx) - (ry * (p1.x-p4.x)) / ((rx*by) - (bx*ry))
      t = ((y - dy) * bx - by * (x - dx)) / ((rx * by) - (bx * ry))
      u = ((y - dy) * rx - ry * (x - dx)) / ((rx * by) - (bx * ry))
      
      #Collison check
      return [x+(t*rx), y+(t*ry)] if u.between?(0,1) && t.between?(0,1)
      return 0
    end
  end
  
