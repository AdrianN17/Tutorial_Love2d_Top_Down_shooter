# Finalizando nuestro videojuego

En las anteriores clases, hemos logrado crear un videojuego completo, con unas mecánicas divertidas y la capacidad de poder interactuar con nuestro entorno, ademas de sobrevivir a una horda infinita de zombies.

Ahora, nos toca darle un mejor aspecto a nuestra pantalla de juego.

Primero, realizaremos la UI que habiamos dejado pendiente.
```lua
--game.lua
function game:draw()
	
	...

	self:ui()
end

function game:ui()
	love.graphics.draw(spritesheet.img3,spritesheet.ui,100,525)
	local play=base.entidades.player
	local k=0

	for i=1,3,1 do
		love.graphics.draw(spritesheet.img2,spritesheet.balas[i],110,510+30*i)

		love.graphics.print(play.stock[i],130,510+30*i)

		love.graphics.print("X " .. play.municion[i],160,510+30*i)
	end

	love.graphics.draw(spritesheet.img3,spritesheet.ui,450,25,0,0.5,0.5)
	love.graphics.draw(spritesheet.img2,spritesheet.armas[play.arma],460,50)

	if play.hp>0 then
		love.graphics.draw(spritesheet.img3,spritesheet.hp[1],250,550,0,2,2)
	end

	k=11
	for i=1,8,1 do
		if play.hp>9-i then
			love.graphics.draw(spritesheet.img3,spritesheet.hp[2],250+k,550,0,2,2)
			k=k+31
		end
	end

	if play.hp>9 then
		love.graphics.draw(spritesheet.img3,spritesheet.hp[3],250+k,550,0,2,2)
	end

	love.graphics.draw(spritesheet.img3,spritesheet.mouse[1],love.mouse.getX()-18,love.mouse.getY()-18)

	love.graphics.draw(spritesheet.img,spritesheet.enemigo[1],150,30,0,0.5,0.5)

	love.graphics.print("X " .. play.score,170,35)
end
```
Se agrego el atributo score en player.lua
```lua
player.lua
function player:init(x,y,w,h)

	...
	
	self.score=0
end
```

Ademas de ocultar el mouse, en el file main.lua

```lua
--main.lua
function love.load()
	
	...
	
	love.mouse.setVisible(false)
end
```
Ahora nos falta matar a nuestro usuario, pero antes, hemos olvidado algo de gran importancia.

La libreria HC almacena los objetos de nuestros personajes, hemos olvidado anular los cuerpos, lo cual no afecta ahora, pero si jugaramos el juego 15 o 16 veces, se notaria la cantidad de memoria gastada, generando una fuga.

Para ello, solo basta con editar la funcion entidades.clear
```lua
--entidades.lua

function entidades:remove(e,tipo)
	if tipo == "enemigos" then
		for i, ob in ipairs(self.enemigos) do
			if ob == e then
				self.collider:remove(e.body)
				table.remove(self.enemigos,i)
				return
			end
		end
	elseif tipo == "solidos" then
		for i, ob in ipairs(self.solidos) do
			if ob == e then
				self.collider:remove(e.body)
				table.remove(self.solidos,i)
				return
			end
		end
	elseif tipo == "destruible" then
		for i, ob in ipairs(self.destruible) do
			if ob == e then
				self.collider:remove(e.body)
				table.remove(self.destruible,i)
				return
			end
		end
	elseif tipo == "objetos" then
		for i, ob in ipairs(self.objetos) do
			if ob == e then
				self.collider:remove(e.body)
				table.remove(self.objetos,i)
				return
			end
		end
	elseif tipo == "balas" then
		for i, ob in ipairs(self.balas) do
			if ob == e then

				self.collider:remove(e.body)
				table.remove(self.balas,i)
				return
			end
		end
	end
end

function entidades:clear()
	self.collider:remove(self.player.body)

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

	self.collider:resetHash()

	collectgarbage()
end

```

