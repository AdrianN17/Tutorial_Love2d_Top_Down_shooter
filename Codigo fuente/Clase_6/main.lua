local Gamestate = require "libs.gamestate"
local game= require "gamestate.game"


function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(game)
end