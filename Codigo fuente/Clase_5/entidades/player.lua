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

	self.estado={ correr = false, inmunidad = false, vida = true, disparo=false}

	self.direccion={a = false, s = false, d = false, w = false}

	self.spritesheet=spritesheet

	self.posicion=1

	self.arma=1
	self.municion={"infinito",0,0}
	self.stock={7,0,0}
	self.max_municion={"infinito",100,60}
	self.max_stock={7,25,20}

	base.entidades.timer_player:every(0.15, function() 
		if not self.estado.disparo then
			if self.direccion.a or self.direccion.d or self.direccion.s or self.direccion.w then
				if self.arma == 1 then
					self.posicion=2
				else
					self.posicion=3
				end
			else
				self.posicion=1
			end
		elseif  self.estado.disparo then
			if self.arma==1 then
				self.posicion=4
			elseif self.arma==2 then
				self.posicion=5
			elseif self.arma==3 then
				self.posicion=6
			end
		end
 	end)
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

	self.radio=self:angle()

	if self.estado.correr then
		if self.estado.disparo then
			self.estado.correr=false
		else
			self.velocidad=650
		end
	else
		self.velocidad=500
	end
end

function player:mousepressed(x,y,button)
	if button==1 then
		self.estado.disparo=true
	end
end

function player:mousereleased(x,y,button)
	if button==1 then
		self.estado.disparo=false
	end
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

	if key=="space" then
		self.estado.correr=true
	end

	if key=="1" then
		self.arma=1
	elseif key=="2" then
		self.arma=2
	elseif key=="3" then
		self.arma=3
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

	if key=="space" then
		self.estado.correr=false
	end
end

function player:angle()
	local angulo=0
	local mx,my=base.entidades:getmouseposition()
	angulo=math.atan2(my-self.oy,mx-self.ox)
	return angulo
end

return player