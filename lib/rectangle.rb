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

    def verticalCollision?(bx, by, dx, dy)
      sx = dx - bx   #p4.x - p3.x
      sy = dy - by   #p4.y - p3.y

      #top
      coor = intersection(@x, @y, @width, 0, bx, by, sx, sy)
      return coor if coor.is_a?(Array)
      
      # bottom
      return intersection(@x, @y+@height, @width, 0, bx, by, sx, sy)
    end

    # Returns 0 if no collision, or (X,Y) where collision will occur
    def horizontalCollision?(bx, by, dx, dy)
      sx = dx - bx   #p4.x - p3.x
      sy = dy - by   #p4.y - p3.y

      #left
      coor = intersection(@x, @y, 0, @height, bx, by, sx, sy)
      return coor if coor.is_a?(Array)

      #right
      return intersection(@x+@width, @y, 0, @height, bx, by, sx, sy)
    end

    def intersection(x, y, rx, ry, bx, by, sx, sy)
      #Determinant Check (Parallel or collinear)
      return 0 if (rx * sy) - (sx * ry) == 0
      
      #Paramters:
      # t = ((p1.y-p4.y) * sx) - (sy * (p1.x-p4.x)) / ((rx*sy) - (sx*ry))
      # u = ((p1.y-p4.y) * rx) - (ry * (p1.x-p4.x)) / ((rx*sy) - (sx*ry))
      t = ((y - by) * sx - sy * (x - bx)) / ((rx * sy) - (sx * ry))
      u = ((y - by) * rx - ry * (x - bx)) / ((rx * sy) - (sx * ry))
      
      #Collison check
      return [bx+((u-0.7)*sx), by+((u-0.7)*sy)] if u.between?(0,1) && t.between?(0,1)
      return false
    end
  end
  
