# Antes de empezar

## Instalación de Lua

Para windows se puede utilizar este [paquete](https://github.com/rjpcomputing/luaforwindows/releases), con algunas librerias basicas y ya configurado (Lua es minimalista, y la versión oficial viene solo con el interprete)

## Instalacion de Love2d
Se puede descargar de la [pagina oficial](https://love2d.org/)

## Instalacion de Tilemap

Se puede descargar el ejecutable de la [pagina oficial](https://www.mapeditor.org/).

## Editores de texto

Personalmente utilizo el editor [Sublime text 3](https://www.sublimetext.com/3) para toda la codificación, exceptuando el io.write y io.read de Lua, funciona muy bien.

Para configurar el editor y hacerlo compatible con Lua, si no funciona la manera predeterminada (Tools/Build System/Lua):

Vamos a Tools, Build System y buscamos la opción **New Build System**

Creamos un archivo llamado lua.sublime-build y lo guardamos con el siguiente código.

```javascript

{
	"cmd": ["lua", "$file"],
	"file_regex": "^(...*?):([0-9]*):?([0-9]*)",
	"selector": "source.lua"
}
```

Elegimos el nuevo build y ejecutamos .

Ahora para Love2d realizamos el mismo paso,  creamos un archivo Love2d.sublime-build con el siguiente código.

```javascript
{
    "selector": "source.lua",
    "cmd": ["C:/Program Files/LOVE/love.exe", "${project_path:${file_path}}"],
    "shell": true,
    "file_regex": "^Error: (?:[^:]+: )?([^: ]+?):(\\d+):() ([^:]*)$"
}

```

Y debería funcionar.

### Complementos para sublime text

Existe varios complementos centrados en Love2d, pero están muy desactualizados. Utilizaremos un complemento para la sintaxis Lua

Yo personalmente utilizo el siguiente [complemento](https://packagecontrol.io/packages/LuaExtended).

### Otros complementos y editores/IDE

* [Love2d IDEA plugin](https://github.com/rm-code/love-IDEA-plugin) 
	* Complemento de Intellij 
*	[Zerobrane studio](https://studio.zerobrane.com/)
	*	Un IDE de codigo libre enfocado a Lua