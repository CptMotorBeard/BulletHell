require 'patterns'
require 'objects'

__UNITS = 64

Bullets = {}

Enemy = {}
Enemy.__index = Enemy

function Enemy.new(enemytype, x, y, radius, points, bulletPattern)
	local enemytype = enemytype or 1
	local pattern = MovementPatterns[enemytype]
	local points = points or 10
	local bulletPattern = bulletPattern or {typ = 'circle', numofbullets = 8, shot = {frequency = 1, move=1}, size = 3}
	-- Body is the hitbox, still need proper sprites (see TODO below)
	local body = Circle(x, y, radius)
	
	return setmetatable({
		enemytype = enemytype,
		pattern = pattern,
		bulletPattern = bulletPattern,
		bulletDelay = 0,
		body = body,
		patstep = 0,
		xmov = nil,
		ymov = nil,
		points = points
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

function EnemyMoveHelper(enemy)
	if enemy.patstep == -1 then
		return
	end

	local condition = enemy.pattern[enemy.patstep].xcondition
	
	-- xmov
	if condition == nil then
		enemy.xmov = enemy.body.x
	else
		if condition.typ == 'relative' then
			if condition.val == 'px' then
				enemy.xmov = enemy.body.x + condition.position
			elseif condition.val == 'units' then
				enemy.xmov = enemy.body.x + (condition.position * __UNITS)
			elseif condition.val == '%' then
				enemy.xmov = (love.graphics.getWidth() - enemy.body.x) * (condition.position / 100)
			end
		elseif condition.typ == 'absolute' then
			if condition.val ~= nil and condition.val == '%' then
				enemy.xmov = love.graphics.getWidth() * (condition.position / 100)
			else
				enemy.xmov = condition.position
			end
		end
	end
	
	condition = enemy.pattern[enemy.patstep].ycondition
	-- ymov
	if condition == nil then
		enemy.ymov = enemy.body.y
	else
		if condition.typ == 'relative' then
			if condition.val == 'px' then
				enemy.ymov = enemy.body.y + condition.position
			elseif condition.val == 'units' then
				enemy.ymov = enemy.body.y + (condition.position * __UNITS)
			elseif condition.val == '%' then
				enemy.ymov = (love.graphics.getHeight() - enemy.body.y) * (condition.position / 100)
			end
		elseif condition.typ == 'absolute' then
			if condition.val ~= nil and condition.val == '%' then
				enemy.ymov = love.graphics.getHeight() * (condition.position / 100)
			else
				enemy.ymov = condition.position
			end
		end
	end
end

function Enemy:move(dt)
	-- end of pattern
	if self.patstep == -1 then
		return
	end
	-- beginning of pattern
	if self.patstep == 0 then
		self.patstep = 1
		EnemyMoveHelper(self)
	end
	-- round to check if pixels match and continue the pattern if they do
	if (math.floor(self.body.x + 0.5)) == (math.floor(self.xmov + 0.5)) and 
	(math.floor(self.body.y + 0.5)) == (math.floor(self.ymov + 0.5)) then
		self.patstep = self.pattern[self.patstep].nextstep
		EnemyMoveHelper(self)
	end
	-- move based on current position
	local move = self.pattern[self.patstep].speed * dt
	-- x movement
	local xdir = (self.xmov - self.body.x)
	xdir = (xdir > 0 and 1) or (xdir < 0 and -1) or 0
	self.body.x = self.body.x + (xdir * move)
	-- y movement
	local ydir = (self.ymov - self.body.y)
	ydir = (ydir > 0 and 1) or (ydir < 0 and -1) or 0
	self.body.y = self.body.y + (ydir * move)
end

function Enemy:shoot(dt)
	local numBullets = self.bulletPattern.numofbullets
	local bullets = {}
	
	if (not self.bulletPattern.shot.move) and not (self.patstep == -1) then return end
	self.bulletDelay = self.bulletDelay + dt
	
	if (math.floor(self.bulletDelay + 0.5)) == (1 / self.bulletPattern.shot.frequency) then
		for i = 1, numBullets, 1 do
			table.insert(bullets, Circle(self.body.x, self.body.y, self.bulletPattern.size, 0, 255, 50))
		end
		self.bulletDelay = 0
	end
	
	if #bullets == 0 then return nil
	else return {pattern = self.bulletPattern, bullets = bullets}
	end
end

function Enemy:updateBullets(dt)
	local bulletType = self.bulletPattern.typ
	local numBullets = self.bulletPattern.numofbullets
	local direction = self.bulletPattern.direction

	for index, bullet in ipairs(self.bullets) do
		local curbullet = (index - 1) % numBullets
		if bulletType == 'direction' then
			local angle = (curbullet * (90 / (numBullets - 1))) - 135
			local xmovement = math.cos(math.rad(direction + angle))
			local ymovement = math.sin(math.rad(direction + angle))
			
			bullet.x = bullet.x + (dt * 100 * xmovement)
			bullet.y = bullet.y + (dt * 100 * ymovement)
		elseif bulletType == 'circle' then			
			local angle = curbullet * (360 / (numBullets - 1))
			local xmovement = math.cos(math.rad(angle))
			local ymovement = math.sin(math.rad(angle))

			bullet.x = bullet.x + (dt * 100 * xmovement)
			bullet.y = bullet.y + (dt * 100 * ymovement)
		end
		
		if 	bullet.x < (0 - self.bulletPattern.size) or
			bullet.x > (love.graphics.getWidth() + self.bulletPattern.size) or
			bullet.y < (0 - self.bulletPattern.size) or
			bullet.y > (love.graphics.getHeight() + self.bulletPattern.size) then
			table.remove(self.bullets, index)
		end
	end
end