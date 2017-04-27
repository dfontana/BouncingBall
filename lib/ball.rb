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
        dX = @x + @vx
        dY = @y + @vy

        # 4. Perform the collision detection.
        #       1) Look for collision with level walls
        #           a) Check Left & Right; true? update dx,dy to collision point -> invert Vx -> break to update/return
        #           b) Check Top & Bottom; true? update dx,dy to collision point -> invert Vy -> break to update/return
        #       2) Look for first instance of collision in each platform:
        #           a) Check Left & Right; true? update dX,dY -> invert Vx -> break to update/return
        #           b) Check Top & Bottom; true? update dX,dY -> invery Vy -> break to update/return
        #       3) Update based on dX and dY (no need to return).
        platforms.each do |plat|
            coor = plat.topCollision?(self, dX, dY)
            if coor.is_a?(Array)
                # Collided, set the new destination to collision
                puts "Collision Top"
                # Invert the correct velocity
                break
            end
            coor = plat.bottomCollision?(self, dX, dY)
            if coor.is_a?(Array)
                # Collided, set the new destination to collision
                puts "Collision bottom"
                # Invert the correct velocity
                break
            end
            coor = plat.leftCollision?(self, dX, dY)
            if coor.is_a?(Array)
                # Collided, set the new destination to collision
                puts "Collision Left"
                # Invert the correct velocity
                break
            end
            coor = plat.rightCollision?(self, dX, dY)
            if coor.is_a?(Array)
                # Collided, set the new destination to collision
                puts "Collision Right"
                # Invert the correct velocity
                break
            end
        end

        @x = dX
        @y = dY
    end

    def getX
        @x
    end

    def getY
        @y
    end
end
