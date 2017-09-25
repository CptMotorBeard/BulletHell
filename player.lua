require 'objects'

Player = {}
Player.__index = Player

Spaceship = {
	love.graphics.newImage("assets/Spaceship/Spaceship1.png"),
	love.graphics.newImage("assets/Spaceship/Spaceship2.png"),
	love.graphics.newImage("assets/Spaceship/Spaceship3.png"),
	love.graphics.newImage("assets/Spaceship/Spaceship1Right.png"),
	love.graphics.newImage("assets/Spaceship/Spaceship2Right.png"),
	love.graphics.newImage("assets/Spaceship/Spaceship3Right.png"),
	love.graphics.newImage("assets/Spaceship/Spaceship1Left.png"),
	love.graphics.newImage("assets/Spaceship/Spaceship2Left.png"),
	love.graphics.newImage("assets/Spaceship/Spaceship3Left.png")
}

PlayerSpriteNeutral = {
	Spaceship[1],
	Spaceship[2],
	Spaceship[3],
	Spaceship[2]
}

PlayerSpriteRight = {
	Spaceship[4],
	Spaceship[5],
	Spaceship[6],
	Spaceship[5]
}

PlayerSpriteLeft = {
	Spaceship[7],
	Spaceship[8],
	Spaceship[9],
	Spaceship[8]
}

BulletDelay = 0.02
CurDelay = BulletDelay

function Player.new(x, y, speed)
	return setmetatable({
		x = x or 250,
		y = y or 500,
		currentframe = 0.5,
		Sprite = PlayerSpriteNeutral,
		speed = speed or 250,
		shootpoint = 0,
		shooting = false,
		hitbox = Circle(0, 100, 5, 0, 230),
		Bullets = {}},
	Player)
end

setmetatable(Player, {__call = function(_, ...) return Player.new(...) end})

function Player:shoot(dt)
	if love.keyboard.isDown('space') then
		if not self.shooting then
			table.insert(self.Bullets, Circle(self.shootpoint, self.y, 3))
			self.shooting = true
		else
			CurDelay = CurDelay - dt
			if CurDelay <= 0 then
				self.shooting = false
				CurDelay = BulletDelay
			end
		end
	end
end

function Player:updateBullets(dt)
	-- Update player bullets
	for index, bullet in ipairs(self.Bullets) do
		bullet.y = bullet.y - (300 * dt)
		if bullet.y <= 0 then
			table.remove(self.Bullets, index)
		end
	end
end

function Player:move(dt)
	Player.Sprite = PlayerSpriteNeutral
	-- Movement left / right
	if love.keyboard.isDown('d') then
		if not ((self.x + (self.speed * dt)) >= (love.graphics.getWidth() - self.Sprite[1]:getWidth())) then
			self.x = self.x + (self.speed * dt)
			self.Sprite = PlayerSpriteRight
		end
	elseif love.keyboard.isDown('a') then
		if not ((self.x - (self.speed * dt)) <= 0) then
			self.x = self.x - (self.speed * dt)
			self.Sprite = PlayerSpriteLeft
		end
	end
	
	-- Movement up / down
	if love.keyboard.isDown('w') then
		if not ((self.y - (self.speed * dt)) <= 0) then
			self.y = self.y - (self.speed * dt)
		end
	elseif love.keyboard.isDown('s') then
		if not ((self.y + (self.speed * dt)) >= (love.graphics.getHeight() - self.Sprite[1]:getHeight())) then
			self.y = self.y + (self.speed * dt)
		end
	end
	
	-- Set hitbox and bullet entry location to spots on the player sprite
	self.hitbox.x = self.x + (self.Sprite[1]:getWidth()/2)
	self.hitbox.y = self.y + (self.Sprite[1]:getHeight()/2)

	self.shootpoint = self.x + (self.Sprite[1]:getWidth()/2)
	
	-- update frames for player sprite
	if ((self.currentframe + (5 * dt)) < 4.5) then
		self.currentframe = self.currentframe + (5 * dt)
	else
		self.currentframe = 0.5
	end
end

function Player:draw()
	love.graphics.draw(Player.Sprite[math.floor(Player.currentframe + 0.5)], Player.x, Player.y)
end

function Player:removeBullet(index)
	table.remove(self.Bullets, index)
end