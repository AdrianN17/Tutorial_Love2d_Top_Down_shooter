local Class = require "libs.class"
local base = require "gamestate.base"
local entidad = require "entidades.entidad"
local vector = require "libs.vector"

local enemigos = Class{
	__includes = entidad
}

function enemigos:init(x,y,w,h)

	self.body=base.entidades.collider:rectangle(x,y,w,h)
	self.w,self.h=w,h

	self.velocidad=250

	self.spritesheet=spritesheet.img
	self.imgs=spritesheet.enemigo

	self.posicion=1

	self.radio=0

	self.hp=6

	self.ox,self.oy=self.body:center()

	self.visible=false

	self.delta = vector(0,0) 

	self.collision=false

	self.daño=2

end

function enemigos:draw()
	love.graphics.print(self.velocidad,self.ox,self.oy-100)
	love.graphics.draw(self.spritesheet,self.imgs[self.posicion],self.ox,self.oy,self.radio,1,1,self.w/2,self.h/2)

end

function enemigos:update(dt)
	local delta= self.delta * self.velocidad *dt



	self.body:move(delta:unpack())

	self.body:setRotation(self.radio)

	self.ox,self.oy=self.body:center()

	self.collision=false
	
end

function enemigos:start()

	self.visible=true

	base.entidades.timer_enemigo:after(1, function() self.posicion=2 end)
end

function enemigos:damage(agresor)

	self.hp=self.hp-agresor.daño

	base.entidades:remove(agresor,"balas")

	if self.hp<1 then
		base.entidades:remove(self,"enemigos")
	end
end

return enemigos