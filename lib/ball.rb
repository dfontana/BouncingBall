class Ball
    def initialize(win)
        @d = 20
        @radius = @d / 2
        @win = win
        @gravity = 1.25
        @friction = 0.98
        @frictionY = 0.85
        @x = rand(@radius..(win.width - @radius))
        @y = rand(@radius..(win.height - @radius) * 0.5)
        @vx = 2
        @vy = 3
        @maxSpeed = 15
        @image = Gosu::Image.new(win, 'media/ball.png', true)
    end

    def draw
        @image.draw_rot(@x, @y, 0, 0)
    end

    # TODO: reimplement friction / energy loss per update
    # Options:
    #   -> Decay Vx and Vy each update by a set amount (additive) or percentage (multiplicative)
    #   -> Introduce friction on collision (when colliding, reduce Vx and Vy for next update by percentage)
    #   -> Decrease/Increase Vx and Vy as a factor of height + gravity (higher height = lower vy)
    #   -> A combination of the above
    def move(platforms)
        # 1. Check if buttons are being used to manipulate, account for them.
        @vx -= 0.75 if Gosu.button_down?(Gosu::KbLeft) && @vx.abs < @maxSpeed
        @vx += 0.75 if Gosu.button_down?(Gosu::KbRight) && @vx.abs < @maxSpeed
        @vy *= 1.25 if Gosu.button_down?(Gosu::KbDown) && @vy.abs < @maxSpeed

        # 2. Update Gravity
        # TODO make this multiplicative instead of additive.
        @vy += @gravity if @vy.abs < @maxSpeed

        # 3. Compute where the ball *would* land, if updated right now.
        dx = @x + @vx
        dy = @y + @vy

        # 4. Perform the collision detection.
        #       1) Look for collision with level walls
        #           a) Check Top & Bottom; true? update dx,dy to collision point -> invert Vy -> break to update/return
        #           b) Check Left & Right; true? update dx,dy to collision point -> invert Vx -> break to update/return
        #       2) Look for first instance of collision in each platform:
        #           a) Check Top & Bottom; true? update dx,dy -> invery Vy -> break to update/return
        #           b) Check Left & Right; true? update dx,dy -> invert Vx -> break to update/return
        #       3) Update based on dx and dy (no need to return).

        #1a
        coor = topBottomCollision(dx, dy)
        if coor
            dx = coor[0]
            dy = coor[1]
            @vy = -@vy
        end

        #1b
        if !coor    
            coor = leftRightCollision(dx, dy)
            if coor
                dx = coor[0]
                dy = coor[1]
                @vx = -@vx
            end
        end
        
        if !coor
            platforms.each do |plat|
                #2a
                coor = plat.verticalCollision?(self, dx, dy)
                if coor.is_a?(Array)
                    dx = coor[0]
                    dy = coor[1]
                    @vy = -@vy
                    break
                end

                #2b
                coor = plat.horizontalCollision?(self, dx, dy)
                if coor.is_a?(Array)
                    dx = coor[0]
                    dy = coor[1]
                    @vx = -@vx
                    break
                end
            end
        end
        

        #3
        @x = dx
        @y = dy
    end

    def topBottomCollision(dx, dy)
        bx = dx - @x   #p4.x - p3.x
        by = dy - @y   #p4.y - p3.y

        #top
        coor = intersection(0, 0, @win.width, 0, bx, by, dx, dy) 
        return coor if coor.is_a?(Array)

        #bottom
        return intersection(0, @win.height, @win.width, 0, bx, by, dx, dy) 
    end

    def leftRightCollision(dx, dy)
        bx = dx - @x   #p4.x - p3.x
        by = dy - @y   #p4.y - p3.y

        #Left
        coor = intersection(0, 0, 0, @win.height, bx, by, dx, dy) 
        return coor if coor.is_a?(Array)

        #bottom
        return intersection(@win.width, 0, 0, @win.height, bx, by, dx, dy) 
    end

    # returns false if no intersection, else the intersection point
    def intersection(x, y, rx, ry, bx, by, dx, dy)
      #Determinant Check (Parallel or collinear)
      return false if (rx * by) - (bx * ry) == 0
      
      #Paramters:
      # t = ((p1.y-p4.y) * bx) - (by * (p1.x-p4.x)) / ((rx*by) - (bx*ry))
      # u = ((p1.y-p4.y) * rx) - (ry * (p1.x-p4.x)) / ((rx*by) - (bx*ry))
      t = ((y - dy) * bx - by * (x - dx)) / ((rx * by) - (bx * ry))
      u = ((y - dy) * rx - ry * (x - dx)) / ((rx * by) - (bx * ry))
      
      #Collison check
      return [x+(t*rx), y+(t*ry)] if u.between?(0,1) && t.between?(0,1)
      return false
    end

    def getX
        @x
    end

    def getY
        @y
    end
end
