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
	
	self.daño=2

end

function enemigos:draw()
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

end

function entidades:player_update(dt)
	self.player:update(dt)

	self.timer_player:update(dt)
	
end

function entidades:enemigos_draw()
	for _, e in ipairs(self.enemigos) do
		e:draw()
	end
end

function entidades:enemigos_update(dt)
	self.timer_enemigo:update(dt)

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
function entidades:collisions()
	...
	
	for _,destruible in ipairs(self.destruible) do
		local dx,dy,collision=0,0,false
		collision,dx,dy= self.player.body:collidesWith(destruible.body) 

		if collision then
			self.player.body:move(dx,dy)
		end

		for _,bala in ipairs(self.balas) do
			local dx,dy,collision=0,0,false
			collision,dx,dy=destruible.body:collidesWith(bala.body) 

			if collision then
				destruible.hp=destruible.hp-bala.daño
				self:remove(bala,"balas")
				print(destruible.hp)
			end
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

		for _,bala in ipairs(self.balas) do

			local dx,dy,collision=0,0,false
			collision,dx,dy=zombie_1.body:collidesWith(bala.body) 

			if collision then
				zombie_1:damage(bala)
			end
		end
	end
end
```

Y agregamos adicionalmente la colisión bala-pared, para que nuestras balas se eliminen a tocar algo solido, solo nos faltaría agregar la función damage en nuestro archivo enemigos.lua

```lua
--enemigos.lua
function enemigos:damage(agresor)

	self.hp=self.hp-agresor.daño

	base.entidades:remove(agresor,"balas")

	if self.hp<1 then
		base.entidades:remove(self,"enemigos")
	end
end


```

Lo que tendríamos seria algo así:

![alt text](https://i.imgur.com/XRPRX5H.png)

Y podemos hacer que nuestros enemigos desaparezcan, solo con dispararles las veces que sea necesario.

Pero, nos tocan y no nos hacen nada.

Para ello, agregaremos las colisiones player - zombies, añadiendo la funcion damage en player.lua y la colision en entidades.lua

```lua
--player.lua
function player:damage(agresor)

	self.hp=self.hp-agresor.daño
	
	if self.hp<1 then

	end

	self.estado.inmunidad=true

	base.entidades.timer_player:after(1, function() self.estado.inmunidad=false end)
end
```

```lua
--entidades.lua
function entidades:collisions()
	for _,zombie_1 in ipairs(self.enemigos) do
		local dx,dy,collision=0,0,false
		collision,dx,dy= self.player.body:collidesWith(zombie_1.body) 

		if collision and not self.player.estado.inmunidad then
			self.player:damage(zombie_1)
		end

		...
	end
end

```

Nuestro personaje cuenta con 1 segundo de inmunidad al ser golpeado por un zombie, aun nos faltaria agregar que hacer en el caso que llegue a 0 nuestra vida. Podriamos destruir el objeto, tal como hacemos con las balas y zombies, pero nos dara un error, ya que de todas maneras lo utilizamos. Pero dejaremos esto para más adelante ...

Ahora nos toca la creación de objetos en nuestro mapa:

## Creación y animación de objetos del mapa.

Para comenzar, crearemos nuestro objeto en el archivo municion.lua

```lua
--municion,lua
local Class = require "libs.class"
local base = require "gamestate.base"
local entidad = require "entidades.entidad"

local municion = Class{
	__includes = entidad
}

function municion:init(x,y)
	self.body=base.entidades.collider:circle(x,y,16)

	self.ox,self.oy=self.body:center()

	self.tipo=love.math.random(1,3)

	self.spritesheet=spritesheet.img2
	self.img=spritesheet.balas[self.tipo]
end

function municion:draw()
	love.graphics.draw(self.spritesheet,self.img,self.ox,self.oy,0,2,2,8,8)
end

return municion
```

Seguidamente, lo invocaremos en nuestra función game.lua, agregaremos en los layers para que pueda ser dibujado. Ademas de una función nueva que se encarga de destruir si una bala toca repetidas veces un objeto destruible, destruyéndolo y cambiándole la imagen

```lua
--game.lua

...

local Municion = require "entidades.municion"

...

function game:layers()
	local layer_personajes = self.map.layers["Personajes"]

	be=base.entidades

	function layer_personajes:draw()
		be:objetos_draw()
		be:balas_draw()
		be:enemigos_draw()
		be:player_draw()
	end

	function layer_personajes:update(dt)
		be:player_update(dt)
		be:enemigos_update(dt)
		be:balas_update(dt)
		be:objetos_update(dt)
	end
end

