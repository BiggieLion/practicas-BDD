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
*    30 de agosto del 2021
*/

USE Practica_1;

/*DIVISION A PARTIR DE LA RESTA DE CONJUNTOS Y PRODUCTO CARTESIANO
Las formulas para realizar la division de conjuntos es
T(x) <- R(x, y) / S(Y)
T1 <- piX(R)
T2 <- piX((T1*S)-R)
A = T1 - T2*/

/*MODIFICACION 1: Listar los actores que han participado exactamente en las mismas peliculas
que UMA WOOD*/
-- Creamos una tabla temporal, que es el conjunto S
CREATE TEMPORARY TABLE S AS
(
    SELECT ap_id_pelicula FROM Actor_Pelicula
    WHERE ap_id_actor = 13
);
SELECT COUNT(*) FROM S; 

-- Creamos T1
CREATE TEMPORARY TABLE T1 AS
(
    SELECT ap_id_actor FROM Actor_Pelicula AS R
);

CREATE TEMPORARY TABLE T1SX AS
(
    SELECT * FROM T1 CROSS JOIN S
);

-- Creamos T2
CREATE TEMPORARY TABLE T2 AS
(
    SELECT DISTINCT ap_id_actor FROM T1SX -- Nuestra tabla temporal
    WHERE NOT EXISTS
    (
        SELECT * FROM Actor_Pelicula R
        WHERE T1SX.ap_id_pelicula = R.ap_id_pelicula
        AND T1SX.ap_id_actor = R.ap_id_actor
    )
);

-- Realizamos la operacion T1 - T2
SELECT DISTINCT ap_id_actor AS Codigo_Del_Actor
FROM T1 -- Tabla temporal
WHERE NOT EXISTS
(
    SELECT * FROM T2 -- Tabla temporal
    WHERE T1.ap_id_actor = T2.ap_id_actor
);

SELECT DISTINCT T1.ap_id_actor
FROM T1 LEFT JOIN T2
ON T1.ap_id_actor = T2.ap_id_actor
WHERE T2.ap_id_actor IS NULL;