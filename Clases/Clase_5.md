# Creación y animación de personaje

Anteriormente habíamos creados las bases de nuestro juego, ahora nos toca crear a nuestro personaje y sus funcionalidades, para ello debemos definir como va a interactuar en nuestro juego.

Nuestro personaje puede:
* Caminar.
* Correr.
* Disparar.
* Recargar Balas.
* Curarse.
* Destruir paredes.
* Recibir daño de los enemigos.

Nuestro personaje no puede:
*  Sobrevivir mas de 10|5 balas|golpes de enemigos.
* Atravesar muro sólidos.
* Disparar continuamente.

Ya definiendo como se va a comportar nuestro jugador, lo primero es tener sus animaciones, por lo cual nos vamos a ayudar de una [herramienta](http://www.spritecow.com/) para dividir nuestro spritesheet en partes mas pequeñas.

Elegimos nuestro spritesheet y damos click a nuestro skin a elegir, en mi caso elegiré al robot.
Seleccionamos y guardamos las posiciones de las 5 imágenes, por ejemplo:

```
.sprite { background: url('imgs/spritesheet_characters.png') no-repeat -458px -88px; width: 33px; height: 43px; }
```
 
cogemos solo -458px -88px; width: 33px; height: 43px;

Los negativos lo pasamos a positivo y nos quedaría así:

458,88,33,43
**x,y,w,h**

Luego de haber apuntado las demás imágenes, ademas de nuestro zombie o enemigo a elegir, crearemos un archivo adicional en la carpeta assets, llamado sprites.lua

**Nota** : En nuestro mapa, las dimensiones de los objetos que era de 100 x 100, se han modificado a 35 x 43

```lua
--sprites.lua
local sprites={}

	sprites["img"]= love.graphics.newImage("assets/img/spritesheet_characters.png")

	sprites["player"]={}
	sprites["player"][1]= love.graphics.newQuad(458,88,33,43, sprites["img"]:getDimensions())
	sprites["player"][2]= love.graphics.newQuad(423,44,35,43, sprites["img"]:getDimensions())
	sprites["player"][3]= love.graphics.newQuad(306,88,39,43, sprites["img"]:getDimensions())
	sprites["player"][4]= love.graphics.newQuad(164,44,49,43, sprites["img"]:getDimensions())
	sprites["player"][5]= love.graphics.newQuad(55,176,54,43, sprites["img"]:getDimensions())
	sprites["player"][6]= love.graphics.newQuad(166,0,49,43, sprites["img"]:getDimensions())

	sprites["enemigo"]={}
	sprites["enemigo"][1]= love.graphics.newQuad(460,0,33,43, sprites["img"]:getDimensions())
	sprites["enemigo"][2]= love.graphics.newQuad(424,0,35,43, sprites["img"]:getDimensions())
	sprites["enemigo"][3]= love.graphics.newQuad(346,88,39,43, sprites["img"]:getDimensions())
	sprites["enemigo"][4]= love.graphics.newQuad(163,132,49,43, sprites["img"]:getDimensions())
	sprites["enemigo"][5]= love.graphics.newQuad(57,88,54,43, sprites["img"]:getDimensions())
	sprites["enemigo"][6]= love.graphics.newQuad(162,176,49,43, sprites["img"]:getDimensions())
return sprites
```
Ahora, lo llamamos en nuestro archivo game.lua, y lo mandaremos como variable global para los demás objetos.

```lua
--game.lua

--las librerias llamadas
local sprites = require "assets.img.sprites"

spritesheet=nil

local game = Class{
	__includes = base
}

function game:init()
	spritesheet = sprites
end

...

```

Ahora creamos 5 archivos, player.lua, enemigos.lua, bala.lua, municion.lua y vida.lua, todo en nuestra carpeta entidades.

En nuestro archivo player.lua, debemos implementar el siguiente código.
```lua
local Class = require "libs.class"
local base = require "gamestate.base"
local entidad = require "entidades.entidad"
local HC = require "libs.HC"
local Timer = require "libs.timer"
local vector = require "libs.vector"

local player = Class{
	__includes = entidad
}

function player:init(x,y,w,h)

end

function player:draw()

end

function player:update(dt)

end

function player:mousepressed(x,y,button)

end

function player:mousereleased(x,y,button)

end

function player:keypressed(key)

end

function player:keyreleased(key)

end

return player
```

Lo que hacemos es crear las bases de nuestro objeto, llamando como molde nuestro archivo entidad.lua.

Ahora, lo que hacemos es recibir los datos de inicializacion para nuestro objeto player.

```lua
--player.lua
function player:init(x,y,w,h)
	self.body=HC.rectangle(x,y,w,h)
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
```

Editamos nuestra función de dibujado y actualizacion en entidades.lua

```lua
--entidades.lua
function entidades:player_draw()
	self.player:draw()
end

function entidades:player_update(dt)
	self.player:update(dt)
end
```
Implementamos finalmente en el archivo game.lua nuestro objeto

```lua
--game.lua
local Player = require "entidades.player"

....

function game:object()
	local be=base.entidades

	for i, object in pairs(self.map.objects) do
		if object.name == "Player" then
			be:actor(Player(object.x,object.y,object.width,object.height))
		elseif object.name == "Caja" then

		elseif object.name == "Enemigo" then
			
		end
	end
end
```

Implementamos un vector de movimiento para que nuestro jugador se mueva.
```lua
--player.lua
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
    
	self.body:setRotation(self.radio)

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
```
Lo que resultaría, algo asi:

![alt text](https://i.imgur.com/AeX9M77.png)

Para ocultar ese rectángulo blanco, eliminaremos la capa borrador de nuestro mapa.
Solo bastaría ingresar el siguiente código en nuestro archivo game.lua:

```lua
--game.lua
function game:enter()

	...
	
	self.map:removeLayer("Borrador")
end
```
Ahora, nos faltaría darle movimiento con el mouse y hacer que nuestro jugador sea seguido por la cámara, para ello debemos integrar la camara con nuestro player.

```lua
--entidades.lua
...

function entidades:position()
	return self.player.ox,self.player.oy
end

...
```

Y en nuestro archivo game.lua

```lua
spritesheet= sprites
local camview={x=0,y=0,w=0,h=0}

...

local Player = require "entidades.player"
function game:draw()
	camview.x,camview.y,camview.w,camview.h=self.cam:getVisible()
	self.map:draw(-camview.x,-camview.y,self.scale,self.scale)
	self.cam:setPosition(base.entidades:position())
end

...

function game:mousepressed(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	base.entidades:mousepressed(cx,cy,button)
end

function game:mousereleased(x,y,button)
	local cx,cy=self.cam:toWorld(x,y)
	base.entidades:mousereleased(cx,cy,button)
end
```
![alt text](https://i.imgur.com/VOQeGWi.png)

Ahora nuestro personaje se puede mover a libertad, pero el problema es que no gira a donde nuestro mouse apunta. Para ello recogeremos los valores de nuestro mouse y le daremos un angulo.


Lo que haremos es aumentar una funcion en entidades.lua y en player.lua, para generar nuestro angulo.

```lua
--entidades.lua
function entidades:getmouseposition()
	return self.cam:toWorld(love.mouse.getX( ),love.mouse.getY( ))	
end
```

```lua
--player.lua
function player:update(dt)

	...
	
	self.ox,self.oy=self.body:center()

	self.radio=self:angle()
end
function player:angle()
	local angulo=0
	local mx,my=base.entidades:getmouseposition()
	angulo=math.atan2(my-self.oy,mx-self.ox)
	return angulo
end
```

Y ya tenemos el giro de nuestro jugador:

![alt text](https://i.imgur.com/dzOnvRA.png)

Esto nos ayudará mas adelante con la dirección de las balas y entre otras cosas más.

Pero, nos damos cuenta que nuestro jugador no esta detectando correctamente las colisiones, es capaz de atravesar las paredes como si nada, en este caso, nos toca realizar las colisiones, y para ello nos dirigimos a nuestra funcion collisions de nuestro archivo entidades.lua.

Agregamos el siguiente codigo:
```lua
--entidades.lua
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
```

Ahora al intentar atravesar una pared, nos es imposible realizar dicha acción, y nos regresa a donde estábamos antes.

Lo único que nos faltaría, seria que nuestro personaje cambie de arma, dispare y corra al presionar un botón.

Pero antes... recordamos que teníamos unas cajas en nuestro mapa, pero no están en ningún lado.
Para poder visualizarlos, debemos editar nuestro game.lua

En la función layer, editamos nuestro código.
```lua
--game.lua
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
```

Ademas de agregar la siguiente función en nuestro entidades.lua :

```lua
--entidades.lua

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
```

Nos servirá luego, para modificar nuestro mapa.

Agregamos las colisiones de nuestras cajas en game.lua

```lua
--game.lua
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
```

El resultado sera el siguiente:
![alt text](https://i.imgur.com/SYNtxgv.png)

Volviendo a nuestro jugador, lo que necesitamos ahora es darle animación, por lo tanto, en nuestro file jugador.lua agregaremos las siguientes variables y tablas:
```lua
--player.lua
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

function player:update(dt)

...

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

```

Estamos implementando la libreria Timer, por lo tanto debemos agregarla en nuestro codigo de base.lua.
```lua
--base.lua
local base = Class{
	__includes = Gamestate,
	init = function(self, mapfile)
	self.map=sti(mapfile)
	self.scale=0.7
	self.cam=gamera.new(0,0,self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight)
	self.cam:setScale(self.scale)
	self.map:resize(love.graphics.getWidth()*2,love.graphics.getHeight()*2)
	self.collider = HC.new()
	self.timer_player = Timer.new()
	self.timer_enemigo= Timer.new()
	entidades:enter(self.map,self.cam,self.collider,self.timer_player,self.timer_enemigo)
	end;
	entidades = entidades;
}

```

Y actualizarlo constantemente en nuestro archivo entidades.
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
	balas={{},{}}
}

function entidades:enter(map,cam,collider,timer_player,timer_enemigo)
	self.map=map
	self.cam=cam
	self.collider=collider
	self.timer_player=timer_player
	self.timer_enemigo=timer_enemigo
end

...

function entidades:player_update(dt)
	self.player:update(dt)

	self.timer_player:update(dt)
end
```

Esta libreria actualiza cada momento nuestro jugador, sin la necesidad de utilizar muchos contadores, esto puede hacer nuestro código mas legible para nosotros.

Nuestro personaje ya puede movilizarse y cambia de animación de manera dinámica.

![alt text](https://i.imgur.com/NW2VvRx.png)

Lo que faltaría seria la creación de nuestras balas, nuestro jugador puede disparar, pero la creación del objeto bala no esta definida aun.

Lo que haríamos es crear tal objeto, pero antes necesitamos las imágenes de nuestras balas.
Para ello descargamos el siguiente [spritesheet](https://kenney.nl/assets/tower-defense-top-down),  en las imagenes de la carpeta PNG buscamos las siguientes imagenes, tanto con este spritesheet, como el que ya [usamos](https://kenney.nl/assets/topdown-shooter).

![alt text](https://i.imgur.com/QpeOSs8.png)

Utilizamos la siguiente [herramienta](http://zerosprites.com/) para crear spritesheets de manera sencilla.

Le damos padding de 5, y utilizamos la [herramienta](http://www.spritecow.com/) para medir posiciones de nuestras imagenes, y la agregamos en nuestro archivo sprites.lua.

Debería quedar de la siguiente manera:
```lua
--sprites.lua
local sprites={}

	...
	
	sprites["img2"]= love.graphics.newImage("assets/img/sprites.png")

	sprites["armas"]={}
	sprites["armas"][1]= love.graphics.newQuad(45,207,19,10,sprites["img2"]:getDimensions())
	sprites["armas"][2]= love.graphics.newQuad(0,222,25,10,sprites["img2"]:getDimensions())
	sprites["armas"][3]= love.graphics.newQuad(0,207,33,10,sprites["img2"]:getDimensions())

	sprites["balas"]={}
	sprites["balas"][1]= love.graphics.newQuad(24,93,16,16,sprites["img2"]:getDimensions())
	sprites["balas"][2]= love.graphics.newQuad(24,162,16,16,sprites["img2"]:getDimensions())
	sprites["balas"][3]= love.graphics.newQuad(24,24,16,16,sprites["img2"]:getDimensions())
return sprites
```

Ahora en nuestro archivo bala.lua

```lua
--bala.lua
local Class = require "libs.class"
local base = require "gamestate.base"
local entidad = require "entidades.entidad"
local vector = require "libs.vector"

local balas = Class{
	__includes = entidad
}

function balas:init(x,y,tipo,velocidad,direccion)

	self.body=base.entidades.collider:circle(x,y,8)


	self.spritesheet=spritesheet.img2

	self.imgbala=spritesheet.balas[tipo]

	self.ox,self.oy=self.body:center()

	self.delta=vector(1,0)
	self.delta:rotateInplace(direccion)
	self.delta=self.delta*velocidad

end

function balas:draw()
	love.graphics.draw(self.spritesheet,self.imgbala,self.ox,self.oy,0,0.5,0.5,8,8)
end

function balas:update(dt)
	local delta=self.delta
	delta=delta*dt

	self.body:move(delta:unpack())
	self.ox,self.oy=self.body:center()
end

return balas
```

Modificamos de igual manera nuestro archivo entidades.lua para visualizar nuestras balas, con el siguiente código:

```lua
--entidades.lua
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
```

Y en nuestro archivo player.lua, invocamos nuestras balas
```lua
--player.lua
local Bala= require "entidades.balas"

function player:init(x,y,w,h)

	...

	self.arma=1
	self.municion={"infinito",0,0}
	self.stock={7,0,0}
	self.max_municion={"infinito",100,60}
	self.max_stock={7,25,20}

	self.vel_bala={700,1000,1200}

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
				self.estado.disparo=false
			elseif self.arma==2 then
				self.posicion=5
			elseif self.arma==3 then
				self.posicion=6
			end
		end

		if self.estado.disparo and self.arma==2 then
			self:create_bullet()
		end
 	end)

 	base.entidades.timer_player:every(0.1, function()
 		if self.estado.disparo and self.arma==3 then
			self:create_bullet()
		end
 	end)
end
function player:mousepressed(x,y,button)
	if button==1 and self.arma>1 then
		self.estado.disparo=true
	elseif button==1 and self.arma==1 then
		self.estado.disparo=true
		self:create_bullet()
	elseif button==2 then
		
	end
end

function player:mousereleased(x,y,button)
	if button==1 and self.arma>1 then
		self.estado.disparo=false
	elseif button==2 then

	end
end
function player:create_bullet()
	base.entidades:add(Bala(self.ox,self.oy,self.arma,self.vel_bala[self.arma],self.radio),"balas_p")
end
```

El resultado seria el siguiente:

![alt text](https://i.imgur.com/REyCdZL.png)

Pero, nuestro personaje dispara balas infinitas en los 3 casos, lo que debemos hacer es limitar su capacidad a solo una cantidad de balas, para ello agregaremos el siguiente código en la funcion create_bullet():

```lua
--player.lua
function player:create_bullet()
	if self.stock[self.arma] > 0 then
		base.entidades:add(Bala(self.ox,self.oy,self.arma,self.vel_bala[self.arma],self.radio),"balas_p")
		self.stock[self.arma]= self.stock[self.arma] -1
	end
end
```

Lo que hacemos es limitar a que la cantidad de stock sea mayor a 0, y si lo cumple disminuimos en 1 la cantidad (disparamos 1 bala), lo que faltaría seria la recarga de nuestras balas.

Para ello agregaremos un estado adicional  en la funcion player:init()

```lua
--player.lua
self.estado={ correr = false, inmunidad = false, vida = true, disparo=false, recarga=false}

self.arma=1
self.municion={7,0,0}
self.stock={7,0,0}
self.max_municion={"infinito",100,60}
self.max_stock={7,25,20}

self.vel_bala={700,1000,1200}

self.recarga_vel={0.5,0.8,1}
```

Y en la funcion mousepressed y  keypressed se agregan el siguiente script:
```lua
function player:mousepressed(x,y,button)
	if button==1 and self.arma>1 then
		self.estado.disparo=true
		self.estado.recarga=false
	elseif button==1 and self.arma==1 then
		self.estado.disparo=true
		self:create_bullet()
		self.estado.recarga=false
	elseif button==2 and self.stock[self.arma] < self.max_stock[self.arma] and not self.estado.recarga then
		self.estado.recarga=true

		base.entidades.timer_player:after(self.recarga_vel[self.arma] , function() 

			if self.estado.recarga then

				if self.max_municion[self.arma] == "infinito" then
					self.stock[self.arma]=self.max_stock[self.arma]
					print("a")
				else
					if self.municion[self.arma] + self.stock[self.arma] < self.max_stock[self.arma] then
						self.stock[self.arma]=self.municion[self.arma]+self.stock[self.arma]
						self.municion[self.arma]=0
					else
						local carga=self.max_stock[self.arma]-self.stock[self.arma]
						self.stock[self.arma]=self.stock[self.arma]+carga
						self.municion[self.arma]=self.municion[self.arma]-carga
					end
				end
				self.estado.recarga=false
			end
			

		end)
	end
end


function player:keypressed(key)

...

	self.estado.recarga=false
end
```

En este momento, nuestro usuario manera una cantidad limitada de balas, excepto en las pistolas que son ilimitadas.

Pero, nuestro personaje, si nos fijamos bien y con algo de curiosidad, puede salirse de la camara, y nuestras balas continúan de manera infinita su recorrido, lo que seria un gasto de memoria. Para solucionarlo, vamos a delimitar el alcance de nuestro jugador y balas.
```lua
--player.lua
function player:update(dt)
	local delta = vector(0,0)

	local be=base.entidades
	if self.direccion.a and self.ox > be.limites.x then
		delta.x=-1
	elseif self.direccion.d and self.ox < be.limites.x + be.limites.w then
		delta.x=1
	end

	if self.direccion.w and self.oy > be.limites.y then
		delta.y=-1
	elseif self.direccion.s and self.oy < be.limites.y + be.limites.h then
		delta.y=1
	end
end
```

Creamos una function en entidades.lua

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
	balas={{},{}},
	limites={}
}

function entidades:clear()

	...

	self.limites={}
end

function entidades:limit(table)
	self.limites = table
end

```

y la implementamos en game.lua

```lua
--game.lua
function game:update(dt)

	self.map:update(dt)

	base.entidades:collisions()

	base.entidades:limit(camview)
end
```

Lo mismo para las balas, si la bala pasa la cámara entonces sera eliminada para ahorrar memoria:

```lua
--balas.lua

function balas:update(dt)
	local be=base.entidades
	...
	if self.ox < be.limites.x or self.ox > be.limites.x + be.limites.w  or self.oy < be.limites.y  or self.oy > be.limites.y + be.limites.h then
		be:remove(self,"balas_p")
	end
end
```

Por ultimo, agregamos en daño que haremos al objeto/enemigo que impacte nuestras balas.
```lua
--player.lua
function player:init(x,y,w,h)

	...
	
	self.daño={1,2.5,5}
	...

end
function player:create_bullet()
	if self.stock[self.arma] > 0 then
		base.entidades:add(Bala(self.ox,self.oy,self.arma,self.vel_bala[self.arma],self.radio,self.daño[self.arma]),"balas_p")
		self.stock[self.arma]= self.stock[self.arma] -1
	end
end
```

```lua
--balas.lua
function balas:init(x,y,tipo,velocidad,direccion,daño)

	...
	
	self.daño=daño
	
	...

end
```