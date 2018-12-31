local Gamestate = require "libs.gamestate"
local Class = require "libs.class"
local entidades = require "entidades.entidades"
local sti= require "libs.sti"
local gamera = require "libs.gamera"

local base = Class{
	__includes = Gamestate,
	init = function(self, mapfile)
	self.map=sti(mapfile)
	self.gamera=gamera
	self.scale=0.7
	self.cam=self.gamera.new(0,0,self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight)
	self.cam:setScale(self.scale)
	self.map:resize(love.graphics.getWidth()*2,love.graphics.getHeight()*2)
	entidades:enter(self.map,self.gamera)
	end;
	entidades = entidades;
	gamera = gamera;
}

return base