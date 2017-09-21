require 'objects'
require 'game'

-- We have our game modes and game states
game = Game()
__SCORE = 0

gameIsPaused = false
gameOver = false
hitboxvisible = false

StartDelay = 0.5

MainMenu = {items = {'Start', 'Exit'}, selected = 1}
GameMode = 'MainMenu'

-- Than we have our character sprites
--[[
		TODO:
		Make a player class
]]--
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

-- Variable to slow down the bullets
SpriteSpeed = 6

-- love.load is called once at the beginning
function love.load(arg)
end

-- dt is delta time, time since function last called. love.update is called every update. math goes here
function love.update(dt)
	if gameIsPaused then return end
	
	if GameMode == 'MainMenu' then
	elseif GameMode == 'StartDelay' then
		StartDelay = StartDelay - dt
		if StartDelay <= 0 then
			StartDelay = 0.5
			GameMode = 'Play'
		end
	elseif GameMode == 'Play' then
		
		--[[
				TODO:
				Maybe if GameMode == number then countdown before continue to play or something
		]]--
		GameMode = game:Play(dt)

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
		
		-- Movement up / down
		if love.keyboard.isDown('w') then
			if not ((Player.y - (Player.speed * dt)) <= 0) then
				Player.y = Player.y - (Player.speed * dt)
			end
		elseif love.keyboard.isDown('s') then
			if not ((Player.y + (Player.speed * dt)) >= (love.graphics.getHeight() - Player.Sprite[1]:getHeight())) then
				Player.y = Player.y + (Player.speed * dt)
			end
		end

		-- Set hitbox and bullet entry location to spots on the player sprite
		Player.hitbox.x = Player.x + (Player.Sprite[1]:getWidth()/2)
		Player.hitbox.y = Player.y + (Player.Sprite[1]:getHeight()/2)

		Player.shootpoint = Player.x + (Player.Sprite[1]:getWidth()/2)

		-- Check Collisions
		if #(Player.Bullets) > 0 and game.enemies then
			for index, enemy in ipairs(game.enemies) do
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
		
		-- update frames for player sprite
		if ((Player.currentframe + (SpriteSpeed * dt)) < 4.5) then
			Player.currentframe = Player.currentframe + (SpriteSpeed * dt)
		else
			Player.currentframe = 0.5
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
	elseif GameMode == 'Play' or GameMode == 'StartDelay' then
	-- Draw all the sprites, bullets and hitboxes
		love.graphics.printf(love.timer.getFPS(), -10, 10, love.graphics.getWidth(), 'right')
		love.graphics.printf('SCORE :  ' .. __SCORE, 5, 10, love.graphics.getWidth(), 'left')
		love.graphics.draw(Player.Sprite[math.floor(Player.currentframe + 0.5)], Player.x, Player.y)
		
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
				GameMode = 'StartDelay'
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