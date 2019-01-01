local Gamestate = require "libs.gamestate"
local Class = require "libs.class"
local entidades = require "entidades.entidades"
local sti= require "libs.sti"
local gamera = require "libs.gamera"
local HC = require "libs.HC"
local Timer = require "libs.timer"

local base = Class{
	__includes = Gamestate,
	init = function(self, mapfile)
	self.map=sti(mapfile)
	self.scale=0.7
	self.cam=self.gamera.new(0,0,self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight)
	self.cam:setScale(self.scale)
	self.map:resize(love.graphics.getWidth()*2,love.graphics.getHeight()*2)
	self.collider = HC.new()
	entidades:enter(self.map,self.cam,self.collider)
	end;
	entidades = entidades;
	gamera = gamera;
}

return base