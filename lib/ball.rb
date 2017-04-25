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
        @maxSpeed = 30
        @image = Gosu::Image.new(win, 'media/ball.png', true)
    end

    def draw
        @image.draw_rot(@x, @y, 0, 0)
    end

    def move(platforms)
        # 1. Check if buttons are being used to manipulate, account for them.
        @vx -= 0.75 if Gosu.button_down?(Gosu::KbLeft) && @vx.abs < @maxSpeed
        @vx += 0.75 if Gosu.button_down?(Gosu::KbRight) && @vx.abs < @maxSpeed
        @vy *= 1.25 if Gosu.button_down?(Gosu::KbDown) && @vy.abs < @maxSpeed

        # 2. Update Gravity
        # TODO make this multiplicative instead of additive.
        @vy += @gravity if @vy.abs < @maxSpeed

        # 3. Compute where the ball *would* land, if updated right now.
        dX = @x + @vx
        dY = @y + @vy

        # 4. Perform the collision detection.
        #       If no collision, update as normal
        #       If collision, set x & y to the collision point and:
        #           If it was a collision with a vertical (top/bot of level or rectangle), invert vy
        #           else (it was horizontal), invert vx

        # 5. done.


        # Check for collision with platforms
        # collision_check(platforms)

        # # TODO this is flat out redundant and double modify's the ball's Y. 
        # #   Remove or adjust in accordance with collision check.
        # # Check for collision with bottom of window
        # if (@y + @vy) >= (@win.height - @radius)
        #     # place ball on bottom of window
        #     @y = (@win.height - @radius)
        # else
        #     # continue building speed
        #     @y += @vy
        # end
    end

    # TODO:
    #   1) The bottom wall check is being done here and in the move function. Remove this redundancy.
    #   2) The platform detection shouldn't rely on which side or if the ball is within the box. That's just wrong.
    #       Instead compute the destination of the ball. Check if any platforms intersect the path between current
    #       ball position and this destination. If so, a collision would occur and you would set the ball to be on 
    #       the clostest face of the platform, reversing it's direction. (there's some specifics in there to work on)
    def collision_check(platforms)
        #=== ROOM EDGE DETECTION ===#
        if hit_right_wall
            @x = (@win.width - @radius)
            @vx = change_direction(@vx)
        elsif hit_left_wall
            @x = @radius
            @vx = change_direction(@vx)
        elsif hit_top
            @y = @radius
            giveFriction
            @vy = change_direction(@vy)
        elsif hit_bottom
            @y = (@win.height - @radius)
            giveFriction
            @vy = change_direction(@vy)
        end

        #=== PLATFORM DETECTION ===#
        platforms.each do |item|
            if item.hitTop?(self)
                @y = item.getY - @radius
                hitVertical
            elsif item.hitBot?(self)
                @y = item.getMaxY + @radius
                hitVertical
            elsif item.hitLeft?(self)
                @x = item.getX - @radius
                @vx = change_direction(@vx)
            elsif item.hitRight?(self)
                @x = item.getMaxX + @radius
                @vx = change_direction(@vx)
            end
        end
    end # END OF COLLISION_CHECK

    def hitVertical
        giveFriction
        @vy *= @frictionY
        @vy = change_direction(@vy)
    end

    #=== // READABILITY METHODS // ===#
    # TODO this should just change direction and nothing else. If velocity is to be impacted, do it from the caller.
    def change_direction(direction)
        return direction *= -0.85
    end

    def giveFriction
        @vx *= @friction
    end

    def hit_right_wall
        @x >= @win.width - @radius
    end

    def hit_left_wall
        @x <= @radius
    end

    def hit_bottom
        @y >= @win.height - @radius
    end

    def hit_top
        @y <= @radius
    end

    def getX
        @x
    end

    def getY
        @y
    end

    def getRadius
        @radius
    end
end
