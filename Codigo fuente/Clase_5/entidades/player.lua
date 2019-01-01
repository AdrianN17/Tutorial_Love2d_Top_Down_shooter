local Class = require "libs.class"
local base = require "gamestate.base"
local entidad = require "entidades.entidad"

local vector = require "libs.vector"

local player = Class{
	__includes = entidad
}

function player:init(x,y,w,h)
	self.body=base.entidades.collider:rectangle(x,y,w,h)
	self.w,self.h=w,h
	self.ox,self.oy=self.body:center()

	self.radio=0
	self.velocidad=500
	self.hp=10

	self.estado={ correr = false, inmunidad = false, vida = true}

	self.direccion={a = false, s = false, d = false, w = false}

	self.spritesheet=spritesheet

	self.posicion=1
end

function player:draw()
	love.graphics.draw(self.spritesheet.img,self.spritesheet.player[self.posicion],self.ox,self.oy,self.radio,1,1,self.w/2,self.h/2)
end

function player:update(dt)
	local delta = vector(0,0)


	if self.direccion.a then
		delta.x=-1
	elseif self.direccion.d then
		delta.x=1
	end

	if self.direccion.w then
		delta.y=-1
	elseif self.direccion.s then
		delta.y=1
	end

	delta:normalizeInplace()

	delta=delta+ delta * self.velocidad *dt

	
    self.body:move(delta:unpack())

	self.ox,self.oy=self.body:center()


end

function player:mousepressed(x,y,button)

end

function player:keypressed(key)
	if key=="a" then
		self.direccion.a=true
	elseif key=="d" then
		self.direccion.d=true
	end

	if key=="w" then
		self.direccion.w=true
	elseif key=="s" then
		self.direccion.s=true
	end
end

function player:keyreleased(key)
	if key=="a" then
		self.direccion.a=false
	elseif key=="d" then
		self.direccion.d=false
	end

	if key=="w" then
		self.direccion.w=false
	elseif key=="s" then
		self.direccion.s=false
	end
end

return player