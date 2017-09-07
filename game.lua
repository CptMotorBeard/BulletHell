Game = {}
Game.__index = Game

function Game.new()
	return setmetatable({
	},
	Game)
end

setmetatable(Game, {__call = function(_, ...) return Game.new(...) end})