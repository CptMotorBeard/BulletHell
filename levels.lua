--[[
	Levels is split up into each stage
	Each stage has several parts, which is defined by the enemies in those parts
	We define the number of rounds for each stage, after all rounds are done, we move into the next stage
	
	Levels =
	{
		-- Level 1
		{
			delay = Delay before the next level starts (defaults to 0.5)
			numRounds, = -- However many rounds there are inside of Enemies
			Enemies =
			{
				-- Each item inside of this list is a new round. Fill with a list of new Enemy objects
			}
		}
		-- Level 2
		{} -- Fill similiarily
		-- Level 3 and so on
	}
]]--

-- Enemy(type, x, y, radius, points, bulletPattern)

--[[
	bulletPattern format
	{typ=, direction=, numofbullets=, shot={frequency=, move=}, size=}
	
	typ can equal one of the following
	the information followed in the [] indicates how to fill out the rest of the data
	----
		'direction'
			direction = direction in degrees
			numofbullets is a positive integer
		]
		'circle' [
			numofbullets is a positive integer
		]
	----
	shot =
		{
			frequency is a positive integer indicating how often to shoot, shots per second
			move indicates if the enemy can move and shoot (anything or nil)
		}
	size = radius of bullet hitbox
	
	bulletPattern default = {typ = 'circle', numofbullets = 8, shot={frequency = 1}, size = 3}
]]--

Levels = 
{

}