require 'objects'

__UNITS = 64

Bullets = {}

Boss = {}
Boss.__index = Boss

function Boss.new(x, y, radius, points, health)
	local body = Circle(x, y, radius, 204, 0, 0)
	return setmetatable({
		body = body,
		points = points or 100,
		health = health or 100,
		maxhealth = health or 100
	},
	Boss)
end

setmetatable(Boss, {__call = function(_, ...) return Boss.new(...) end})

function Boss:draw()
	self.body:draw()
	love.graphics.push('all')
	love.graphics.setColor(0, 102, 0)
	local xwidth = love.graphics.getWidth() - 100
	local width = xwidth * (self.health / self.maxhealth)
	local x = 50 + ((xwidth - width) / 2)
	love.graphics.rectangle('fill', x, love.graphics.getHeight() - 80, width, 40)
	love.graphics.pop()
end

function Boss:checkCollision(circle)
	return self.body:checkCollision(circle)
end

function Boss:hit()
	self.health = self.health - 1
	if self.health > 0 then return 'Boss'
	else return 0.5 end
end

function Boss:shoot(dt, player) end

function Boss:updateBullets(dt) end

function Boss:move(dt) end