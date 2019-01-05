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

Y para finalizar, podemos agregar un menu principal, generamos un archivo menu.lua en nuestra carpeta gamestate.
