# Introducción al lenguaje de programación Lua

## Que es Lua?
![alt text](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Lua-logo-nolabel.svg/192px-Lua-logo-nolabel.svg.png)

Lua es un lenguaje de Scripting, interpretado y de tipado dinámico, creado por miembros del grupo de Tecnología en Computación Gráfica (Tecgraf) en la Pontificia Universidad Católica de Río de Janeiro .
Es un lenguaje minimista, que se utiliza generalmente incrustado en un programa mas grande, generalmente en codigo C o C++

## Terminologias

Un lenguaje de scripting es un lenguaje que es interpretado en tiempo de ejecución.
Ejemplo de lenguajes de scripting:
*	Lua
*	Python
*	Javascript
*	PHP

Tipado dinámico es cuando una variable puede tomar diferentes valores, por ejemplo:

```lua
	local x=1 
	print(x) -- imprime un numero
	x="a"-- es valido
	print(x) -- imprime un caracter
``` 
Frente a un lenguaje de tipado estático como Java.

```java
	int x=1;
	System.out.println(x);
	x="a"; // genera un error
```	




## Sintaxis básica de Lua

Lua se caracteriza por ser un lenguaje muy amigable para el programador, esta alejado de la sintaxis C, colocandolo en términos sencillos, no se utilizan **'{}'** o **';'** , teniendo una similitud a Python en ese sentido. Opcionalmente, si estas acostumbrado a colocar **';'** al finalizar una linea de código, Lua acepta el **';'** al finalizar.

Aplica los mismos conceptos que cualquier otro lenguaje de programación.

### Comentarios
Los comentarios en Lua se pueden generar de 2 maneras

Para una linea se utiliza **--**

Para mas de una linea se utiliza ** --[[ ]]-- **

```lua
	-- Esto es un comentario

	--[[
		Esta es un
		comentario
	]]--
```

### Variables

Las variables de Lua por defecto son Globales, una similitud seria al public en las clases de Java

```java
	public x=0;
```	

Es igual a 

```lua
	x=0
```

para solucionar eso, se debe declarar antes de la variable el argumento **local**

```lua
	local x=0
```
En lua es posible declarar varias variables al mismo tiempo

```lua
	local x,y,z=0,1,0
```

### Tipos de datos

En Lua existen 8 tipos de datos, de los cuales los mas utilizados son:

*	number
*	string
*	function
*	table
*	nil

**nil** viene a ser null, vacio.

### Operadores

Existen Operadores Aritméticos, Relacionales y Lógicos.

#### Aritmético
```lua
	1+1 -- suma, da 2
	1-1 -- resta, da 0
	1*2 -- multiplicacion, da 2
	2/2 -- division, da 1
	2%2 -- modulo, da 0
	2^2 -- exponente, da 4
	-1  -- negativo, da -1
```

#### Relacionales
```lua
	1==1 -- comparacion
	1~=0 -- diferente
	1>1 -- mayor
	1<1 -- menor
	1>=1 -- mayor igual
	1<=1 -- menor igual
```

#### Lógicos

```lua
	1==0 and x==0 -- si, ambos deben coincidir en verdad
	1==0 or x==0 -- no, uno de ellos puede ser verdadero y otro falso
	not true -- reverso
```
#### Miscelaneas

```lua
	"hola" .. "mundo" -- concatenar
	#myarray -- longitud de una cadena o tabla
```

### Estructura condicional
	
```lua
	if x<0 then
		print("Es menor a 0")
	elseif x==0 then
		print("Es 0")
	else
		print("Es mayor a 0")
	end
```
En Lua no existe la sentencia Switch, como en otros lenguajes, teniéndose que utilizar **elseif**.

### Estructura repetitiva

Tal como otros lenguajes de programacion, Lua cuenta con 3 tipos de estructura repetitiva:

* **For**
* **While**
* **Repeat**

```lua
	for i=0,10,1 do
		print(i)
	end
```

```lua
	while(x==0) do
		print("continuare")
	end
```

```lua
	repeat 
		print("todavia continuo")
	until (x==0)
```
Ademas, puedes romper un bucle con el parámetro **break**

```lua
	for x=0,10,1 do
		if(x==2) then
			break
		end
	end
	
```

### Funciones

Una función es un grupo de sentencias que pueden ser invocadas en cualquier parte de grupo, separadas del código principal.

```lua
	function programa()
		print("La suma es " .. suma(1+3)) -- retorna 4
	end

	function suma(a,b)
		return a+b
	end
	
	programa()
```

Las variables declaradas dentro de la función, si no son con el parámetro global, entonces sera posible acceder a ellas fuera de la misma función.

