class Ball
  def initialize(win)
    @d = 20
    @radius = @d/2
    @win = win
    @gravity = 0.5
    @friction = 0.98
    @frictionY = 0.98
    @heightGain = 1.125
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
    collision_check(platforms)
      
		@x += @vx
		
		if @vy.abs <= @maxSpeed
      @vy += @gravity
		#else
		#	@vy = @maxSpeed
		end
			
    if (@y + @vy) >= (@win.height - @radius)
      @y = (@win.height - @radius)
    else
      @y += @vy
    end

    if Gosu::button_down? Gosu::KbLeft
			if(@vx.abs <= @maxSpeed)
				@vx -= 0.75
			end
    end

    if Gosu::button_down? Gosu::KbRight
			if(@vx.abs <= @maxSpeed)
				@vx += 0.75
			end
    end

    if (Gosu::button_down? Gosu::KbUp)
      @vy -= @heightGain
      @heightGain = 1.125
      if @gravity == 0
        toggleGrav(true)
      end
    end

    if Gosu::button_down? Gosu::KbDown
      @vy *= 0.5
    end

    puts "Vy #{@vy} Vx #{@vx}" #DEBUG LINE
  end

	
	
  def collision_check(platforms)
    if hit_right_wall
      @x = (@win.width - @radius)
      horizontal_bounce
    end

    if hit_left_wall
      @x = @radius
      horizontal_bounce
    end

    if hit_bottom
      sitStill(@win.height)
      giveFriction
      vertical_bounce
    end

    if hit_top
      @y = @radius
      vertical_bounce
      @vy -= @gravity #CHECK THIS LINE HERE
    end

    #=== PLATFORM DETECTION ===#
    platforms.each{|item| item.stay_on_platform?(self)}

    platforms.each{|item|
      if item.hitTop?(self)
        @y = item.getY - @radius
        hitVertical
      elsif item.hitBot?(self)
        @y = item.getMaxY + @radius
        hitVertical
      elsif item.hitLeft?(self)
        @x = item.getX - @radius
        horizontal_bounce
      elsif item.hitRight?(self)
        @x = item.getMaxX + @radius
        horizontal_bounce
      end
    }

  end # END OF COLLISION_CHECK

  def hitVertical
    giveFriction
    giveYFriction
    vertical_bounce
  end

  def toggleGrav(x)
    if x
      @gravity = 1
    else
      @gravity = 0
    end
  end

  def sitStill(platform_height)
    if @vy.abs <= 1 && @vy != 0
      toggleGrav(false)
      @y = (platform_height - @radius)
      @vy = 0
      @heightGain = 3
    end
  end

#=== // READABILITY METHODS // ===#
  def horizontal_bounce
     @vx *= -1
  end

  def vertical_bounce
     @vy *= -1
  end

  def giveFriction
    @vx *= @friction
  end

  def giveYFriction
    @vy *= @frictionY
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
