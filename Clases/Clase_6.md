# Creación y animación del enemigo y objetos del mapa

En la clase anterior, vimos lo que es la creación de nuestro jugador, sus estados y acciones, ademas de la animación con la cual este contaría, ahora para dar mayor interacción a nuestro jugador, nos toca dar vida a nuestro enemigo.

## El enemigo

Para no tocar temas muy profundos como IA o pathfinding A*, u otra manera de darle un razonamiento, y para no alargar mucho mas nuestro tutorial, nuestro enemigo solo tendra una funcion:

Puede:

* Atravesar paredes, pero de manera muy lenta, las va a saltar
* Destruir barricadas, pero demorara un tiempo en realizarlo
Seguir al jugador a donde quiera que vaya

No puede:

* Disparar

Ahora, nuestro enemigo se regenerara las veces que sea necesario, una cantidad infinita de veces, hasta que nuestro jugador muera.

Lo que primero realizaremos es editar nuestro archivo enemigos.lua
```lua
--enemigos.lua
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

return enemigos
```

Agregamos nuestro objeto en game.lua

```lua
function game:object()
	...
	
	elseif object.name == "Enemigo" then
		be:add(Zombie(object.x,object.y,object.width,object.height),"enemigos")
	end
end
```

Y finalmente en nuestra funcion entidades.lua

```lua
--entidades.lua

function entidades:player_draw()
	self.player:draw()

	for _, e in ipairs(self.balas) do
		e:draw()
	end

	for _, e in ipairs(self.enemigos) do
		e:draw()
	end
end

function entidades:player_update(dt)
	self.player:update(dt)

	self.timer_player:update(dt)

	self.timer_enemigo:update(dt)

	for _, e in ipairs(self.balas) do
		e:update(dt)
	end

	for _, e in ipairs(self.enemigos) do
		e:update(dt)
	end
end

function entidades:seek_player()
	self.timer_enemigo:every(2, function() 
		for _, zombie in ipairs(self.enemigos) do
			if zombie.visible then
				zombie.radio=math.atan2(self.player.oy-zombie.oy,self.player.ox-zombie.ox)
				zombie.delta.y=math.sin(zombie.radio)
				zombie.delta.x=math.cos(zombie.radio)
				--zombie.delta:rotateInplace(zombie.radio)
			end
		end
	end)

	self.timer_enemigo:every(0.5, function() 
		for _, zombie in ipairs(self.enemigos) do
			if not zombie.collision then
				zombie.velocidad=250
			end
		end
	end)
end

function entidades:collisions()
	for _,solido in ipairs(self.solidos) do
		local dx,dy,collision=0,0,false
		collision,dx,dy= self.player.body:collidesWith(solido.body) 

		if collision then
			self.player.body:move(dx,dy)
		end

		for _,zombie in ipairs(self.enemigos) do
			local dx,dy,collision=0,0,false
			collision,dx,dy= zombie.body:collidesWith(solido.body) 

			if collision then
				zombie.velocidad=50
				zombie.collision=true
			end
		end
	end

	for _,destruible in ipairs(self.destruible) do
		local dx,dy,collision=0,0,false
		collision,dx,dy= self.player.body:collidesWith(destruible.body) 

		if collision then
			self.player.body:move(dx,dy)
		end
	end

	for _,zombie_1 in ipairs(self.enemigos) do
		for _,zombie_2 in ipairs(self.enemigos) do
			local dx,dy,collision=0,0,false
			collision,dx,dy= zombie_1.body:collidesWith(zombie_2.body) 

			if collision then
				zombie_1.body:move(dx,dy)
			end
		end
	end

end
function entidades:script()

	for _, zombie in ipairs(self.enemigos) do
		if self:camera_visible(zombie) and not zombie.visible then
			zombie:start()
		end
	end
end

```

Lo que hacemos es enviarle la distancia entre el jugador y el zombie para que este lo siga, pero en un intervalo de tiempo predeterminado, ademas el zombie te seguirá cuando lo veas en pantalla, cambiando de inmovil a movil en 1 segundo,  ademas de que estan separados unos de otros.

Lo que a continuacion haremos será eliminarlos con nuestras balas, para ello crearemos la siguiente funcion en entidades.lua :

```lua
entidades.lua

```

