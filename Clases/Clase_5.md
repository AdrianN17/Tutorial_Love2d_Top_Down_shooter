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
local HC = require "libs.HC"
local Timer = require "libs.timer"
local vector = require "libs.vector"

local player = Class{
	__includes = entidad
}

function player:init()

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

