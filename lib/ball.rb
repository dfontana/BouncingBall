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
        # Check for collision with platforms
        collision_check(platforms)

        # Check for collision with bottom of window
        if (@y + @vy) >= (@win.height - @radius)
            # place ball on bottom of window
            @y = (@win.height - @radius)
        else
            # continue building speed
            @y += @vy
        end

        # Button Controls
        if Gosu.button_down? Gosu::KbLeft
            @vx -= 0.75 if @vx.abs < @maxSpeed
        end

        if Gosu.button_down? Gosu::KbRight
            @vx += 0.75 if @vx.abs < @maxSpeed
        end

        @vy *= 1.25 if Gosu.button_down?(Gosu::KbDown) && @vy.abs < @maxSpeed

        # Natural velocity gains
        @vy += @gravity if @vy.abs < @maxSpeed
        @x += @vx
    end

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