```lua
	x=9
	function programa()
		x=0
	end
	
	programa()
	print(x) -- devolvera 0
```

```lua
	x=9
	function programa()
		local x=0
	end
	
	programa()
	print(x) -- devolvera 9
```
Otra manera de declarar es mediante una función anónima:
```lua
	f=function(a,b) return print(a+b) end

	f(1,2)
```

También es posible crear funciones locales, tal como sucede con las variables

```lua
	local function suma(a,b)
		print(a+b)
	end
```



### Tablas

El concepto de una tabla en Lua es un poco complejo de entender, las tablas vendrían a ser como un Arreglo, mas similar a los ArrayList de Java y Diccionarios en Python, pero de la misma manera, seria un objeto, así como los Json

```lua
	tabla = {}
	tabla[1]=2
	
	print(tabla[1]) -- devuelve 2

	vector = {x=1,y=2,z=3}
	print(vector.x) -- devuelve 1
	print(vector["z"]) -- devuelve 3
```
Se puede acceder a las variables dentro de un vector de 2 maneras, llamándolo como un atributo, o como un array, pero como si fuese una cadena, en ambos casos el resultado es el mismo

Es posible generar programación orientada a objetos mediante las Tablas en Lua, ya que no se tiene soporte nativo para POO.

Nota: Los arrays en Lua funcionan a partir del indice 1.

Ademas de esto existen varios modos de alterar una tabla, usando las siguientes funciones:

**table.insert (table, [pos,] value)**
**table.remove (table [, pos])**
**table.sort (table [, comp])**
```lua
	table.insert(tabla,4) -- agrego el numero 4 en la ultima posicion, tambien se puede elegir la posicion que se desea colocar
	table.insert(tabla,2,4)-- agrega en la posicion 2
	
	table.remove(tabla,1) -- elimino la posicion 1
	table.sort(tabla) -- ordena una tabla, esto tambien se puede utilizar con una funcion de ordenamiento
	table.sort(tabla,function(a,b) return a > b end)-- ordena de mayor a menor
```


### Iteradores

Los iteradores son maneras mas legibles de recorrer un array.

```lua
	tabla={1,2,3}
	
	for i=1,tabla#,1 do
		print(tabla[i])
	end
```

Es una implementacion genérica, pero también se puede lograr de 2 maneras distintas

```lua
	tabla={1,2,3}
	
	for i,n in ipairs(tabla) do
		print(n)
	end
```

```lua
	tabla={1,2,3]

	for i,n in pairs(tabla) do
		print(n)
	end
```

La diferencia entre **ipairs** y **pairs**, es que ipairs valida los indices nulos y se detiene.
Por ejemplo:
```lua
	table={1,nil,3}
	for i,n in ipairs(tabla) do
		print(n)
	end
	
	for i,n in pairs(tabla) do
		print(n)
	end
```

El primer iterador usando ipairs se detiene cuando llega a nil, mientras que el segundo ignora el nil y continua

ipairs resultado: 1

pairs resultado:1 3

### Modulos

En Lua, cuando por ejemplo queremos crear una libreria o llamar un trozo de codigo creado, como por ejemplo

```lua
	--file suma.lua
	function suma(a,b)
		print(a+b)
	end
```

Podemos llamarlo de la siguiente manera
```lua
	--main.lua
	require "sumatoria"
	suma(1,2) -- resultado 3
```

Otra manera distinta es utilizando tablas:

```lua
	--file operaciones.lua
	
	local operaciones={}
	
	function operacion:suma(a,b)
		print(a+b)
	end
	
	return operaciones
```

```lua
	-- file main.lua

	local operaciones = require "operaciones"

	operaciones:suma(1,2) -- resultado 3
```

### Metatablas

Una metatabla es una tabla que ayuda a modificar el comportamiento, por redundancia una tabla

Existen 2 metodos utilizados

**setmetatable (table, metatable)**
**getmetatable (tabla)**

Anteriormente se comento que es posible la creación de OOP mediante la utilización de metatablas en Lua.

### Corutinas

Son piezas de código que se generan de manera colaborativa, solo una puede ser utilizada a la vez.

*** ***
**No se ha profundizado totalmente en ciertos conceptos ya que se utilizaran mas unos que otros**

### Librerias

Lua cuenta con librerías para matemática ,  manejo de excepciones y lectura de ficheros i/o

Ademas cuenta con muchas librerías de terceros en Internet.

Fuentes:
* [Tutorial_Lua_Ingles](https://www.tutorialspoint.com/lua/lua_metatables.htm)
* [Tutorial_metatablas](http://lua.space/general/intro-to-metatables)
* [Tutorial_corutinas](http://lua.space/gamedev/using-lua-coroutines-to-create-rpg)




