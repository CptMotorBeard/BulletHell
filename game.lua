require 'enemy'

Levels = 
{
	{
		numRounds = 1,
		Enemies =
		{
			{Enemy(1), Enemy(2)}
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

function Game:spawnEnemies()
	if (not self.enemies) or table.getn(self.enemies) == 0 then
		if self.level > table.getn(Levels) then
			return 'win'
		end
		local curLevel = Levels[self.level]
		if self.curSection > curLevel.numRounds then
			self.level = self.level + 1
			if self.level > table.getn(Levels) then
				return 'win'
			end
			self.curSection = 0
			curLevel = Levels[level]			
		end
		self.curSection = self.curSection + 1
		self.enemies = curLevel.Enemies[self.curSection]
	end
end

function Game:enemyHit(index)
	table.remove(self.enemies, index)
end