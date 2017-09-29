require 'objects'
require 'levelsBoss'

__UNITS = 64

--Bullets = {}

Boss = {}
Boss.__index = Boss

function Boss.new(i)
	local boss = Bosses[i].Phases[1]
	local body = {}
	for _, section in ipairs(boss.hitbox) do
		table.insert(body, Circle(section.x, section.y, section.radius, 205, 0, 0))
	end
	local bulletPatterns = boss.bullets
	local bulletDelay = {}
	for i,_ in ipairs(bulletPatterns) do
		bulletDelay[i] = 0
	end
	return setmetatable({
		Bullets = {},
		index = i,
		points = boss.points,
		currentphase = 1,
		body = body,
		bulletPatterns = bulletPatterns,
		bulletDelay = bulletDelay,
		health = boss.health,
		maxhealth = boss.health		
	},
	Boss)
end

setmetatable(Boss, {__call = function(_, ...) return Boss.new(...) end})

function Boss:healthbar()
	love.graphics.push('all')
	love.graphics.setColor(0, 102, 0)
	local xwidth = love.graphics.getWidth() - 100
	local width = xwidth * (self.health / self.maxhealth)
	local x = 50 + ((xwidth - width) / 2)
	love.graphics.rectangle('fill', x, love.graphics.getHeight() - 80, width, 40)
	love.graphics.pop()
end

function Boss:draw()
	for _, sectionbullets in ipairs(self.Bullets) do
		for _, bullet in ipairs(sectionbullets) do
			bullet:draw()
		end
	end
	for _, section in ipairs(self.body) do
		section:draw()
	end
end

function Boss:checkCollision(circle)
	for _, section in ipairs(self.body) do
		if section:checkCollision(circle) then return true end
	end
	return false
end

function Boss:hit()
	self.health = self.health - 1
	if self.health <= 0 then
		self.currentphase = self.currentphase + 1
		
		local score = self.points
		for _, sectionbullets in ipairs(self.Bullets) do
			score = score + (10 * #sectionbullets)
		end
		self.Bullets = {}
		
		if self.currentphase > #Bosses[self.index].Phases then return {'Play', score}
		else return {'Boss', score} end
	end
	return {'Boss', 0}
end

function Boss:shoot(dt, player)
	for index, pattern in ipairs(self.bulletPatterns) do
		self.bulletDelay[index] = self.bulletDelay[index] + dt
		if self.bulletDelay[index] >= (1 / pattern.frequency) then
			-- originate the bullet defaulting to main body
			local i = index
			if not self.body[index] then i = 1 end
			local x = self.body[i].x
			local y = self.body[i].y
					
			for j = 1, pattern.numofbullets, 1 do
				local bullet = Circle(x, y, pattern.size, pattern[1], pattern[2], pattern[3])
				bullet.index = j
				bullet.step = 0
				if pattern.directiona == 'aimed' then
					local deltax = player.x - x
					local deltay = player.y - y
					local dir = 180 - math.deg(math.atan2(deltax, deltay))
					bullet.dir = dir
				end
				if not self.Bullets[index] then self.Bullets[index] = {} end
				table.insert(self.Bullets[index], bullet)
			end			
			
			self.bulletDelay[index] = 0
		end			
	end
end

-- ALL BOSS BULLETS ADD POINTS WHEN BOSS DIES, NO UPDATING BULLETS IF BOSS DOES NOT EXIST
function Boss:updateBullets(dt)
	for index, sectionbullets in ipairs(self.Bullets) do
		local numBullets = self.bulletPatterns[index].numofbullets
		local directiona = self.bulletPatterns[index].directiona
		local directionb = self.bulletPatterns[index].directionb
		local fan = self.bulletPatterns[index].fan

		for bulletindex, bullet in ipairs(sectionbullets) do
			local curbullet = (bullet.index - 1) % numBullets
			local angle = (curbullet * (fan / (numBullets - 1))) - (90 + (fan / 2))
			local xmovement
			local ymovement
			if directiona == 'aimed' then
				xmovement = math.cos(math.rad(bullet.dir + angle))
				ymovement = math.sin(math.rad(bullet.dir + angle))
			elseif directiona == directionb then					
				xmovement = math.cos(math.rad(directiona + angle))
				ymovement = math.sin(math.rad(directiona + angle))
			else
				if bullet.step >= 0 then
					bullet.step = bullet.step + 1
					xmovement = math.cos(math.rad((directiona + bullet.step) + angle))
					ymovement = math.sin(math.rad((directiona + bullet.step) + angle))
					if directiona + bullet.step >= directionb then bullet.step = -1 end
				else
					bullet.step = bullet.step - 1
					xmovement = math.cos(math.rad((directionb + bullet.step) + angle))
					ymovement = math.sin(math.rad((directionb + bullet.step) + angle))
					if directionb + bullet.step <= directiona then bullet.step = 0 end
				end
			end
			bullet.x = bullet.x + (dt * 100 * xmovement)
			bullet.y = bullet.y + (dt * 100 * ymovement)

			if 	bullet.x < (0 - self.bulletPatterns[index].size) or
				bullet.x > (love.graphics.getWidth() + self.bulletPatterns[index].size) or
				bullet.y < (0 - self.bulletPatterns[index].size) or
				bullet.y > (love.graphics.getHeight() + self.bulletPatterns[index].size) then
				table.remove(sectionbullets, bulletindex)
			end
		end
	end
end

function Boss:move(dt) end