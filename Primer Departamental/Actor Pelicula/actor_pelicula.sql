CREATE SCHEMA ACTORPELICULA;
USE ACTORPELICULA;

CREATE TABLE Actor_Pelicula
(
	nombre_actor VARCHAR(50),
    apellido_actor VARCHAR(50),
    titulo_pelicula VARCHAR(100)
);

SELECT DISTINCT nombre_actor, apellido_actor FROM Actor_Pelicula; 

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\actor_pelicula.csv' 
INTO TABLE Actor_Pelicula
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 LINES;
SELECT * FROM Actor_Pelicula;

/*Creación de consultas multitablas.*/
/*Listando los actores que participan en una misma pelicula*/
/*Las condiciones de reunion se especifican con el comando ON*/
SELECT DISTINCT AP1.*
FROM Actor_Pelicula AP1 INNER JOIN Actor_Pelicula AP2
ON AP1.titulo_pelicula = AP2.titulo_pelicula /*Especificamos que la pelicula sea la misma*/
AND AP1.nombre_actor != AP2.nombre_actor AND AP1.apellido_actor != AP2.apellido_actor; /*Especificamos que los actores sean distintos*/

/*Segunda forma de resultado es con SubConsulta IN es subconsulta de Lista, EXISTS devuelve valores de verdadero o falso
filtrando los resultados*/
SELECT DISTINCT *
FROM Actor_Pelicula AP1
WHERE EXISTS (
				SELECT *
                FROM Actor_Pelicula AP2
                WHERE AP1.titulo_pelicula = AP2.titulo_pelicula
                AND AP1.nombre_actor != AP2.nombre_actor
                AND AP1.apellido_actor != AP2.apellido_actor
			);
            
/*Forma mas facil de resolver*/
SELECT DISTINCT * FROM Actor_Pelicula AP1
ORDER BY titulo_pelicula;

/*Solucion listar la cantidad de peliculas asociado a cada actor*/
SELECT nombre_actor, apellido_actor, titulo_pelicula FROM Actor_Pelicula
ORDER BY nombre_actor, apellido_actor;

/*Listar los actores de cada pelicula*/
SELECT titulo_pelicula, nombre_actor, apellido_actor FROM Actor_Pelicula
ORDER BY titulo_pelicula;

/*Listar a los actores que han participado con UMA WOODS*/
-- Conjunto A
SELECT * FROM Actor_Pelicula AP
WHERE AP.nombre_actor = "UMA" AND AP.apellido_actor = "WOOD"
AND AP.titulo_pelicula NOT IN
						(
							-- Conjunto B
							SELECT AP1.titulo_pelicula FROM Actor_Pelicula AP1 INNER JOIN Actor_Pelicula AP2
							ON AP1.nombre_actor = "UMA" AND AP1.apellido_actor = "WOOD"
                            AND AP1.titulo_pelicula = AP2.titulo_pelicula
                            AND AP1.nombre_actor != AP2.nombre_actor
                            AND AP1.apellido_actor != AP2.apellido_actor
                        );
                        
/*LEFT JOIN y RIGHT JOIN nos permite realizar la resta de conjuntos
Usando LEFT JOIN realizamos la operación A - B, el cual vamos a solucionar
los actores que han participado con UMA WOODS*/
SELECT * 
FROM
(
	SELECT * FROM Actor_Pelicula
    WHERE nombre_actor = "UMA" AND apellido_actor = "WOOD"
) AS A
LEFT JOIN 
(
	SELECT DISTINCT AP1.* FROM Actor_Pelicula AP1
    INNER JOIN Actor_Pelicula AP2
    ON AP1.nombre_actor = "UMA" AND AP1.apellido_actor = "WOOD"
    AND AP1.titulo_pelicula = AP2.titulo_pelicula
    AND AP1.nombre_actor != AP2.nombre_actor
    AND AP1.apellido_actor != AP2.apellido_actor
) AS B
ON A.titulo_pelicula = B.titulo_pelicula 
WHERE B.titulo_pelicula IS NULL;

/*Ejercicio: Listar que actores han participado en al menos 3 peliculas en las que ha participado "UMA WOOD"*/

/*Definimos en que peliculas ha actuado UMA WOOD*/
SELECT titulo_pelicula FROM Actor_Pelicula
WHERE nombre_actor = "UMA" AND apellido_actor = "WOOD";

/*Definimos otros actores que han participado con UMA WOOD*/
SELECT * FROM Actor_Pelicula
WHERE nombre_actor != "UMA" AND apellido_actor != "WOOD"
AND titulo_pelicula IN
					(
						SELECT titulo_pelicula FROM Actor_Pelicula
						WHERE nombre_actor = "UMA" AND apellido_actor = "WOOD"
					);

/*Uso del GROUP BY y HAVING
Por cada valor repetido de la(s) columna(s) listadas en GROUP BY se genera un conjunto o subconjunto
para cada grupo puede aplicar funciones resumen, las cuales calculan un valor de grupo*/
SELECT titulo_pelicula, COUNT(nombre_actor) AS "ACTORES"
FROM Actor_Pelicula
GROUP BY titulo_pelicula
HAVING COUNT(nombre_actor) = 1;

