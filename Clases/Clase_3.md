# Introducción a Tilemap
## Que es tilemap?
![alt text](https://www.mapeditor.org/img/tiled-logo-white.png)

Tilemap es una herramienta open source para generar niveles en mosaicos o tiles de manera sencilla, es posible maquetar un nivel completo y darle animaciones mediante la utilizacion de tileset ya generados, haciendo mas sencillo que hacerlo manualmente mediante la programación dentro del framework o libreria, pudiendo uno concertarse en darle funcionalidades a los objetos, como personajes o enemigos, entre otros.

## Tipo de Capas:

En Tilemap existen 3 tipos de capas en la cual nosotros podemos diseñar nuestros niveles:
 * Capa de Patrones : Se guarda los tiles o mosaicos a utilizar en el nivel
 * Capa de Objetos: Objetos o imágenes guardadas dentro del nivel
 * Capa de Imágenes: Imágenes guardadas dentro del nivel, es similar a la capa de objetos

## Iniciando

Para comenzar utilizaremos un tileset para crear nuestro nivel.
Utilizaremos un [pack](https://kenney.nl/assets/topdown-shooter) para generar nuestro juego top down (personajes, objetos, tiles)
Luego crearemos nuestro mapa, abrimos el programa y generamos un nuevo mapa de las siguientes dimensiones:

Lo llamaremos mapa

![alt text](https://i.imgur.com/gRMSPI9.png)

Si nos sobra o falta espacio es posible redimensionar el mapa, eso se vera mas adelante
Ahora generamos un nuevo conjunto de patrones, esto es opcional, ya que es posible unirlo directamente al mapa, pero para poder reutilizar varias veces el mismo patrón es mejor crearlo fuera del mapa.

![alt text](https://i.imgur.com/brADaUg.png)
Buscamos nuestro tileset y guardamos el archivo

![alt text](https://i.imgur.com/7Mbjw0e.png)

En mi caso, lo renombre a tile_datos, al guardar el archivo tsx estará anexado a nuestro mapa, por defecto. De lo contrario, basta con arrastrarlo a la ventana de conjunto de patrones

![alt text](https://i.imgur.com/KSfUSw5.png)

Viendo nuestro mapa, nos parece muy grande y queremos redimensionarlo a 50x50 cuadriculas, para ello vamos a la opcion redimensionar mapa
![alt text](https://i.imgur.com/YRNzbfT.png)

Y elegimos el tamaño que queremos
![alt text](https://i.imgur.com/gv4MDiP.png)

Cuadramos los ejes X y Y, pero en este caso, al estar vacio el mapa no hay problema.
Ahora si nos toca crear el mapa de nuestro juego, pero debemos antes de ordenar el mapa
Para ello crearemos las siguientes capas
![alt text](https://i.imgur.com/gMPC9Y2.png)

Generaremos un mapa a nuestra creatividad, podemos utilizar las siguientes herramientas:
![alt text](https://i.imgur.com/JOIQVci.png)

1. Brocha de estampar: Asigna un tile a una cuadricula.
2. Herramienta de rellenado: Asigna un mismo tile a varias cuadriculas.
3. Herramienta de rellenado de formas: Asigna un mismo tile a varias cuadriculas, solo que esta opción, tu puedes elegir el tamaño.
4. Goma: Borra un tile de una cuadricula.
5. Seleccion Rectangular: Sirve para seleccionar una cantidad de cuadriculas, para poder copiar, pegar y cortar.
6. Varita magica: Selecciona una cantidad de tiles iguales, de manera automática.

La capas se dividen en:
* Suelo: Aquí irán todos los tiles iniciales (el suelo, pasto, etc)
* Superficie: Aquí se colocara todo lo que deba estar encima del suelo (paredes, piedras, etc)
* Borrador: Aquí ira lo que necesitemos solo al inicio, esta capa sera borrada al inicializar el juego.
* Objetos: Guarda los accesorios de nuestro juego (plantas, mesas, etc), y objetos con los cuales podremos interactuar (cajas).
* Personajes: Aquí se coloca los jugadores, balas y enemigos.
* Ocultar : Aquí va los arboles y objetos en los cuales podremos ocultarnos.

Ahora, a las imágenes que tengamos como caja (que están dentro de la capa Objetos), se le colocara el nombre caja
![alt text](https://i.imgur.com/8oTCw83.png)

Y de igual manera con los objetos player y enemigo en la capa borrador.
![alt text](https://i.imgur.com/KR9K9vO.png)