Ademas de bloquear las funciones update, draw y las de teclado-mouse de nuestro personaje, con la siguiente condicional
```lua
--player.lua
if self.estado.vida then
	...
end
```


Con todo lo que implementamos, nuestro videojuego quedará asi:

![alt text](https://i.imgur.com/Jksih3z.png)

Así se ve bien, pero ... supongamos que debo contestar una llamada, y quiero poner pausa para volver a jugarlo, implementarlo no es tan complicado.

Creamos un archivo pausa.lua en nuestra carpeta gamestate.lua, y usamos el siguiente script.

```lua
--pausa.lua
local Gamestate = require "libs.gamestate"
pausa = Gamestate.new()

function pausa:init()

end

function pausa:enter(from)
  self.from = from 

end

function pausa:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()

  self.from:draw()


  love.graphics.printf('PAUSE', 0, h/2, w, 'center') 
end

function pausa:keypressed(key)
  if key == 'p' then
    return Gamestate.pop() 
  end
end


return pausa
```

Ademas  de implementarlo en game.lua

```lua
--game.lua
local pausa = require "gamestate.pausa"

function game:keypressed(key)
	base.entidades:keypressed(key)

	if key=="return"  and not base.entidades.player.estado.vida then
		base.entidades:clear()
		self:enter()
	end

	if key=="p" and base.entidades.player.estado.vida then
		Gamestate.push(pausa)
	end
end
```
El resultado:

![alt text](https://i.imgur.com/rpMYp0m.png)

Podemos agregar un menu principal, generamos un archivo menu.lua en nuestra carpeta gamestate.

Utilizamos las siguientes [imagenes](https://opengameart.org/content/3-parallax-backgrounds),[titulos](https://flamingtext.com/) y [botones](https://dabuttonfactory.com/) podemos generar un menu mas vistoso para los jugadores.

```lua
--sprites.lua
	sprites["pausa"]=love.graphics.newImage("assets/img/pausa.png")
	sprites["titulo"]=love.graphics.newImage("assets/img/title.png")
	sprites["boton"]=love.graphics.newImage("assets/img/button.png")
	sprites["muerte"]=love.graphics.newImage("assets/img/muerte.png")

	sprites["fondo"]=love.graphics.newImage("assets/img/fondo.png")
```

```lua
--menu.lua
local Gamestate = require "libs.gamestate"
local serialize = require "libs.ser"
menu = Gamestate.new()
local game= require "gamestate.game"
local sprites= require "assets.img.sprites"

local img=nil
local score=0


function menu:init()
	img=sprites
end

function menu:enter()
	local data=nil
	if love.filesystem.getInfo("score.lua") then
      data =love.filesystem.load("score.lua")()
      score=data.score
    else
    	love.filesystem.write("score.lua",serialize({score=0}))
    end
end

function menu:update(dt)

end

function menu:draw()
	for i = 0, love.graphics.getWidth() / img.fondo:getWidth() do
        for j = 0, love.graphics.getHeight() / img.fondo:getHeight() do
            love.graphics.draw(img.fondo, i * img.fondo:getWidth(), j * img.fondo:getHeight())
        end
    end


	love.graphics.draw(img.titulo,105,60,0,0.7,0.7)

	love.graphics.draw(img.boton,300,350,0,1.5,1.5)

	
	love.graphics.print("Mejor puntuacion : " .. score, 310,500)

	love.graphics.draw(img.img3,img.mouse[2],love.mouse.getX()-15,love.mouse.getY()-15)

end

function menu:mousepressed(x,y,button)
	if x>300 and y>350 and x<552 and y<420.5 then
		Gamestate.switch(game)
	end
end


return menu
```

Ademas, en este código implementamos la creación de un score sencillo, si el archivo score.lua existe entonces lo leemos y colocamos la puntuacion en nuestra ventana, sino creamos un archivo score.lua

Lo mismo en game.lua, para guardar la puntuacion

```lua
--game.lua
function game:keypressed(key)
	be:keypressed(key)

	if key=="return"  and not be.player.estado.vida then
		self:save_score()
		be:clear()
		self:enter()


	elseif key=="m" and not be.player.estado.vida then
		self:save_score()
		be:clear()
		Gamestate.switch(menu)
	end


	if key=="p" and be.player.estado.vida then
		Gamestate.push(pausa)
	end
end
function game:save
_score()
	if love.filesystem.getInfo("score.lua") then
		local old_data=love.filesystem.load("score.lua")()

		if old_data.score<be.player.score then
			love.filesystem.write("score.lua",serialize({score=be.player.score}))
		end
	end
end
```

En nuestro archivo game.lua, no es necesario importar el archivo menu, para volver, ya que esta siendo utilizado actualmente, y solo volvería para atrás.

Obligatoriamente, debemos  crear una ubicación para nuestro archivo score.lua, en nuestro archivo conf.lua cambiaremos el titulo de nuestro juego a otro que deseemos, ademas de crear un archivo t.identity (sin usar espacios)

Sera creada en la ruta: C:\Users\tu_usuario\AppData\Roaming\LOVE, donde abra una carpeta
```lua
--conf.lua
function love.conf(t)
	t.version = "11.2" 
  	t.author="AdrianN"
  	t.window.width = 900
  	t.window.height = 650
  
  	t.title="Kill the Zombies"
  	t.identity="Kill_the_Zombies"
end
```

Verificando y ejecutando el código, nos daremos cuenta que si existe esa carpeta.

![enter image description here](https://i.imgur.com/2sjm8qU.png)

Y finalmente, podemos agregar un estilo de texto, o font a nuestro juego, ademas de sonido de disparo.

Bajamos un [font](https://www.1001fonts.com/video-game-fonts.html?page=2&items=10) de formato ttf y lo importamos para su uso en nuestro archivo main.lua

Creamos una carpeta font en assets y guardamos el archivo ttf.

```lua
--main.lua
local Gamestate = require "libs.gamestate"
local menu = require "gamestate.menu"


function love.load()
	love.mouse.setVisible(false)
	Gamestate.registerEvents()
	Gamestate.switch(menu)

	love.graphics.setNewFont("assets/font/lunchds.ttf", 20)
end
```

Para el caso del sonido, buscamos para [disparos](https://opengameart.org/content/chaingun-pistol-rifle-shotgun-shots) y [recarga](https://opengameart.org/content/shotgun-shoot-reload), Creamos una carpeta sound en assets, en la cual guardamos los sonidos.

Creamos un archivo dentro de la carpeta sound llamado sonido.lua, en el cual, de la misma manera que sprites.lua, guardaremos nuestras fuentes para posteriormente utilizarlas.

```lua
--sonido.lua
local sonido={}

sonido["pistola"]=love.audio.newSource("assets/sound/pistol.wav","static")
sonido["rifle"]=love.audio.newSource("assets/sound/cg1.wav","static")
sonido["recarga"]=love.audio.newSource("assets/sound/reload.wav","static")

return sonido
```

En el  archivo player.lua, agregamos el siguiente codigo:
```lua
--player.lua
function player:init(x,y,w,h)
	
	...
	self.estado={ correr = false, inmunidad = false, vida = true, disparo=false, recarga=false, visible=true}
	base.entidades.timer_player:every(0.15, function() 
	
		...
		
		if self.estado.inmunidad then
			self.estado.visible=not self.estado.visible
		end
 	end)

	base.entidades.timer_player:every(0.1, function()
 		if self.estado.disparo and self.arma==3 then
			self:create_bullet()
		end

		if self.estado.recarga then
			sonido.recarga:play()
		end
 	end)
	...

	sonido.pistola:setPitch(2)
	sonido.rifle:setPitch(2)
end

function player:draw()
	if self.estado.vida then
		if self.estado.visible then
			love.graphics.draw(self.spritesheet.img,self.spritesheet.player[self.posicion],self.ox,self.oy,self.radio,1,1,self.w/2,self.h/2)
		end
	end
end

function player:update(dt)
	
	...

	if self.hp<4 then
		self.velocidad=300
	else
		self.velocidad=self.max_velocidad
	end
end

function player:create_bullet()
	if self.stock[self.arma] > 0 then
		if self.arma==1 then
			sonido.pistola:play()
		else
			sonido.rifle:play()
		end

		base.entidades:add(Bala(self.ox,self.oy,self.arma,self.vel_bala[self.arma],self.radio,self.daño[self.arma]),"balas")
		self.stock[self.arma]= self.stock[self.arma] -1
	end
end
```

Lo que hemos hecho es agregar nuestros sonidos, ademas de darles una velocidad con la función **:pitch(ingresar_velocidad)**, para nuestras balas. Adicionalmente creamos un estado visible, para darle un efecto de daño al jugador.

Ademas de todo, editamos la velocidad de los enemigos por ultima vez, en enemigos.lua
```lua
--enemigos.lua
function enemigos:init(x,y)

	...
	
	self.velocidad=650

	...

	self.max_velocidad=self.velocidad

end
```

Y en entidades.lua

```lua
--entidades.lua
function entidades:seek_player()
	self.timer_enemigo:every(0.5, function() 
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
				zombie.velocidad=zombie.max_velocidad
			end
		end
	end)
end

--colisiones

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

	...
end
```
Y .. finalmente retocando un poco mas nuestro juego, mejorando los códigos y optimizando algunas cosas, nuestro juego debería quedar así:

![enter image description here](https://i.imgur.com/JCRbtFK.png)

![enter image description here](https://i.imgur.com/6tFhgty.png)

Hemos terminado, ahora si podemos disfrutar nuestro juego.

Adicionalmente, podemos editar el icono de nuestro juego.
```lua
--config.lua
t.window.icon = "assets/img/icon.png"
```

Agregando una imagen, en mi caso sera del zombie, pero recortado. Lo agregamos en nuestra ubicacion img de assets y ejecutamos:

![enter image description here](https://i.imgur.com/S8ol4qQ.png)


Pero, ... y si ademas queremos compartir con los demás nuestra creación?
No es muy agradable tener que abrir el editor para poder jugar de manera cómoda.

Lo que podemos hacer es lo siguiente:


 1. Ir a nuestra carpeta base, seleccionar todo y crear un archivo zip
    (click derecho/enviar a/carpeta comprimida zip) y editar la
    extension a juego.love
	*	Si abrimos el archivo debería ejecutar nuestro juego

![enter image description here](https://i.imgur.com/NV6uHmb.png)

2. Buscamos nuestra carpeta fuente de Love2d y lo copiamos.
3. Colocamos dentro de la carpeta fuente nuestro videojuego y ejecutamos el siguiente comando en el CMD

```
	copy /b love.exe+juego.love Kill_the_Zombies.exe
```

![enter image description here](https://i.imgur.com/f9igqqB.png)

Eliminamos lo que no nos sirve, solo dejando los dll y el exe con el nombre que le colocamos (love.exe, lovec.exe, uninstall.exe,juego.love y los txt pueden ser borrados)

Ejecutamos nuestro juego y listo, hemos terminado.

Ejecutable del juego [aquí](https://drive.google.com/open?id=1-z7FfCYuMUoTaVAXy8ZjcCvviBIRUs_b)

## Continuara..

Ahora que ya has visto como funciona el framework Love2d, y has creado tu primer juego, te invito a continuar creando mas videojuegos, descubriendo nuevas mecanicas divertidas y dejando volar tu imaginacion. 

**Gracias por leer este tutorial**