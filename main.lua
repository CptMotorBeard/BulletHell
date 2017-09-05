gameIsPaused = false

PlayerSprite = {
	love.graphics.newImage("assets/Spaceship1.png"),
	love.graphics.newImage("assets/Spaceship2.png"),
	love.graphics.newImage("assets/Spaceship3.png")
}

Player = {
	x = 0,
	y = 0,
	currentframe = 0.5,
	Sprite = {
		PlayerSprite[1],
		PlayerSprite[2],
		PlayerSprite[3],
		PlayerSprite[2]
	}
}

SpriteSpeed = 6

-- love.load is called once at the beginning
function love.load(arg)
end

-- dt is delta time, time since function last called. love.update is called every update. math goes here
function love.update(dt)
	if gameIsPaused then return end
	
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