local Gamestate = require "libs.gamestate"
local base = require "gamestate.base"
local Class = require "libs.class"
local HC = require "libs.HC"

local game = Class{
	__includes = base
}

function game:init()

end

function game:enter()
	base.entidades:clear()
	base.init(self,"assets/mapas/mapa.lua")
end

function game:update(dt)
	self.map:update(dt)
end

function game:draw()
	self.map:draw(-0,-0,self.scale,self.scale)
end

function game:mousepressed(x,y,button)

end

function game:keypressed(key)

end

function game:keyreleased(key)

end

return game