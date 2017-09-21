require 'enemy'
require 'levels'

Game = {}
Game.__index = Game

function Game.new(level)
	return setmetatable({
		level = level or 1,
		curSection = 0,
		enemies = {},
		bullets = {}
	},
	Game)
end

setmetatable(Game, {__call = function(_, ...) return Game.new(...) end})

--[[
		To spawn enemies we look at the Levels table
		For each level, we spawn in the enemies for each round. When they are all removed, we move to the next level
		If all enemies on the last level are removed, we move on to the win screen
]]--

function Game:Play(dt)
	if (not self.enemies) or #self.enemies == 0 then
		if self.level > #(Levels) then
			return 'Win'
		end
		local curLevel = Levels[self.level]
		if self.curSection > curLevel.numRounds then
			local delay = Levels[self.level].delay or 0.5
			self.level = self.level + 1
			if self.level > #(Levels) then
				return 'Win'
			end
			self.curSection = 0
			curLevel = Levels[level]
			return delay
		end
		self.curSection = self.curSection + 1
		self.enemies = curLevel.Enemies[self.curSection]
	else
		for index, enemy in ipairs(self.enemies) do
			if not enemy.dead then 
				enemy:move(dt)
				local bullet = enemy:shoot(dt)
				table.insert(self.bullets, bullet)
			end
			if 	enemy.patstep == -1 and 
				(enemy.body.x < (0 - enemy.body.radius) or
				enemy.body.x > (love.graphics.getWidth() + enemy.body.radius) or
				enemy.body.y < (0 - enemy.body.radius) or
				enemy.body.y > (love.graphics.getHeight() + enemy.body.radius)) then
				table.remove(self.enemies, index)
			end
		end
	end
	return 'Play'
end

function Game:enemyHit(index)
	table.remove(self.enemies, index)
end

function bulletHelper(dt, pattern, bullets)
	local bulletType = pattern.typ
	local numBullets = pattern.numofbullets
	local direction = pattern.direction

	for _, bullet in ipairs(bullets) do
		local curbullet = (bullet.index - 1) % numBullets
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
	end
end

function cleanupBullets(bullets)
	for index, bullet in ipairs(bullets) do
		if 	bullet.x <= (0) or
			bullet.x >= (love.graphics.getWidth()) or
			bullet.y <= (0) or
			bullet.y >= (love.graphics.getHeight()) then
			table.remove(bullets, index)
		end
	end
end

function Game:updateBullets(dt)
	for index, enemy in ipairs(self.bullets) do
		bulletHelper(dt, enemy.pattern, enemy.bullets)
		cleanupBullets(enemy.bullets)
		if #enemy.bullets <= 0 then table.remove(self.bullets, index) end
	end
end
