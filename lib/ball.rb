class Ball
    def initialize(win)
        @win = win
        @image = Gosu::Image.new(win, 'media/ball.png', true)
        @radius = 10

        @x = rand(@radius..(win.width - @radius))
        @y = 15
        @vx = 2
        @vy = 3
        scale = 1.7
        @accX = 0.2 * scale
        @decX = 0.3 * scale
        @accY = 0.5 * scale
        @maxVx = 5.0 * scale
        @maxVy = 10.0 * scale

        @jumpVy = 16.0 * scale
        @jumppressed = false
    end

    def draw
        @image.draw(@x-@radius, @y-@radius, 0)
    end

    def move(platforms)
        # 1. Check if buttons are being used to manipulate, account for them.
        playerInput = false
        if Gosu.button_down?(Gosu::KbLeft)
            @vx -= @accX
            playerInput = true
        end

        if Gosu.button_down?(Gosu::KbRight)
            @vx += @accX
            playerInput = true
        end

        if Gosu.button_down?(Gosu::KbSpace) and !@jumppressed
            @jumppressed = true
            @vy = -@jumpVy
        end

        @jumppressed = false if not Gosu.button_down?(Gosu::KbSpace)
            

        # 2a. Update Gravity & constraints
        @vx = @maxVx if @vx > @maxVx
        @vx = -@maxVx if @vx < -@maxVx
        @vy = -@maxVy if @vy < -@maxVy
        @vy += @accY

        # 2b. Apply natural deceleration
        if !playerInput
            @vx += @decX if @vx < 0
            @vx -= @decX if @vx > 0

            # Keep the ball idle if it's moving slower than the deceleration factor
            @vx = 0 if @vx.abs < @decX
        end

        # 3. Compute where the ball *would* land, if updated right now.
        dx = @x + @vx
        dy = @y + @vy

        # cancel move if moving out of the window
        if !dx.between?(0, @win.width) or !dy.between?(0, @win.height)
            @x = @x - @vx
            @y = @y - @vy
            return
        end

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
                coor = plat.verticalCollision?(@x, @y, dx, dy)
                if coor.is_a?(Array)
                    dx = coor[0]
                    dy = coor[1]
                    @vy = -@vy
                    break
                end

                #2b
                coor = plat.horizontalCollision?(@x, @y, dx, dy)
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
        sx = dx - @x   #p4.x - p3.x
        sy = dy - @y   #p4.y - p3.y

        #top
        coor = intersection(0, 0, @win.width, 0, dx, dy, sx, sy) 
        return coor if coor.is_a?(Array)

        #bottom
        return intersection(0, @win.height, @win.width, 0, dx, dy, sx, sy) 
    end

    def leftRightCollision(dx, dy)
        sx = dx - @x   #p4.x - p3.x
        sy = dy - @y   #p4.y - p3.y

        #Left
        coor = intersection(0, 0, 0, @win.height, dx, dy, sx, sy) 
        return coor if coor.is_a?(Array)

        #bottom
        return intersection(@win.width, 0, 0, @win.height, dx, dy, sx, sy) 
    end

    # returns false if no intersection, else the intersection point
    def intersection(x, y, rx, ry, bx, by, sx, sy)
      #Determinant Check (Parallel or collinear)
      return false if (rx * sy) - (sx * ry) == 0
      
      #Paramters:
      # t = ((p1.y-p4.y) * bx) - (by * (p1.x-p4.x)) / ((rx*by) - (bx*ry))
      # u = ((p1.y-p4.y) * rx) - (ry * (p1.x-p4.x)) / ((rx*by) - (bx*ry))
      t = ((y - by) * sx - sy * (x - bx)) / ((rx * sy) - (sx * ry))
      u = ((y - by) * rx - ry * (x - bx)) / ((rx * sy) - (sx * ry))
      
      #Collison check
      return [bx+((u-0.7)*sx), by+((u-0.7)*sy)] if u.between?(0,1) && t.between?(0,1)
      return false
    end
end
