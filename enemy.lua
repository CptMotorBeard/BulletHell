require 'patterns'
require 'objects'

Enemy = {}
Enemy.__index = Enemy

function Enemy.new(enemytype, x, y, radius)
	local enemytype = enemytype or 1
	local pattern = Patterns[enemytype]
	-- Body is the hitbox, still need proper sprites (see TODO below)
	local body = Circle(x, y, radius)
	
	return setmetatable({
		enemytype = enemytype,
		pattern = pattern,
		body = body
	},
	Enemy)
end

setmetatable(Enemy, {__call = function(_, ...) return Enemy.new(...) end})

-- Draw and collision are same as a circle draw and collision

--[[
		TODO:
		Bodies are just the hit boxes of enemies, still need to implement sprites in which case the draw function will be changed
]]--

function Enemy:draw()
	self.body:draw()
end

function Enemy:checkCollision(circle)
	return self.body:checkCollision(circle)
end

--[[
		TODO:
		Enemy:move(dt)
		
		Based on the pattern outline in patterns.lua, implement the proper states and state swaps to get working patterns
		When we move to a new pattern, or at the start of a pattern, need to set a maxx and maxy to determine where we are moving to
		so that relative movement works properly
]]--