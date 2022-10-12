/*
*               INSTITUTO POLITENCNICO NACIONAL
*
*    UNIDAD PROFESIONAL INTERDISCIPLINARIA EN INGENIERIAS
*                Y TECNOLOGIAS AVANZADAS.
*
*    PRACTICA 1 de la U/A Base de Datos Distribuidas.
*
*    Alumnos: Heber Jair León Ramírez
*             Enrique Javet Sanchez Cerna.
*
*    El siguiente script contiene la creacion de la base de datos,
*    de las tablas y las modificaciones de las consultas del dia
*    24 de agosto del 2021
*/

DROP DATABASE practica_1;
CREATE DATABASE Practica_1;
USE Practica_1;

DROP TABLE IF EXISTS Actor;
DROP TABLE IF EXISTS Pelicula;
DROP TABLE IF EXISTS Actor_Pelicula;

-- Creamos las tablas normalizadas
CREATE TABLE Actor
(
	actor_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    actor_nombre VARCHAR(25) NOT NULL,
    actor_apellido VARCHAR(25) NOT NULL
);

CREATE TABLE Pelicula
(
	pelicula_id INT NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    pelicula_titulo VARCHAR(70) NOT NULL
);

CREATE TABLE Actor_Pelicula
(
	ap_id_actor INT NOT NULL,
    ap_id_pelicula INT NOT NULL,
    
    FOREIGN KEY (ap_id_actor) REFERENCES Actor(actor_id),
    FOREIGN KEY (ap_id_pelicula) REFERENCES Pelicula(pelicula_id)
);

-- Insertamos los datos en la tabla
-- Actores 
INSERT INTO Actor(actor_nombre, actor_apellido)
SELECT DISTINCT nombre_actor, apellido_actor FROM actorpelicula.actor_pelicula;

SELECT * FROM Actor;

-- Peliculas
INSERT INTO Pelicula (pelicula_titulo)
SELECT DISTINCT titulo_pelicula FROM actorpelicula.actor_pelicula;

SELECT * FROM Pelicula;

-- Relacion de Actores con Peliculas
INSERT INTO Actor_Pelicula(ap_id_actor, ap_id_pelicula) -- Referenciamos a la tabla de relacion
SELECT actor_id, pelicula_id FROM Actor A -- Seleccionamos el 
JOIN actorpelicula.actor_pelicula AP JOIN Pelicula P
ON A.actor_nombre = AP.nombre_actor
AND A.actor_apellido = AP.apellido_actor
AND P.pelicula_titulo = AP.titulo_pelicula;

/*MODIFICACION 1: Listar en que peliculas ha participado cada actor*/
SELECT actor_nombre AS "Nombre del actor", actor_apellido AS "Apellido del Actor", pelicula_titulo AS "Titulo de la Pelicula" 
FROM Actor_Pelicula AP JOIN Actor A
JOIN Pelicula P
ON A.actor_id = AP.ap_id_actor
AND P.pelicula_id = AP.ap_id_pelicula
ORDER BY actor_nombre;

/*MODIFICACION 2: Listar los actores de cada pelicula*/
SELECT pelicula_titulo AS "Titulo de la Pelicula", actor_nombre AS "Nombre del actor", actor_apellido AS "Apellido del Actor" 
FROM Actor_Pelicula AP JOIN Actor A
JOIN Pelicula P
ON A.actor_id = AP.ap_id_actor
AND P.pelicula_id = AP.ap_id_pelicula
ORDER BY pelicula_titulo;

/*MODIFICACION 3: Listar los actores que han participado en la misma pelicula que UMA WOODS*/
-- Corroboramos el ID de UMA WOODS
SELECT actor_id FROM Actor WHERE actor_nombre = "UMA" AND actor_apellido = "WOOD";

-- Su ID es 13, por lo tanto operaremos con su ID
-- Solucion por Resta de Conjuntos
SELECT DISTINCT A.actor_nombre AS "Nombre del Actor", A.actor_apellido AS "Apellido del Actor"
FROM Actor_Pelicula AP JOIN Actor A
WHERE AP.ap_id_actor != 13  -- Indicamos en el conjunto A que debe estar UMA WOOD 
AND AP.ap_id_pelicula IN 
                        (
                            SELECT AP1.ap_id_pelicula
                            FROM Actor_Pelicula AP1
                            WHERE AP1.ap_id_actor = 13
                        );

-- Solucion por LEFT JOIN
SELECT * FROM
(
    SELECT * FROM Actor_Pelicula AP WHERE AP.ap_id_actor = 13
) AS A
LEFT JOIN
(
    SELECT DISTINCT AP1.* FROM Actor_Pelicula AP1 INNER JOIN Actor_Pelicula AP2
    ON AP1.ap_id_actor = 13
    AND AP1.ap_id_pelicula = AP2.ap_id_pelicula
    AND AP1.ap_id_actor != AP2.ap_id_actor
) AS B
ON A.ap_id_pelicula = B.ap_id_pelicula
WHERE B.ap_id_pelicula IS NULL;

/*MODIFICACION 3: Listar las peliculas con un solo actor asociado*/
SELECT AP1.ap_id_pelicula, COUNT(AP2.ap_id_actor)
FROM Actor_Pelicula AP1 JOIN Actor_Pelicula AP2
WHERE AP1.ap_id_pelicula = AP2.ap_id_pelicula
GROUP BY AP1.ap_id_pelicula HAVING COUNT(AP2.ap_id_actor) = 1;

/*MODIFICACION 4: Listar el top 5 de actores con mas peliculas*/
SELECT ap_id_actor, COUNT(ap_id_pelicula) AS Cantidad
FROM Actor_Pelicula
GROUP BY ap_id_actor
HAVING COUNT(ap_id_pelicula) = 
                                (
                                    SELECT MAX(COUNT(ap_id_pelicula))
                                    FROM
                                    (
                                        SELECT ap_id_actor, COUNT(ap_id_pelicula) FROM Actor_Pelicula
                                        GROUP BY ap_id_actor
                                    ) AS AP
                                );