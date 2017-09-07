require 'objects'

gameIsPaused = false
gameOver = false
hitboxvisible = false

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

Player = {
	x = 250,
	y = 500,
	currentframe = 0.5,
	Sprite = PlayerSpriteNeutral,
	speed = 250,
	shootpoint = 0,
	shooting = false,
	hitbox = Circle(0, 100, 5, 0, 230),
	Bullets = {}
}

Enemies = {}
Bullets = {}

SpriteSpeed = 6

-- love.load is called once at the beginning
function love.load(arg)
end

-- dt is delta time, time since function last called. love.update is called every update. math goes here
function love.update(dt)
	if gameIsPaused then return end
	
	Player.Sprite = PlayerSpriteNeutral
	
	-- Bullets
	if love.keyboard.isDown('space') then
		if not Player.shooting then
			table.insert(Player.Bullets, Circle(Player.shootpoint, Player.y, 3))
			Player.shooting = true
		else
			Player.shooting = false
		end
	end
	
	-- Update player bullets
	for index, bullet in ipairs(Player.Bullets) do
		bullet.y = bullet.y - (300 * dt)
		if bullet.y <= 0 then
			table.remove(Player.Bullets, index)
		end
	end
	
	-- Movement left / right
	if love.keyboard.isDown('d') then
		if not ((Player.x + (Player.speed * dt)) >= (love.graphics.getWidth() - Player.Sprite[1]:getWidth())) then
			Player.x = Player.x + (Player.speed * dt)
			Player.Sprite = PlayerSpriteRight
		end
	elseif love.keyboard.isDown('a') then
		if not ((Player.x - (Player.speed * dt)) <= 0) then
			Player.x = Player.x - (Player.speed * dt)
			Player.Sprite = PlayerSpriteLeft
		end
	end
	
	Player.hitbox.x = Player.x + (Player.Sprite[1]:getWidth()/2)
	Player.hitbox.y = Player.y + (Player.Sprite[1]:getHeight()/2)
	
	Player.shootpoint = Player.x + (Player.Sprite[1]:getWidth()/2)
	
	-- Detect collisions
	for index, bullet in ipairs(Bullets) do
		if Player.hitbox:checkCollision(bullet) then
			gameOver = true
			break
		end
	end
	
	-- update frames
	if ((Player.currentframe + (SpriteSpeed * dt)) < 4.5) then
		Player.currentframe = Player.currentframe + (SpriteSpeed * dt)
	else
		Player.currentframe = 0.5
	end
end

-- love.draw is called every update. graphics go here
function love.draw()
	love.graphics.draw(Player.Sprite[math.floor(Player.currentframe + 0.5)], Player.x, Player.y)
	
	if hitboxvisible then Player.hitbox:draw() end
	
	for index, bullet in ipairs(Player.Bullets) do
		bullet:draw()
	end
	
	for index, bullet in ipairs(Bullets) do
		bullet:draw()
	end
end

-- love.keypressed is called when a key is pressed likewise with keyreleased
function love.keypressed(key)
	if key == 'lshift' then
		hitboxvisible = true
		Player.speed = 125
	end
end

function love.keyreleased(key)
	if key == 'lshift' then
		hitboxvisible = false
		Player.speed = 250
	end
end

-- love.focus tells the game if the screen is in focus
function love.focus(f) gameIsPaused = not f end

-- love.quit is called when the user clicks the close button
function love.quit()
end