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
### Tipos de datos

En Lua existen 8 tipos de datos, de los cuales los mas utilizados son:

*	number
*	string
*	function
*	table
*	nil

nil viene a ser null, un dato nulo.

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
