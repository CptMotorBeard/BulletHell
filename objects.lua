Circle = {}
Circle.__index = Circle

-- New circle with x pos, y pos and radius
function Circle.new(x, y, radius, r, g, b)
	return setmetatable({
		x = x or 0,
		y = y or 0,
		radius = radius or 1,
		r = r or 255,
		g = g or 255,
		b = b or 255},
	Circle)
end

-- New circle by Circle.new() or just Circle()
setmetatable(Circle, {__call = function(_, ...) return Circle.new(...) end})

function Circle:checkCollision(circle)
	local distance = (self.x - circle.x)^2 + (self.y - circle.y)^2
	return distance <= (self.radius + circle.radius)^2
end

function Circle:draw()
	love.graphics.push('all')
	
	love.graphics.setColor(self.r, self.g, self.b)
	love.graphics.circle('fill', self.x, self.y, self.radius)
	
	love.graphics.pop()
end

--[[END OF CIRCLE]]--