--[[
	OVERALL

	Each boss is composed of a few parts.
	
	First, and most importantly, are the boss phases. Each boss has one or more phases. When the hp for a phase is deplete, than the boss moves to the next phase.
	
	Each phase has all the pieces needed for the boss to interact with the player.
	
	There is the phase health. When this is depleted, the boss moves to the next phase.
	There are phase points, when you beat a phase you get this many points
	There is the phase sections, which indicates how many body sections the boss has.
	There is a hitbox for each section. The first hitbox is always the main body, followed by any additional hitboxes.
	Additional hitboxes can either have linked or separate health.
	There is a list of how each section shoots bullets 
	There is movement for each section. The first movement is always the main body. All other sections will also follow this movement unless otherwise indicated.
]]--

--[[
	HITBOX SECTION
	x = x pos, y = y pox, radius = radius
]]--

--[[
	BULLETS SECTION
	
	Format
	directiona, directionb - 	Direction will move from direction a to direction b and than back 1 degree every shot
								equal means no movement, aimed means always aim at player
	numofbullets - 				Indicates the amount of bullets shot
	fan -						Angle of degree the bullets take (circle is 360)
	frequency -					Shots per second
	size -						Size of the bullet
	
	{r,g,b}
	
	If there is not a section with a hitbox that links to a shoot point it will default to the main body
]]--

--[[
	MOVEMENT SECTION
]]--

Bosses = {	
	{ -- Boss 1
		Phases = {			
			{ -- Phase 1
				health = 100,
				points = 100,
				sections = 1,
				hitbox = {
					-- Hitbox for section 1
					-- TODO sprites will go in here as well
					{x = love.graphics.getWidth() / 2, y = 200, radius = 20}
					-- If there was another section it would go here {}
				}, -- hitbox
				bullets = {
					-- Bullets for section 	1
					-- TODO Figure out how to make cool bullets	for now just follow enemy bullet types
					{directiona=0, directionb=180, numofbullets=36, fan=360, frequency=15, size=5; 0, 0, 205},
					{directiona='aimed', directionb=180, numofbullets=8, fan=70, frequency=4, size=5; 0, 205, 0}
					-- If there was another section it would go here {}
				}, -- bullets
				movement = {
					-- Movement for section 1
					{}
					-- If there was another section it would go here {}
				} -- movement
			}	-- End of Phase 1
		} -- End of Phases
	} -- End of Boss 1
}