function game:change_items()
	local be=base.entidades

	for _,destruible in ipairs(be.destruible) do
		if destruible.hp<1 and destruible.tipo=="caja" then
			local x,y=destruible.body:center()
			be:add(Municion(x,y),"objetos")
			be:remove(destruible,"destruible")
			be:replace_object(destruible,265)
		elseif destruible.hp< 1 and destruible.tipo=="pared" then
			local random={265,292}
			be:remove(destruible,"destruible")
			be:replace_tile(2,destruible,random[love.math.random(1,2)])
		end
	end
end

```

Ademas de las colisiones en entidades.lua

```lua
--entidades.lua

function entidades:collisions()

	...
	
	for _,destruible in ipairs(self.destruible) do
		local dx,dy,collision=0,0,false
		collision,dx,dy= self.player.body:collidesWith(destruible.body) 

		if collision then
			self.player.body:move(dx,dy)
		end

		for _,bala in ipairs(self.balas) do
			local dx,dy,collision=0,0,false
			collision,dx,dy=destruible.body:collidesWith(bala.body) 

			if collision then
				destruible.hp=destruible.hp-bala.daño
				self:remove(bala,"balas")
			end
		end
	end

	...
end
```
El resultado:

![alt text](https://i.imgur.com/TNhugNc.png)

Además, nos faltaría la creación de vidas para nuestro jugador, para ello buscaremos las siguientes [imagenes](https://kenney.nl/assets/ui-pack-space-expansion)

Elegimos las siguientes imágenes de la carpeta PNG, en mi caso elegiré las siguientes, pero es opcional:

![alt text](https://i.imgur.com/oXIA58U.png)

Creamos un spritesheet con nuestra [herramienta](http://zerosprites.com/), tal como el anterior le damos un padding de 5 px y listo, ya tenemos nuestro spritesheet para nuestra ui y vida.

```lua
--sprites.lua
	sprites["img3"]= love.graphics.newImage("assets/img/sprites_2.png")

	sprites["vida"] = love.graphics.newQuad(155,153,24,24,sprites["img3"]:getDimensions())

	sprites["hp"]={}
	sprites["hp"][1]= love.graphics.newQuad(196,75,6,26,sprites["img3"]:getDimensions())
	sprites["hp"][2]= love.graphics.newQuad(184,151,16,26,sprites["img3"]:getDimensions())
	sprites["hp"][3]= love.graphics.newQuad(196,106,6,26,sprites["img3"]:getDimensions())

	sprites["ui"]= love.graphics.newQuad(50,75,100,100,sprites["img3"]:getDimensions())

	sprites["mouse"]={}
	sprites["mouse"][1]= love.graphics.newQuad(155,75,36,36,sprites["img3"]:getDimensions())
	sprites["mouse"][2]= love.graphics.newQuad(157,116,30,30,sprites["img3"]:getDimensions())
```

Lo agregamos a nuestro archivo sprites.lua.

Invocamos el objeto en game.lua

```lua
--game.lua
local Vida = require "entidades.vida"
```

Y en la funcion change_items, agregamos debajo de **destruible.tipo=="caja"** una probabilidad de que salga vida o municion.
```lua
--game.lua
local x,y=destruible.body:center()
local random= love.math.random(1,10)

if random >=5 then
	be:add(Municion(x,y),"objetos")
else
	be:add(Vida(x,y),"objetos")
end
```
Y ademas creamos una funcion reload, tanto para municion, como para vida.lua

```lua
--municion.lua
function municion:init(x,y)	

	...
	
	if self.tipo==2 then
		self.cantidad=love.math.random(15,40)
	elseif self.tipo==3 then
		self.cantidad=love.math.random(10,30)
	end
end

function municion:reload(tabla)
	local be=base.entidades

	if tabla.municion[self.tipo]+self.cantidad< tabla.max_municion[self.tipo] then
		tabla.municion[self.tipo]=tabla.municion[self.tipo]+self.cantidad
		self.cantidad=0
		be:remove(self,"objetos")
	else
		local muni=tabla.max_municion[self.tipo]-tabla.municion[self.tipo]
		tabla.municion[self.tipo]=tabla.municion[self.tipo]+muni
		self.cantidad=self.cantidad-muni
	end
end

```

```lua
--vida.lua
function vida:reload(tabla)

	if tabla.hp < 10 then
		tabla.hp=tabla.hp+2

		if tabla.hp>10 then
			tabla.hp=10
		end

		local be=base.entidades

		be:remove(self,"objetos")
	end

end
```

La implementamos en entidades.lua

```lua
--entidades.lua
function entidades:collisions()
	
	...
	
	for _, objeto in ipairs(self.objetos) do
		local dx,dy,collision=0,0,false
		collision,dx,dy= self.player.body:collidesWith(objeto.body) 

		if collision then
			objeto:reload(self.player)
		end
	end