/*Definimos ahora los actores que han participado en al menos 3 peliculas*/
SELECT nombre_actor, apellido_actor FROM Actor_Pelicula
WHERE nombre_actor != "UMA" AND apellido_actor != "WOOD"
AND titulo_pelicula IN
					(
						SELECT titulo_pelicula FROM Actor_Pelicula
						WHERE nombre_actor = "UMA" AND apellido_actor = "WOOD"
					)
GROUP BY nombre_actor, apellido_actor
HAVING COUNT(nombre_actor) >= 3
ORDER BY nombre_actor;

/*EJERCICIO: Listar el top 5  de actores con mas peliculas*/
SELECT nombre_actor, apellido_actor, COUNT(titulo_pelicula) AS cantidad FROM Actor_Pelicula
GROUP BY nombre_actor, apellido_actor
ORDER BY cantidad DESC LIMIT 5;

/*EJERCICIO: Listar el actor top 1 de mas peliculas hechas*/
-- Solución con Subconsulta escalar
SELECT nombre_actor AS Nombre, apellido_actor AS Apellido, COUNT(titulo_pelicula) AS Cantidad
FROM Actor_Pelicula
GROUP BY Nombre, Apellido
HAVING COUNT(titulo_pelicula) =
								(
									SELECT MAX(Cantidad)
                                    FROM(SELECT nombre_actor, apellido_actor, COUNT(titulo_pelicula) AS Cantidad
										FROM Actor_Pelicula GROUP BY nombre_actor, apellido_actor) AS AP
                                );
                                
-- Solucion con JOIN
-- Usamos un concepto llamado EQUIREUNIÓN
SELECT * 
FROM (SELECT nombre_actor AS Nombre, apellido_actor AS Apellido, COUNT(titulo_pelicula) AS Cantidad
FROM Actor_Pelicula GROUP BY Nombre, Apellido) AS AP1
INNER JOIN 
(SELECT MAX(Cantidad) AS ValorMax
	FROM(SELECT nombre_actor, apellido_actor, COUNT(titulo_pelicula) AS cantidad
	FROM Actor_Pelicula GROUP BY nombre_actor, apellido_actor)AS AP) AS AP2
ON AP1.Cantidad = AP2.ValorMax;

-- Solucion creando una lista
CREATE VIEW Listado_Actor_Apellido_Cant_Pelicula AS
	SELECT nombre_actor, apellido_actor, COUNT(titulo_pelicula) AS Cantidad
	FROM Actor_Pelicula GROUP BY nombre_actor, apellido_actor;
    
SELECT *
FROM Listado_Actor_Apellido_Cant_Pelicula
WHERE Cantidad = (
					SELECT MAX(Cantidad)
                    FROM Listado_Actor_Apellido_Cant_Pelicula
				 );
                 
/*Resta de conjuntos utilizando LEFT JOIN
Con LEFT JOIN debemos validar que las columnas del conjunto sea NULL
Otras maneras de realizar una resta de conjuntos es con una subconsulta de lista usando NOT IN
La tercera forma es con la funcion EXISTS en su forma negada NOT EXISTS*/

/*Para realizar la operacion con subconjuntos podemos implementar
INNER JOIN con OPERADOR  = (EQUIREUNION)
Subconsulta de lista IN y funcion EXISTS*/

/*Divison de conjunto: Para realizar la division de conjuntos utilizamos:
Funcion EXISTS - NOT EXISTS*/

-- EJERCICIO: Listar los actores que participen exactamente en la mismas peliculas que UMA WOOD
-- 1.- Encontrar las peliculas donde actua UMA WOOD -> Conjunto A
-- 2.- Generar subconjuntos de actores por pelicula 
-- 3.- Filtrar actores con la misma cantidad de peliculas que UMA WOOD -> Conjunto B
-- 4.- Comparar que sean las mismas peliculas

-- Creando el conjunto A
SELECT titulo_pelicula FROM Actor_Pelicula CA
WHERE nombre_actor = "UMA" AND apellido_actor = "WOOD";

-- Creando el conjunto B
SELECT * FROM Actor_Pelicula WHERE nombre_actor != "UMA" AND apellido_actor != "WOOD";

-- Division a partir de la resta de conjuntos y producto cartesiano
 -- Creamos una tabla temporal
 DROP TEMPORARY TABLE IF EXISTS TT1;
 CREATE TEMPORARY TABLE TT1
 AS
 (
	SELECT *
	FROM
	(
		SELECT nombre_actor, apellido_actor FROM Actor_Pelicula
	) AS T1
    
    CROSS JOIN
    (
		SELECT titulo_pelicula FROM actor_pelicula WHERE nombre_actor = "UMA" AND apellido_actor = "WOOD"
    )AS S
);

SELECT * FROM Actor_Pelicula;