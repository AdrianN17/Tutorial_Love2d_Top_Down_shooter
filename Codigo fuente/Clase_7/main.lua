local Gamestate = require "libs.gamestate"
local game= require "gamestate.game"


function love.load()
	love.mouse.setVisible(false)
	Gamestate.registerEvents()
	Gamestate.switch(game)
end