end
```
Ahora, agregamos para finalizar el siguiente script, con el cual el enemigo podra romper paredes y cajas.

```lua
--entidades.lua
function entidades:collisions()

	...
	
	for _,destruible in ipairs(self.destruible) do
		local dx,dy,collision=0,0,false
		collision,dx,dy= self.player.body:collidesWith(destruible.body) 

		if collision then
			self.player.body:move(dx,dy)
		end

		for _,bala in ipairs(self.balas) do
			local dx,dy,collision=0,0,false
			collision,dx,dy=destruible.body:collidesWith(bala.body) 

			if collision then
				destruible.hp=destruible.hp-bala.daño
				self:remove(bala,"balas")
			end
		end

		for _,zombie in ipairs(self.enemigos) do
			local dx,dy,collision=0,0,false
			collision,dx,dy=zombie.body:collidesWith(destruible.body) 

			if collision then
				zombie.body:move(dx,dy)

				if  not zombie.atacando then
					destruible.hp=destruible.hp-zombie.daño
					zombie.atacando=true

					self.timer_enemigo:after(1, function () zombie.atacando=false end)
				end
			end
		end
	end

	...
	
end
```

Ademas de agregarle a enemigos.lua un atributo más
```lua
--enemigos.lua
function enemigos:init(x,y,w,h)
	
	...
	
	self.atacando=false

end
```

El resultado final seria:

![alt text](https://i.imgur.com/lOxlrC6.png)

Para finalizar, cuando terminamos, los enemigos ya no se regeneran, para ello haremos que regeneren de manera ilimitada.

Creamos un contador en nuestro archivo entidades.lua

```lua
--entidades.lua
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
	balas={},
	limites={},
	respawn_enemigos={},
	cantidad_zombies=0
}

end

function entidades:clear()
	self.map=nil
	self.player=nil
	self.enemigos={}
	self.solidos={}
	self.destruible={}
	self.objetos={}
	self.balas={}
	self.limites={}
	self.respawn_enemigos={}
	self.cantidad_zombies=0
end

function entidades:respawn_all(objeto)
	for _, posicion in ipairs(self.respawn_enemigos) do
		self:add(objeto(posicion.x,posicion.y),"enemigos")
	end

	self.cantidad_zombies=self.cantidad_zombies+7
end

function entidades:respawn_random(objeto)
	local seed = love.math.random(1,7)
	local tabla=self.respawn_enemigos[seed]
	self:add(objeto(tabla.x,tabla.y) ,"enemigos")

	self.cantidad_zombies=self.cantidad_zombies+1
end
```

Ademas modificamos nuestros archivo enemigos.lua
```lua
--enemigos.lua
function enemigos:init(x,y)

	self.body=base.entidades.collider:rectangle(x,y,35,43)

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

	self.atacando=false

end

function enemigos:draw()
	love.graphics.print(self.velocidad,self.ox,self.oy-100)
	love.graphics.draw(self.spritesheet,self.imgs[self.posicion],self.ox,self.oy,self.radio,1,1,35/2,43/2)

end
```
Y game.lua:

```lua
--game.lua
local intervalo=0

function game:enter()
	intervalo=2.5

	base.entidades:clear()
	base.init(self,"assets/mapas/mapa.lua")

	self:layers()


	self:tiles(1)
	self:tiles(2)

	self:object()

	self.map:removeLayer("Borrador")

	base.entidades:respawn_all(Zombie)


	base.entidades:seek_player()

	base.entidades.timer_player:every(intervalo, function() 
		local be=base.entidades

		if be.cantidad_zombies<1 then
			be:respawn_all(Zombie)
		else
			be:respawn_random(Zombie)
		end
	end)

	base.entidades.timer_player:every(25, function() 
		if intervalo>0.75 then
			intervalo=intervalo-0.25
		end

	end)
end

function game:object()
	local be=base.entidades

	for i, object in pairs(self.map.objects) do
		if object.name == "Player" then
			be:actor(Player(object.x,object.y,object.width,object.height))
		elseif object.name == "Caja" then
			be:add({body=self.collider:rectangle(object.x,object.y,object.width,-object.height),hp=5,tipo="caja",gid=object.gid, x=object.x, y=object.y-object.height},"destruible")
		elseif object.name == "Enemigo" then
			table.insert(be.respawn_enemigos,{x = object.x , y = object.y})
		end
	end
end
```

Lo que haremos es coger las posiciones y cada cierto tiempo se crearan nuevos zombies, ademas de que se regulara la cantidad de apariciones o el intervalo cada cierto tiempo.

Y nuestro resultado debe ser algo así:

![alt text](https://i.imgur.com/S31DQQR.png)

Y con esto finalizamos lo que sería nuestro videojuego.