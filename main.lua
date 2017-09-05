gameIsPaused = false

-- love.load is called once at the beginning
function love.load(arg)
end

-- dt is delta time, time since function last called. love.update is called every update. math goes here
function love.update(dt)
	if gameIsPaused then return end
end

-- love.draw is called every update. graphics go here
function love.draw(dt)
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