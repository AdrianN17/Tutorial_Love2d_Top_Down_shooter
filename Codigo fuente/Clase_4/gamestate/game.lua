local Gamestate = require "libs.gamestate"
local base = require "gamestate.base"
local Class = require "libs.class"


local game = Class{
	__includes = base
}

function game:init()

end

function game:enter()
	base.entidades:clear()
	base.init(self,"assets/mapas/mapa.lua")

	self:layers()


	self:tiles(1)
	self:tiles(2)

	self:object()
end

function game:update(dt)

	self.map:update(dt)

	base.entidades:collisions()
end

function game:draw()
	self.map:draw(-900,-900,self.scale,self.scale)
end

function game:mousepressed(x,y,button)

end

function game:keypressed(key)

end

function game:keyreleased(key)

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

					be:add({body=self.collider:rectangle(tx+x,ty+y,w,h)},"destruible")
				end
			end
		end
	end

end

function game:object()
	local be=base.entidades

	for i, object in pairs(self.map.objects) do
		if object.name == "Player" then
			
		elseif object.name == "Caja" then

		elseif object.name == "Enemigo" then
			
		end
	end
end

function game:layers()
	local layer_personajes = self.map.layers["Personajes"]
	local layer_objetos = self.map.layers["Objetos"]

	be=base.entidades

	function layer_personajes:draw()
		be:balas_draw()
		be:enemigos_draw()
		be:player_draw()
	end

	function layer_personajes:update(dt)
		be:balas_update(dt)
		be:enemigos_update(dt)
		be:player_update(dt)
	end

	function layer_objetos:draw()
		be:objetos_draw()
	end

	function layer_objetos:update(dt)
		be:objetos_update(dt)
	end

end

return game