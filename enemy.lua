require 'patterns'
require 'objects'

Enemy = {}
Enemy.__index = Enemy

function Enemy.new(enemytype)
	local enemytype = enemytype or 1
	local pattern = Patterns[enemytype]
	local body = Circle(pattern.startx, pattern.starty, pattern.r)
	
	return setmetatable({
		enemytype = enemytype,
		pattern = pattern,
		body = body
	},
	Enemy)
end

setmetatable(Enemy, {__call = function(_, ...) return Enemy.new(...) end})

function Enemy:draw()
	self.body:draw()
end

function Enemy:checkCollision(circle)
	return self.body:checkCollision(circle)
end