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
      t = ((@y - dy) * bx - by * (@x - dx)) / ((rx * by) - (bx * ry))
      u = ((@y - dy) * rx - ry * (@x - dx)) / ((rx * by) - (bx * ry))
      
      #Collison check
      return [@x+(t*rx), @y+(t*ry)] if u.between?(0,1) && t.between?(0,1)
      return 0
    end
    
    def topCollision?(ball, dx, dy)
      #Vectors:
      rx = @width           #p2.x - p1.x
      ry = 0                #p2.y - p1.y
      bx = dx - ball.getX   #p4.x - p3.x
      by = dy - ball.getY   #p4.y - p3.y
      p1 = {'x' => @x, 'y' => @y}

      return intersection(rx, ry, bx, by, p1, dx, dy)
    end
    
    def bottomCollision?(ball, dx, dy)
      #Vectors:
      rx = @width           #p2.x - p1.x
      ry = 0                #p2.y - p1.y
      bx = dx - ball.getX   #p4.x - p3.x
      by = dy - ball.getY   #p4.y - p3.y
      p1 = {'x' => @x+@height, 'y' => @y}
      
      return intersection(rx, ry, bx, by, p1, dx, dy)
    end

    def leftCollision?(ball, dx, dy)
      #Vectors:
      rx = 0                #p2.x - p1.x
      ry = @height          #p2.y - p1.y
      bx = dx - ball.getX   #p4.x - p3.x
      by = dy - ball.getY   #p4.y - p3.y
      p1 = {'x' => @x, 'y' => @y}
      
      return intersection(rx, ry, bx, by, p1, dx, dy)
    end

    def rightCollision?(ball, dx, dy)
      #Vectors:
      rx = 0                #p2.x - p1.x
      ry = @height          #p2.y - p1.y
      bx = dx - ball.getX   #p4.x - p3.x
      by = dy - ball.getY   #p4.y - p3.y
      p1 = {'x' => @x+@width, 'y' => @y}
      
      return intersection(rx, ry, bx, by, p1, dx, dy)
    end

    def intersection(rx, ry, bx, by, p1, dx, dy)
      #Determinant Check (Parallel or collinear)
      return 0 if (rx * by) - (bx * ry) == 0
      
      #Paramters:
      # t = ((p1.y-p4.y) * bx) - (by * (p1.x-p4.x)) / ((rx*by) - (bx*ry))
      # u = ((p1.y-p4.y) * rx) - (ry * (p1.x-p4.x)) / ((rx*by) - (bx*ry))
      t = ((p1['y'] - dy) * bx - by * (p1['x'] - dx)) / ((rx * by) - (bx * ry))
      u = ((p1['y'] - dy) * rx - ry * (p1['x'] - dx)) / ((rx * by) - (bx * ry))
      
      #Collison check
      return [p1['x']+(t*rx), p1['y']+(t*ry)] if u.between?(0,1) && t.between?(0,1)
      return 0
    end
  end
  
