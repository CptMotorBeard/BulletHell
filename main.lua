require 'objects'
require 'game'
require 'player'

-- We have our game modes and game states
game = Game()
__SCORE = 0

gameIsPaused = false
gameOver = false
hitboxvisible = false

MainMenu = {items = {'Start', 'Exit'}, selected = 1}
GameMode = 'MainMenu'

-- Than we have our character sprites
--[[
		TODO:
		Make a player class
]]--

Player = Player()

-- Variable to slow down the bullets
SpriteSpeed = 6

-- love.load is called once at the beginning
function love.load(arg)
end

-- dt is delta time, time since function last called. love.update is called every update. math goes here
function love.update(dt)
	if gameIsPaused then return end
	
	if type(GameMode) == 'number' then
		if GameMode <= 0 then
			GameMode = 'Play'
		else
			GameMode = GameMode - dt
		end
	end
	
	if GameMode == 'MainMenu' then
	elseif GameMode == 'Play' then
		GameMode = game:Play(dt)
		
		Player:shoot(dt)
		Player:move(dt)

		-- Check Collisions
		if game.enemies then
			for index, enemy in ipairs(game.enemies) do
				if #enemy.bullets > 0 then
					for _, bullet in ipairs(enemy.bullets) do
						if Player.hitbox:checkCollision(bullet) then
							GameMode = 'GameOver'
						end
					end
				end
				if not (#(Player.Bullets) > 0) then break end
				for _, bullet in ipairs(Player.Bullets) do
					if #(game.enemies) <= 0 then
						break
					end
					if (enemy:checkCollision(bullet)) then
						__SCORE = __SCORE + enemy.points						
						game:enemyHit(index)
						break
					end
				end
			end
		end
	end
end

-- love.draw is called every update. graphics go here
function love.draw()
	if GameMode == 'MainMenu' then
		love.graphics.push('all')
		love.graphics.setFont(love.graphics.newFont(72))
		love.graphics.setColor(115, 30, 30)
		love.graphics.printf("THIS IS A GAME", 0, 50, love.graphics.getWidth(), 'center')
		love.graphics.setFont(love.graphics.newFont(24))
		for index, item in ipairs(MainMenu.items) do
		-- Main menu options
			if index == MainMenu.selected then
				love.graphics.setColor(30, 115, 30)
				love.graphics.printf(item, 0, 350 + (index * 24), love.graphics.getWidth(), 'center')
			else
				love.graphics.setColor(30, 30, 115)
				love.graphics.printf(item, 0, 350 + (index * 24), love.graphics.getWidth(), 'center')
			end
		end
		love.graphics.pop()
	elseif GameMode == 'Win' then
		-- Simple victory screen
		love.graphics.push('all')
		love.graphics.setFont(love.graphics.newFont(72))
		love.graphics.setColor(115, 30, 30)
		love.graphics.printf("WINNER", 0, 200, love.graphics.getWidth(), 'center')
		love.graphics.pop()
	elseif GameMode == 'Play' or type(GameMode) == 'number' then
	-- Draw all the sprites, bullets and hitboxes
		love.graphics.printf(love.timer.getFPS(), -10, 10, love.graphics.getWidth(), 'right')
		love.graphics.printf('SCORE :  ' .. __SCORE, 5, 10, love.graphics.getWidth(), 'left')
		
		Player:draw()
		
		if hitboxvisible then Player.hitbox:draw() end
		
		for _, bullet in ipairs(Player.Bullets) do
			bullet:draw()
		end
		
		if game.enemies then
			for _, enemy in ipairs(game.enemies) do
				enemy:draw()
			end
		end
	
		for _, bullet in ipairs(game.bullets) do
			bullet:draw()
		end
	end
end

-- love.keypressed is called when a key is pressed likewise with keyreleased
function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end

	if GameMode == 'MainMenu' then
		if key == 'w' then
			if not (MainMenu.selected == 1) then MainMenu.selected = MainMenu.selected - 1 end
		elseif key == 's' then
			if not (MainMenu.selected == #(MainMenu.items)) then MainMenu.selected = MainMenu.selected + 1 end
		elseif key == 'space' then
			if MainMenu.selected == 1 then
				GameMode = 0.5
			elseif MainMenu.selected == 2 then
				love.event.quit()
			end
		end
		
	-- Toggle for speed and showing player hitbox
	elseif GameMode == 'Play' then
		if key == 'lshift' then
			hitboxvisible = true
			Player.speed = 125
		end
	end
end

function love.keyreleased(key)
	if GameMode == 'MainMenu' then
	
	-- Toggle for speed and showing player hitbox
	elseif GameMode == 'Play' then
		if key == 'lshift' then
			hitboxvisible = false
			Player.speed = 250
		end
	end
end

-- love.focus tells the game if the screen is in focus
-- pause game if not focused
function love.focus(f) gameIsPaused = not f end

-- love.quit is called when the user clicks the close button
function love.quit()
end