/*
*               INSTITUTO POLITENCNICO NACIONAL
*
*    UNIDAD PROFESIONAL INTERDISCIPLINARIA EN INGENIERIAS
*                Y TECNOLOGIAS AVANZADAS.
*
*    PRACTICA 1 de la U/A Base de Datos Distribuidas.
*
*    Alumnos: 
              Heber Jair León Ramírez
*             Enrique Javet Sanchez Cerna.
*
*    El siguiente script contiene la creacion de la base de datos,
*    de las tablas y las modificaciones de las consultas del dia
*    27 de agosto del 2021
*/

USE Practica_1;

/*Utilizando las vistas, equirreunion. subconsultas escalares, subconsultas de listas y resta de conjutos*/

/*MODIFICACION 1: SOLUCION CON JOIN Y VISTAS*/
-- Creando las vistas
CREATE VIEW Lista_Actor_Pelicula AS
SELECT ap_id_actor AS Codigo_Actor, COUNT(ap_id_pelicula) AS Cantidad
FROM Actor_Pelicula GROUP BY ap_id_actor;

-- Usando la vista
SELECT * FROM Lista_Actor_Pelicula 
WHERE Cantidad = 
                (
                    SELECT MAX(Cantidad)
                    FROM Lista_Actor_Pelicula
                ) LIMIT 1;

/*MODIFICACION 2: Solucion con equirreunion*/
SELECT AP1.ap_id_actor AS Codigo_De_Actor FROM
(
    SELECT ap_id_actor, COUNT(ap_id_pelicula) AS Cantidad
    FROM Actor_Pelicula
    GROUP BY ap_id_actor
) AS AP1
INNER JOIN
(
    SELECT MAX(Cantidad) AS ValorMaximo
    FROM
    (
        SELECT ap_id_actor, COUNT(ap_id_pelicula) AS cantidad
        FROM Actor_Pelicula
        GROUP BY ap_id_actor
    ) AS AP
) AS AP2
ON AP1.Cantidad = AP2.ValorMaximo LIMIT 1;

/*MODIFICACION 3: Listar que actores han participado en al menos
3 peliculas junto a UMA WOOD*/
-- Sabemos que el ID de UMA WOOD es 13
SELECT DISTINCT ap_id_actor AS Codigo_del_Actor
FROM Actor_Pelicula
WHERE ap_id_actor != 13 AND ap_id_pelicula IN
(
    SELECT DISTINCT ap_id_pelicula FROM Actor_Pelicula
    WHERE ap_id_actor = 13
)  GROUP BY ap_id_actor HAVING COUNT(*) >= 3;

/*Implementacion de la resta de conjunto A - B
Usamos LEFT JOIN para validar que las columnas del conjunto sean NULL
Subconjunta lista NOT IN
Funcion EXISTS en su forma negada NOT EXISTS

Implementamos la interseccion de conjuntos con el operador INNER JOIN
que seria una equirreunion*/

/*MODIFICACION 4: Listar los actores que participan en las mismas peliculas que
UMA WOOD*/
-- Realizamos la solucion a travez de vistas
--Conjunto A
DROP VIEW Conjunto_A;
DROP VIEW Conjunto_B;
CREATE VIEW Conjunto_A AS
SELECT * FROM Actor_Pelicula
WHERE ap_id_actor = 13;

-- Conjunto B
CREATE VIEW Conjunto_B AS
SELECT * FROM Actor_Pelicula
WHERE ap_id_pelicula != 13;

SELECT Conjunto_B.ap_id_actor FROM Conjunto_A INNER JOIN Conjunto_B
WHERE Conjunto_A.ap_id_actor = 13
AND Conjunto_A.ap_id_actor != Conjunto_B.ap_id_actor
AND Conjunto_A.ap_id_pelicula = Conjunto_B.ap_id_pelicula;