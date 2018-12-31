local Class = require "libs.class"
local base = require "gamestate.base"
local entidad = require "entidades.entidad"
local HC = require "libs.HC"
local Timer = require "libs.timer"
local vector = require "libs.vector"

local player = Class{
	__includes = entidad
}

function player:init()

end

function player:draw()

end

function player:update(dt)

end

function player:mousepressed(x,y,button)

end

function player:keypressed(key)

end

function player:keyreleased(key)

end

return player