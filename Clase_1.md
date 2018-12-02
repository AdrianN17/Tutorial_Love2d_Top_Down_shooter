# Introducción al lenguaje de programación Lua

## Que es Lua?
![alt text](https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Lua-logo-nolabel.svg/192px-Lua-logo-nolabel.svg.png)

Lua es un lenguaje de Scripting, interpretado y de tipado dinámico, creado por miembros del grupo de Tecnología en Computación Gráfica (Tecgraf) en la Pontificia Universidad Católica de Río de Janeiro .

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

**nil** viene a ser null, un dato nulo.

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

### Tablas

El concepto de una tabla en Lua es un poco complejo de entender, las tablas vendrían a ser como un Arreglo, mas similar a los ArrayList de Java y Diccionarios en Python, pero de la misma manera, seria un objeto, así como los Json

```lua
	tabla = {}
	tabla[1]=2
	
	print(tabla[1]) -- devuelve 2
```

Es posible generar programación orientada a objetos mediante las Tablas en Lua, ya que no se tiene soporte nativo para POO.
