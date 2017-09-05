gameIsPaused = false

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
	x = 0,
	y = 0,
	currentframe = 0.5,
	Sprite = PlayerSpriteNeutral,
	speed = 100
}

SpriteSpeed = 6

-- love.load is called once at the beginning
function love.load(arg)
end

-- dt is delta time, time since function last called. love.update is called every update. math goes here
function love.update(dt)
	if gameIsPaused then return end
	
	Player.Sprite = PlayerSpriteNeutral
	
	-- Movement left / right
	if love.keyboard.isDown('d') then
		Player.x = Player.x + (Player.speed * dt)
		Player.Sprite = PlayerSpriteRight
	elseif love.keyboard.isDown('a') then
		Player.x = Player.x - (Player.speed * dt)
		Player.Sprite = PlayerSpriteLeft
	end
	
	-- update frames
	if ((Player.currentframe + (SpriteSpeed * dt)) < 4.5) then
		Player.currentframe = Player.currentframe + (SpriteSpeed * dt)
	else
		Player.currentframe = 0.5
	end
end

-- love.draw is called every update. graphics go here
function love.draw(dt)
	love.graphics.draw(Player.Sprite[math.floor(Player.currentframe + 0.5)], Player.x, Player.y)
end

-- love.keypressed is called when a key is pressed likewise with keyreleased
function love.keypressed(key)
end

function love.keyreleased(key)
end

-- love.focus tells the game if the screen is in focus
function love.focus(f) gameIsPaused = not f end

-- love.quit is called when the user clicks the close button
function love.quit()
end