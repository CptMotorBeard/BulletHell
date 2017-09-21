--[[
	Movement Patters define how an enemy moves, it can be broken down into a FNS
	
	speed is how fast the enemy moves, pass and multiply by dt for proper movement
	That is how the enemy moves
	
	Than we need a condition to pass to get to the next step of movement
	There is an x and a y condition, both contain the same values
	position is the new position
	We pass either 'px', 'units' or '%' on whether the new position is a pixel location or a percent of screen location
	'units' is defined as an enemy global and is a multiple of pixels
	Than we pass either 'absolute' or 'relative' to define the scope of the position to the enemy
	
	Finally we need a step to go to if the condition is met
	
	example of movement pattern
	
	Step 1
	{			
		speed = 100,		
		xcondition =
		{
			position = 100,		-- The condition will be true once the enemy moves 100 pixels to the right
			typ = 'relative',
			val = 'px'
		},
		ycondition = nil,		-- There is no y movement so no y condition needs to be passed
		nextstep = 2			-- After either condition is met, move to step 2
	}
	Step 2
	{
		speed = 100,
		xcondition = nil,		-- There is no x condition since there is no x movement
		ycondition =
		{
			position = 10,		-- Now we move 10 units down
			typ = 'relative',
			val = 'units'
		},
		nextstep = 1			-- loop back to step 1
	}
	
	Patterns end if nextstep = -1 or if the movement brings the enemy off screen (in which case they are despawned)
]]--

MovementPatterns =
{
	-- Pattern 1
	{
		{
			speed = 100,
			xcondition =
			{
				position = love.graphics.getWidth() - 100,
				typ = 'relative',
				val = 'px'
			},
			nextstep = -1
		}
	},
	-- Pattern 2
	{
		{
			speed = 100,
			xcondition =
			{
				position = -love.graphics.getWidth() + 100,
				typ = 'relative',
				val = 'px'
			},
			nextstep = -1
		}
	},
	-- Pattern 3
	{
		{
			speed = 100,
			ycondition =
			{
				position = love.graphics.getHeight() / 2,
				typ = 'absolute',
				val = px
			},
			nextstep = -1
		}
	}
}