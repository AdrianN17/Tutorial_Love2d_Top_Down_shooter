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
		* **mapa**
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

