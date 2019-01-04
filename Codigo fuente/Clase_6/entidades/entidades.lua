

local entidades = {
	map=nil,
	cam=nil,
	collider=nil,
	player=nil,
	enemigos={},
	timer_player=nil,
	timer_enemigo=nil,
	solidos={},
	destruible={},
	objetos={},
	balas={{},{}},
	limites={}
}

function entidades:enter(map,cam,collider,timer_player,timer_enemigo)
	self.map=map
	self.cam=cam
	self.collider=collider
	self.timer_player=timer_player
	self.timer_enemigo=timer_enemigo
end

function entidades:actor(actor)
	self.player=actor
end

function entidades:add(e,tipo)
	if tipo == "enemigos" then
		table.insert(self.enemigos,e)
	elseif tipo == "solidos" then
		table.insert(self.solidos,e)
	elseif tipo == "destruible" then
		table.insert(self.destruible,e)
	elseif tipo == "objetos" then
		table.insert(self.objetos,e)
	elseif tipo == "balas_p" then
		table.insert(self.balas[1],e)
	elseif tipo == "balas_e" then
		table.insert(self.balas[2],e)
	end
end

function entidades:remove(e,tipo)
	if tipo == "enemigos" then
		for i, ob in ipairs(self.enemigos) do
			if ob == e then
				table.remove(self.enemigos,i)
				return
			end
		end
	elseif tipo == "solidos" then
		for i, ob in ipairs(self.solidos) do
			if ob == e then
				table.remove(self.solidos,i)
				return
			end
		end
	elseif tipo == "destruible" then
		for i, ob in ipairs(self.destruible) do
			if ob == e then
				table.remove(self.destruible,i)
				return
			end
		end
	elseif tipo == "objetos" then
		for i, ob in ipairs(self.objetos) do
			if ob == e then
				table.remove(self.objetos,i)
				return
			end
		end
	elseif tipo == "balas_p" then
		for i, ob in ipairs(self.balas[1]) do
			if ob == e then
				table.remove(self.balas[1],i)
				return
			end
		end
	elseif tipo == "balas_e" then
		for i, ob in ipairs(self.balas[2]) do
			if ob == e then
				table.remove(self.balas[2],i)
				return
			end
		end
	end
end

function entidades:clear()
	self.map=nil
	self.player=nil
	self.enemigos={}
	self.solidos={}
	self.destruible={}
	self.objetos={}
	self.balas={{},{}}
	self.limites={}
end

function entidades:position()
	return self.player.ox,self.player.oy
end

-- para actualizar mapa
function entidades:player_draw()
	self.player:draw()

	for _, e in ipairs(self.balas[1]) do
		e:draw()
	end
end

function entidades:player_update(dt)
	self.player:update(dt)

	self.timer_player:update(dt)

	for _, e in ipairs(self.balas[1]) do
		e:update(dt)
	end
end

function entidades:enemigos_draw()

end

function entidades:enemigos_update(dt)

end

function entidades:objetos_draw()

end

function entidades:objetos_update(dt)

end

function entidades:balas_draw()

end

function entidades:balas_update(dt)

end

function entidades:getmouseposition()
	return self.cam:toWorld(love.mouse.getX( ),love.mouse.getY( ))	
end

function entidades:limit(table)
	self.limites = table
end

--colisiones

function entidades:collisions()
	for _,solido in ipairs(self.solidos) do
		local dx,dy,collision=0,0,false
		collision,dx,dy= self.player.body:collidesWith(solido.body) 

		if collision then
			self.player.body:move(dx,dy)
		end
	end

	for _,destruible in ipairs(self.destruible) do
		local dx,dy,collision=0,0,false
		collision,dx,dy= self.player.body:collidesWith(destruible.body) 

		if collision then
			self.player.body:move(dx,dy)
		end
	end
end

function entidades:keypressed(key)
	self.player:keypressed(key)
end

function entidades:keyreleased(key)
	self.player:keyreleased(key)
end

function entidades:mousepressed(x, y, button)
	self.player:mousepressed(x, y, button)
end

function entidades:mousereleased(x, y, button)
	self.player:mousereleased(x, y, button)
end

function entidades:replace_tile(layer, tilex, tiley, newTileGid)
	local x=(tilex/self.map.tilewidth)+1
	local y=(tiley/self.map.tileheight)+1

	layer = self.map.layers[layer]
	for i, instance in ipairs(self.map.tileInstances[layer.data[y][x].gid]) do
		if instance.layer == layer and instance.x == tilex and instance.y == tiley then
		  instance.batch:set(instance.id, self.map.tiles[newTileGid].quad, instance.x, instance.y)
		  break
		end
	end
end

function entidades:replace_object(object,gid_tile)
	for i, instance in ipairs(self.map.tileInstances[object.gid]) do
  		if object.x == instance.x and object.y  == instance.y then
      		instance.batch:set(instance.id, self.map.tiles[gid_tile].quad, object.x,object.y)
      		break
      	end
  	end
end

return entidades