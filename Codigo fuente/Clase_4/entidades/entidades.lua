
local entidades = {
	map=nil,
	cam=nil,
	player=nil,
	enemigos={},
	solidos={},
	destruible={},
	objetos={},
	balas={}
}

function entidades:enter(map,cam)
	self.map=map
	self.cam=cam
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
	elseif tipo == "balas" then
		table.insert(self.balas,e)
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
	elseif tipo == "balas" then
		for i, ob in ipairs(self.balas) do
			if ob == e then
				table.remove(self.balas,i)
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
	self.balas={}
end

-- para actualizar mapa
function entidades:player_draw()

end

function entidades:player_update(dt)

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

--colisiones

function entidades:collisions()

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

return entidades