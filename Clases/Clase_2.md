# Introduccion a Love2D

## Que es Love2d

![alt text](https://pbs.twimg.com/profile_images/698939763353481216/pDuLHUDg_400x400.png)

Love2d es un framework con el cual podemos crear un videojuego en el lenguaje de programacion Lua.
El framework es de software libre y es actualizado periódicamente, al momento de realizar este tutorial, la version actual es la 11.2

## Terminologias

* Libreria : Una libreria es una herramienta creada para facilitar la programacion en cierto proceso, facilitando la reutilizacion de codigo y el tiempo invertido en "reinventar la rueda".
	* Ejemplo : Java Swing
	
* Framework: Un framework es un conjunto de librerías con un tipo determinado de herramientas y patrones de diseño establecidos.
	* Ejemplo: Laravel, JSF, Spring
	
* Motor de videojuegos: Un motor de videojuegos es un grupo de herramientas, mas grande que un framework, por lo general es mas restrictivo y tiene como particularidad el tener una interfaz gráfica donde puedes ver las escenas creadas y modificadas de manera sencilla.
	* Ejemplo: Unity, Unreal Engine, Godot
	
* Api: Una api (interfaz de programación de aplicaciones) es un conjunto de herramientas, similar a una libreria, que nos permite interactuar con una plataforma determinada, con la diferencia que las funciones están ocultas al publico, solo es posible ingresar datos y recibir.
	*  Api de Google maps, Api de Google Earth
	
* SDK: Un sdk (kid de desarrollo de software) es similar a un framework, solo que esta orientado al desarrollo de aplicaciones exclusivas para una plataforma en particular.
	* SDK java, SDK android
	
* Software libre: Software que es creado por la comunidad y es gratuito, ademas de poder visualizar el codigo fuente, distribuirlo y editarlo.

* Software propietario: Software creado por una empresa, que es necesario comprar o en algunos casos puede ser gratuito, pero no se puede visualizar el código fuente, distribuirlo o editarlo de manera legal.

### Otros frameworks igual de interesantes

Love2d no es el único framework que use Lua, existen otros también de interesantes, como por ejemplo:

*	[Corona SDK](https://coronalabs.com/)
*	[Defold](https://www.defold.com/)
*	[Moai](https://moaiwebsite.github.io/)
*  [Gideros](http://giderosmobile.com/)

Ademas de otros frameworks similares en otros lenguajes

*	[Phaser](https://phaser.io/) -- Javascript
*	[Libgdx](https://libgdx.badlogicgames.com/)-- Java

## Funciones en Love2d

Love2d utiliza 3 funciones esenciales para la creación de un juego

*	**love.load()**
*	**love.update(dt)**
*	**love.draw()**

Love.load se encarga de cargar o inicializar las variables o imágenes que utilizaremos en nuestro juego.

Love.update se encarga de actualizar constantemente nuestro juego, es donde por lo general va toda la lógica de nuestro juego.
El parámetro dt es un delta time, que se utiliza para adecuar la velocidad de actualización del juego, ya que en maquinas de poco procesamiento sera mas lento y en las de ultima generación puede ir mas rápido.

Love.draw se encarga de pintar la pantalla de nuestro juego con las imágenes dadas por el usuario.

Ademas de estas funciones nombradas, existen otras que también son muy útiles para la creación de un videjuego, como por ejemplo:

*	Love.sound : Se encarga de la lectura de sonidos, no los emite.
*	Love.audio : Se encarga del sonido de nuestro juego, emitir sonidos.

*	Love.keypressed : Función que se activa al presionar una tecla.
*	Love.keyreleased : Función que se activa al soltar una tecla.
*	Love.mousepressed : Función que se activa al presionar el mouse.
*	Love.mousereleased : Función que se activa al soltar el mouse.
*	Love.keyboard : Se encarga de las lecturas por teclado, es similar a love.keypressed, pero se utiliza para pruebas sencillas.
*	Love.mouse : Se encarga de las lectura por mouse, similar a mouse.pressed, pero se utiliza para pruebas sencillas.

*	Love.graphics : Se encarga de cargar imágenes y dibujarlas dentro de nuestro juego.
*	Love.font : Se encarga de cargar las fuentes a utilizar en el texto.

*	Love.physics :  Modulo de fisicas, utiliza Box2d para generar fisicas realistas.

PD : **Se necesita que el juego comience con el archivo main.lua, de lo contrario no sera reconocido.**

Un ejemplo sencillo seria:

```lua

--main.lua

local i=0 
local imagen=nil
	
function love.load()
	imagen = love.graphics.newImage("Hamster.png")
end

function love.draw()
	love.graphics.print("hola n°" .. i ,100,100)

	love.graphics.draw(imagen,100,300)
end

function love.update(dt)
	i=i+1
end
```

El resultado seria algo como esto:

![alt text](https://github.com/AdrianN17/Tutorial_Love2d_Top_Down_shooter/blob/master/etc/imagen1.bmp)

Pero, si nos damos cuenta, el tamaño de la pantalla es muy grande, es posible reducirlo mediante la utilización del modulo love.windows, pero una manera mas ordenada es utilizar un archivo conf.lua

Este archivo se ejecuta antes de que se abra el juego, contiene las configuraciones de nuestro juego.

```lua
--conf.lua
function love.conf(t)
	t.window.title = "Hola mundo"
    t.window.width = 300
    t.window.height = 500
end
```

La funcion t.window.title se encarga de darle el titulo a la ventana
La funcion t.window.width y t.window.height se encargan de las dimensiones de la pantalla

Al agregar este archivo, nuestra pantalla se debería ver así:

![alt text](https://github.com/AdrianN17/Tutorial_Love2d_Top_Down_shooter/blob/master/etc/imagen2.bmp)

Ademas de estas funciones, existen otras que nos ayudan a realizar otras funciones, o activar y desactivar módulos.

****

**No se ha profundizado totalmente en ciertos conceptos ya que se utilizaran mas unos que otros**

Referencias:

* [Pagina oficial Love2d](https://love2d.org/wiki/Main_Page)
