# Generar entorno de nuestro videojuego

Anteriormente vimos como funciona el mapeado de nuestro videojuego, generado con tilemap, ademas del framework y lenguaje con el cual vamos a programar, ahora lo que falta es unir ambos y generar un videojuego de disparos.

Para ello, descargaremos las siguientes librerías, que nos ayudara a generar de manera mas sencilla el entorno en el cual manejaremos:

*	[Libreria base HUMP](https://github.com/vrld/hump) : Nos porporcionara lo basico para crear un juego. Utilizaremos de este conjunto lo siguiente:
	
	 1. Gamestate.lua: Nos ayudara a manejar nuestro juego por escenas.
	 2. Timer.lua: Nos ayudara con los contadores, en la parte de animación y eventos
	 3. Vector.lua: Libreria de vectores
	 4. Class.lua: Clases para generar POO

*	[Libreria Gamera](https://github.com/kikito/gamera) : Nos ayudara con la creacion de camara. La libreria HUMP tambien nos proporciona una liberia **camera.lua**, pero por motivos prácticos manejaremos esta librería, eso no quita que no sea versátil.

*	[Libreria STI](https://github.com/karai17/Simple-Tiled-Implementation) : Nos ayudara a poder introducir nuestro mapa hecho en Tiled y modificarlo.

* [Libreria HC](https://github.com/vrld/HC) : Nos proporcionara la detección de colisiones. También era posible utilizar **love.physics** , que ya viene integrado, pero la programación con el motor de fisica, se hace mas complicado.

* [Libreria Ser](https://github.com/gvx/Ser) : Nos ayudara a serializar partes de código, útil para crear un marcador.

Para la codificación utilizaré el editor de texto Sublime text 3
## Ordenando nuestro entorno

Primeramente, crearemos las siguientes carpetas dentro de nuestro proyecto :
***
* **Videojuego**
	* **entidades**
		*  Aquí ira el código fuente de los personajes
	* **assets**
		* **img**
			* Aquí las imágenes de los jugadores
		* **mapas**
			* Aquí el mapa de nuestro juego
	*  **gamestate**
		* Aquí los niveles
	* **libs**
		* Aquí las librerías a utilizar.
***
En libs colocaremos nuestras librerías, en el caso de HC y STI serán las carpetas contenedoras, debería quedar algo así :

![alt text](https://i.imgur.com/xqh080m.png)

Ahora con eso ya listo, y habiendo creado un archivo conf.lua y main.lua, generaremos el siguiente código:

```lua
--main.lua

local Gamestate = require "libs.gamestate"
local game= require "gamestate.game"


function love.load()
	Gamestate.registerEvents()
	Gamestate.switch(game)
end

--conf.lua

function love.conf(t)
	t.version = "11.2" 
  	t.author="AdrianN"
  	t.window.width = 900
  	t.window.height = 650
  
  	t.title="Juego de disparos"
end
```

Hasta este momento, si ejecutamos nuestro juego nos dará un error, ya que **game** no esta definido. Para ello crearemos un archivo lua de nombre game.lua en nuestra carpeta gamestate.

```lua
-- game.lua
local Gamestate = require "libs.gamestate"
local Class = require "libs.class"
local HC = require "libs.HC"

local game = Class{}

function game:init()

end

function game:enter()

end

function game:update(dt)

end

function game:draw()

end

function game:mousepressed(x,y,button)

end

function game:keypressed(key)

end

function game:keyreleased(key)

end

return game

```

Lo que estamos haciendo acá, es crear un escenario que se llama con la función **Gamestate.switch(escenario)**, las funciones **update(dt)**, **draw()** y **load()** solo funcionan con el prefijo love. , lo que hace la librería es transformar ese **game:draw()** a **love.draw()** de manera dinámica, lo que hace mas ordenado nuestro código.

Ahora vamos a crear las entidades de nuestro juego. Crearemos varias tablas que guarden nuestros objetos de juego, ademas de hacer nuestro código reutilizable para otros niveles.
Creamos un archivo entidades.lua y entidad.lua en nuestra carpeta entidades

```lua
-- entidad.lua
local Class = require 'libs.class'

local entidad = Class{}

function entidad:init(x,y,w,h)

end

function entidad:draw()

end

function entidad:update(dt)

end

return entidad
```
Esta clase es como un molde para nuestros objetos.

```lua
local HC = "libs.HC"

local entidades = {
	map=nil,
	cam=nil,
	player=nil,
	enemigos={},
	solidos={},
	destruible={},
	objetos={},
	balas={{},{}}
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
```

Esta clase se utilizara para darle funcionamiento a todo el nivel. Se ha omitido el dibujado y actualizado de los layer de momento, ya que nos falta objetos a iterar

Ahora debemos crear un archivo base, que nos ayudara a unificar nuestro nivel en uno solo, creamos un archivo base.lua en nuestra carpeta gamestate

```lua
local Gamestate = require "libs.gamestate"
local Class = require "libs.class"
local entidades = require "entidades.entidades"
local sti= require "libs.sti"
local gamera = require "libs.gamera"

local base = Class{
	__includes = Gamestate,
	init = function(self, mapfile)
	self.map=sti(mapfile)
	self.gamera=gamera
	self.scale=0.7
	self.cam=self.gamera.new(0,0,self.map.width*self.map.tilewidth, self.map.height*self.map.tileheight)
	self.cam:setScale(self.scale)
	self.map:resize(love.graphics.getWidth()*2,love.graphics.getHeight()*2)
	entidades:enter(self.map,self.gamera)
	end;
	entidades = entidades;
	gamera = gamera;
}

return base
```

Ahora vamos a integrar nuestro archivo base.lua con game.lua

```lua
--game.lua
local Gamestate = require "libs.gamestate"
local base = require "gamestate.base"
local Class = require "libs.class"
local HC = require "libs.HC"

local game = Class{
	__includes = base
}
```

De nuestra clase anterior, recogemos los siguientes archivos:

*	spritesheet_characters.png
*	mapa.lua
*	tilesheet_complete.png

En nuestra carpeta assets, creamos las 2 carpetas anteriormente nombradas:
* Assets
	* img
	*  mapas

Hacemos la siguiente distribución:

![alt text](https://i.imgur.com/1bAI98x.png)

Ahora, colocamos el siguiente código en nuestro game.lua
```lua
--game.lua
function game:enter()
	base.entidades:clear()
	base.init(self,"assets/mapas/mapa.lua")
end

function game:update(dt)
	self.map:update(dt)
end

function game:draw()
	self.map:draw(-0,-0,self.scale,self.scale)
end
```
Ejecutamos y nos debería salir algo como esto...

![alt text](https://i.imgur.com/Di7xrD5.png)

Todo lo que nos faltaría es ingresar los datos en nuestras tablas.
```lua
local Gamestate = require "libs.gamestate"
local base = require "gamestate.base"
local Class = require "libs.class"
local HC = require "libs.HC"

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
					be:add({body=HC.rectangle((x-1)*self.map.tilewidth,(y-1)*self.map.tileheight,self.map.tilewidth,self.map.tileheight)},"solidos")
				elseif tile.properties.Pared and tile.properties.Circular then
					local tx,ty=(x-1)*self.map.tilewidth,(y-1)*self.map.tileheight

					local objectgroup=tile.objectGroup.objects
					local x,y,w,h
					for _, obj in pairs(objectgroup) do
						x,y,w,h=obj.x,obj.y,obj.width,obj.height
					end

					local r=math.pow(w*h,1/2)/2

					be:add({body=HC.circle(tx+x+r,ty+y+r,r)},"solidos")

				elseif tile.properties.Pared and not tile.properties.Circular then

					be:add({body=HC.rectangle((x-1)*self.map.tilewidth,(y-1)*self.map.tileheight,self.map.tilewidth,self.map.tileheight)},"solidos")

				elseif tile.properties.Destruible then

					local tx,ty=(x-1)*self.map.tilewidth,(y-1)*self.map.tileheight
					local objectgroup=tile.objectGroup.objects
					local x,y,w,h

					for _, obj in pairs(objectgroup) do
						x,y,w,h=obj.x,obj.y,obj.width,obj.height
					end

					be:add({body=HC.rectangle(tx+x,ty+y,w,h)},"destruible")
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

```

## Referencias:

La manera de realizar y ordenar nuestro juego fue recogido del siguiente [Tutorial](http://osmstudios.net/page/tutorials).
