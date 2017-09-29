require 'patterns'
require 'objects'

__UNITS = 64

Bullets = {}

Enemy = {}
Enemy.__index = Enemy

function Enemy.new(enemytype, x, y, radius, points, bulletPattern)
	local enemytype = enemytype
	local pattern = MovementPatterns[enemytype]
	local points = points or 10
	local bulletsPattern = {typ = bulletPattern.typ or 'circle',
							direction = bulletPattern.direction or 180,
							numofbullets = bulletPattern.numofbullets or 8,
							shot = bulletPattern.shot or {frequency = 1, move = 1},
							size = bulletPattern.size or 3}
	-- Body is the hitbox, still need proper sprites (see TODO below)
	local body = Circle(x, y, radius)
	
	return setmetatable({
		enemytype = enemytype,
		pattern = pattern,
		bulletPattern = bulletsPattern,
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
	if not self.pattern then return end
	-- end of pattern
	if self.patstep == -1 then
		return
	end
	-- beginning of pattern
	if self.patstep == 0 then
		self.patstep = 1
		EnemyMoveHelper(self)
	end
	
	-- round to check if pixels match +/- 5px and continue the pattern if they do	
	local curx = math.floor(self.body.x + 0.5)
	local cury = math.floor(self.body.y + 0.5)
	local destx = math.floor(self.xmov + 0.5)
	local desty = math.floor(self.ymov + 0.5)
	
	if 	(curx >= (destx - 5) and curx <= (destx + 5)) and
	 	(cury >= (desty - 5) and cury <= (desty + 5)) then
			self.patstep = self.pattern[self.patstep].nextstep
			if self.patstep == -1 then return end
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

function Enemy:shoot(dt, player)
	local numBullets = self.bulletPattern.numofbullets
	local bullets = {}
	
	if (not self.bulletPattern.shot.move) and not (self.patstep == -1) then return end
	self.bulletDelay = self.bulletDelay + dt
	
	if self.bulletDelay >= (1 / self.bulletPattern.shot.frequency) then
		for i = 1, numBullets, 1 do
			local bullet = Circle(self.body.x, self.body.y, self.bulletPattern.size, 0, 255, 50)
			bullet.index = i
			table.insert(bullets, bullet)
		end
		self.bulletDelay = 0
	end
	
	if #bullets == 0 then return nil end
	
	local pattern = {}
	
	for i,j in pairs(self.bulletPattern) do
		pattern[i] = j
	end
	
	if pattern.direction and pattern.direction == 'aimed' then		
		local deltax = player.x - self.body.x
		local deltay = player.y - self.body.y
		pattern.direction = 180 - math.deg(math.atan2(deltax, deltay))
	end
	return {pattern = pattern, bullets = bullets}
end