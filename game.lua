require 'enemy'

--[[
	Levels is split up into each stage
	Each stage has several parts, which is defined by the enemies in those parts
	We define the number of rounds for each stage, after all rounds are done, we move into the next stage
	
	Levels =
	{
		-- Level 1
		{
			numRounds, = -- However many rounds there are inside of Enemies
			Enemies =
			{
				-- Each item inside of this list is a new round. Fill with a list of new Enemy objects
			}
		}
		-- Level 2
		{} -- Fill similiarily
		-- Level 3 and so on
	}
]]--

-- Enemy(type, x, y, radius, points)

Levels = 
{
	-- Level 1
	{
		numRounds = 1,
		Enemies =
		{
			{Enemy(1, 100, 100, 10), Enemy(1, 200, 100, 10)}
		}
	}
}


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
		
		TODO:
		Put a delay between levels
]]--

function Game:Play(dt)
	if (not self.enemies) or #self.enemies == 0 then
		if self.level > #(Levels) then
			return 'win'
		end
		local curLevel = Levels[self.level]
		if self.curSection > curLevel.numRounds then
			self.level = self.level + 1
			if self.level > #(Levels) then
				return 'Win'
			end
			self.curSection = 0
			curLevel = Levels[level]			
		end
		self.curSection = self.curSection + 1
		self.enemies = curLevel.Enemies[self.curSection]
	else
		for index, enemy in ipairs(self.enemies) do
			enemy:move(dt)
			if 	enemy.body.x < (0 - enemy.body.radius) or
				enemy.body.x > (love.graphics.getWidth() + enemy.body.radius) or
				enemy.body.y < (0 - enemy.body.radius) or
				enemy.body.y > (love.graphics.getHeight() + enemy.body.radius) then
				table.remove(self.enemies, index)
			end
		end
	end
	return 'Play'
end

function Game:enemyHit(index)
	table.remove(self.enemies, index)
end