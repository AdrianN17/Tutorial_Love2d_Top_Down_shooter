local Gamestate = require "libs.gamestate"
local base = require "gamestate.base"
local Class = require "libs.class"
local sprites = require "assets.img.sprites"

spritesheet=nil
local camview={x=0,y=0,w=0,h=0}

local Player = require "entidades.player"



local game = Class{
	__includes = base
}

function game:init()
	spritesheet = sprites
end

function game:enter()
	base.entidades:clear()
	base.init(self,"assets/mapas/mapa.lua")

	self:layers()


	self:tiles(1)
	self:tiles(2)

	self:object()

	self.map:removeLayer("Borrador")
end

function game:update(dt)

	self.map:update(dt)

	base.entidades:collisions()

	base.entidades:limit(camview)
end

function game:draw()
	camview.x,camview.y,camview.w,camview.h=self.cam:getVisible()
	self.map:draw(-camview.x,-camview.y,self.scale,self.scale)
	self.cam:setPosition(base.entidades:position())
end

function game:mousepressed(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	base.entidades:mousepressed(cx,cy,button)
end

function game:mousereleased(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	base.entidades:mousereleased(cx,cy,button)
end

function game:keypressed(key)
	base.entidades:keypressed(key)
end

function game:keyreleased(key)
	base.entidades:keyreleased(key)
end

function game:tiles(pos)

	local be=base.entidades
	

	for y=1, self.map.height,1 do
		for x=1,self.map.width,1 do
			local tile = self.map.layers[pos].data[y][x]
			if tile then
				if tile.properties.Solido then
					be:add({body=self.collider:rectangle((x-1)*self.map.tilewidth,(y-1)*self.map.tileheight,self.map.tilewidth,self.map.tileheight)},"solidos")
				elseif tile.properties.Pared and tile.properties.Circular then
					local tx,ty=(x-1)*self.map.tilewidth,(y-1)*self.map.tileheight

					local objectgroup=tile.objectGroup.objects
					local x,y,w,h
					for _, obj in pairs(objectgroup) do
						x,y,w,h=obj.x,obj.y,obj.width,obj.height
					end

					local r=math.pow(w*h,1/2)/2

					be:add({body=self.collider:circle(tx+x+r,ty+y+r,r)},"solidos")

				elseif tile.properties.Pared and not tile.properties.Circular then

					be:add({body=self.collider:rectangle((x-1)*self.map.tilewidth,(y-1)*self.map.tileheight,self.map.tilewidth,self.map.tileheight)},"solidos")

				elseif tile.properties.Destruible then

					local tx,ty=(x-1)*self.map.tilewidth,(y-1)*self.map.tileheight
					local objectgroup=tile.objectGroup.objects
					local x,y,w,h

					for _, obj in pairs(objectgroup) do
						x,y,w,h=obj.x,obj.y,obj.width,obj.height
					end

					be:add({body=self.collider:rectangle(tx+x,ty+y,w,h),x=tx,y=ty,hp=5,gid=tile.gid, tipo="pared"},"destruible")
				end
			end
		end
	end

end

function game:object()
	local be=base.entidades

	for i, object in pairs(self.map.objects) do
		if object.name == "Player" then
			be:actor(Player(object.x,object.y,object.width,object.height))
		elseif object.name == "Caja" then
			be:add({body=self.collider:rectangle(object.x,object.y,object.width,-object.height),hp=5},"destruible")
		elseif object.name == "Enemigo" then
			
		end
	end
end

function game:layers()
	local layer_personajes = self.map.layers["Personajes"]

	be=base.entidades

	function layer_personajes:draw()
		be:balas_draw()
		be:enemigos_draw()
		be:player_draw()

		be:objetos_draw()
	end

	function layer_personajes:update(dt)
		be:balas_update(dt)
		be:enemigos_update(dt)
		be:player_update(dt)

		be:objetos_update(dt)
	end
end

return game