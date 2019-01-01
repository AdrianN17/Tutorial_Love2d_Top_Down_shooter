# Creación y animación de personaje

Anteriormente habiamos creados las bases de nuestro juego, ahora nos toca crear a nuestro personaje y sus funcionalidades, para ello debemos definir como va a interactuar en nuestro juego.

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

spritesheet= sprites

--local game = Class ... lo que sigue

```

Ahora creamos 5 archivos, player.lua, enemigos.lua, bala.lua, municion.lua y vida.lua, todo en nuestra carpeta entidades.

En nuestro archivo player.lua, debemos implementar el siguiente código.
```lua
local Class = require "libs.class"
local base = require "gamestate.base"
local entidad = require "entidades.entidad"
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
```
![alt text](https://i.imgur.com/VOQeGWi.png)

Ahora nuestro personaje se puede mover a libertad, pero el problema es que no gira a donde nuestro mouse apunta. Para ello recogeremos los valores de nuestro mouse y le daremos un angulo.
