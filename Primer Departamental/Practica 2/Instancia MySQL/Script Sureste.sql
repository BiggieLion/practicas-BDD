CREATE DATABASE sureste;
USE sureste;

CREATE TABLE RegSureste (
    fecha_act date,
    id_registro varchar(10), --  collate Latin1_General_100_CS_AS_SC_UTF8,
    c_origen tinyint,
    c_sector tinyint,
    ce_entidad_um tinyint,
    c_sexo tinyint,
    ce_entidad_nac tinyint,
    ce_entidad_res tinyint,
    c_municipio_res varchar(40), --  collate Latin1_General_100_CS_AS_SC_UTF8,
    c_tipo_pac tinyint,
    fecha_ingreso date,
    fecha_sintomas date,
    fecha_defuncion varchar(40), --  collate Latin1_General_100_CS_AS_SC_UTF8,
    csn_intubado tinyint,
    csn_neumonia tinyint,
    edad tinyint,
    c_nacionalidad tinyint,
    csn_embarazo tinyint,
    csn_lengua_indig tinyint,
    csn_indigena tinyint,
    csn_diabetes tinyint,
    csn_epoc tinyint,
    csn_asma tinyint,
    csn_inmusupr tinyint,
    csn_hipertension tinyint,
    csn_otras_com tinyint,
    csn_cardiovascular tinyint,
    csn_obesidad tinyint,
    csn_renal_cronica tinyint,
    csn_tabaquismo tinyint,
    csn_otrocaso tinyint,
    csn_toma_muestra_lab tinyint,
    c_resultado_lab tinyint,
    csn_toma_muestra_antigeno tinyint,
    c_resultado_antigeno tinyint,
    c_clasificacion_final tinyint,
    csn_migrante tinyint,
    c_pais_nac varchar(500), -- collate Latin1_General_100_CS_AS_SC_UTF8,
    c_pais_ori varchar(500), -- collate Latin1_General_100_CS_AS_SC_UTF8,
    csn_uci tinyint
);

-- Se verifica que la fragmentación que se realizó mediante SQLServer se haya realizado con exito
SELECT * FROM RegSureste;

-- Se crea el diccionario de datos para las consultas
CREATE TABLE Diccionario (
    diccionario_id_fragmento TINYINT PRIMARY KEY, -- Id del elemento del diccionario
    diccionario_server VARCHAR(80), -- Nombre del server donde se encuentra el elemento del diccionario
    diccionario_db VARCHAR(80), -- Nombre de la base de datos donde se encuentra el elemento del diccionario
    diccionario_tabla VARCHAR(80), -- Nombre de la tabla donde se encuentra el elemento del diccionario
    diccionario_entidad VARCHAR(80) -- Nombre de la entidad del elemento del diccionario
);

-- Se crea la tabla relacional
CREATE TABLE Rel_Fragmento_Entidad (
    rel_id_fragmento TINYINT,
    rel_clave_entidad VARCHAR(80),

    PRIMARY KEY (rel_id_fragmento, rel_clave_entidad),
    FOREIGN KEY (rel_id_fragmento) REFERENCES Diccionario(diccionario_id_fragmento)
);

-- Llenamos nuestro diccionario
INSERT INTO Diccionario VALUES (1, 'SRVNORENORO', 'norenoro', 'RegNoreste', 'ce_entidad_um'); -- Instancia 1 SQL Server
INSERT INTO Diccionario VALUES (2, 'SRVNORENORO', 'norenoro', 'RegNoroeste', 'ce_entidad_um'); -- Instancia 1 SQL Server
INSERT INTO Diccionario VALUES (3, 'SRVCENOCC', 'cenocc', 'RegCentro', 'ce_entidad_um'); -- Instancia 2 SQL Server
INSERT INTO Diccionario VALUES (4, 'SRVCENOCC', 'cenocc', 'RegOccidente', 'ce_entidad_um'); -- Instancia 2 SQL Server
INSERT INTO Diccionario VALUES (5, 'SRVSURE', 'sureste', 'RegSureste', 'ce_entidad_um'); -- Instancia MySQL

SELECT * FROM sureste.diccionario; -- Se verifica que los datos se hayan ingresado correctamente al diccionario

-- Se inserta los datos de los estados en la tabla relacional (las entidades se insertan por orden alfabetico)
-- Region Noreste
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '5'); -- COAHUILA DE ZARAGOZA
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '10'); -- DURANGO
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '19'); -- NUEVO LEÓN
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '24'); -- SAN LUIS POTOSÍ
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '28'); -- TAMAULIPAS

-- Region Noroeste
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '2'); -- BAJA CALIFORNIA
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '3'); -- BAJA CALIFORNIA SUR
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '8'); -- CHIHUAHUA
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '25'); -- SINALOA
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '26'); -- SONORA

-- Region Centro
INSERT INTO Rel_Fragmento_Entidad VALUES (3, '9'); -- CIUDAD DE MÉXICO
INSERT INTO Rel_Fragmento_Entidad VALUES (3, '12'); -- GUERRERO
INSERT INTO Rel_Fragmento_Entidad VALUES (3, '13'); -- HIDALGO
INSERT INTO Rel_Fragmento_Entidad VALUES (3, '15'); -- MÉXICO
INSERT INTO Rel_Fragmento_Entidad VALUES (3, '17'); -- MORELOS
INSERT INTO Rel_Fragmento_Entidad VALUES (3, '21'); -- PUEBLA
INSERT INTO Rel_Fragmento_Entidad VALUES (3, '29'); -- TLAXCALA

-- Region Occidente
INSERT INTO Rel_Fragmento_Entidad VALUES (4, '1'); -- AGUASCALIENTE
INSERT INTO Rel_Fragmento_Entidad VALUES (4, '6'); -- COLIMA
INSERT INTO Rel_Fragmento_Entidad VALUES (4, '11'); -- GUANAJUATO
INSERT INTO Rel_Fragmento_Entidad VALUES (4, '14'); -- JALISCO
INSERT INTO Rel_Fragmento_Entidad VALUES (4, '16'); -- MICHOACÁN DE OCAMPO
INSERT INTO Rel_Fragmento_Entidad VALUES (4, '18'); -- NAYARIT
INSERT INTO Rel_Fragmento_Entidad VALUES (4, '22'); -- QUERÉTARO
INSERT INTO Rel_Fragmento_Entidad VALUES (4, '32'); -- ZACATECAS

-- Region Sureste
INSERT INTO Rel_Fragmento_Entidad VALUES (5, '4'); -- CAMPECHE
INSERT INTO Rel_Fragmento_Entidad VALUES (5, '7'); -- CHIAPAS
INSERT INTO Rel_Fragmento_Entidad VALUES (5, '20'); -- OAXACA
INSERT INTO Rel_Fragmento_Entidad VALUES (5, '23'); -- QUINTANA ROO
INSERT INTO Rel_Fragmento_Entidad VALUES (5, '27'); -- TABASCO
INSERT INTO Rel_Fragmento_Entidad VALUES (5, '30'); -- VERACRUZ DE IGNACIO DE LA LLAVE
INSERT INTO Rel_Fragmento_Entidad VALUES (5, '31'); -- YUCATÁN

-- Creamos una tabla auxiliar de Municipios para las consultas.
CREATE TABLE Municipios (
    municipios_clave VARCHAR(40) COLLATE utf8mb4_0900_ai_ci,
    municipios_nombre VARCHAR (100) COLLATE utf8mb4_0900_ai_ci,
    municipios_entidad TINYINT COLLATE utf8mb4_0900_ai_ci
);

-- Insertamos los datos del archivo Municipios.csv a la tabla
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Municipios.csv'
INTO TABLE Municipios
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

SELECT * FROM Municipios;

SELECT municipios_nombre as RegSureste FROM (
	SELECT c_municipio_res, ce_entidad_res, COUNT(id_registro) AS Cantidad FROM sureste.regsureste
	WHERE ce_entidad_res = ce_entidad_um AND c_clasificacion_final IN (1, 2, 3) AND c_municipio_res != '999'
	GROUP BY c_municipio_res, ce_entidad_res ORDER BY Cantidad DESC LIMIT 3) AS T1
JOIN sureste.municipios as T2 ON 
T1.c_municipio_res = T2.municipios_clave AND T1.ce_entidad_res = T2.municipios_entidad
ORDER BY Cantidad DESC;

SELECT *, "RegSureste" AS Region FROM (
SELECT municipios_nombre as Casos FROM (
	SELECT c_municipio_res, ce_entidad_res, COUNT(id_registro) AS Cantidad FROM sureste.RegSureste
	WHERE ce_entidad_res = ce_entidad_um AND c_clasificacion_final IN (1, 2, 3) AND c_municipio_res != '999'
	GROUP BY c_municipio_res, ce_entidad_res ORDER BY Cantidad DESC LIMIT 3) AS T1
JOIN sureste.municipios as T2 ON 
T1.c_municipio_res = T2.municipios_clave AND T1.ce_entidad_res = T2.municipios_entidad) AS C1 
LEFT JOIN (
SELECT municipios_nombre AS Defunciones FROM (
SELECT c_municipio_res, ce_entidad_res, COUNT(id_registro) AS Cantidad 
FROM sureste.RegSureste WHERE ce_entidad_res = ce_entidad_um AND 
fecha_defuncion != '9999-99-99' AND c_municipio_res != '999' 
GROUP BY c_municipio_res, ce_entidad_res ORDER BY Cantidad DESC LIMIT 3) AS T3 
JOIN sureste.Municipios AS T4 ON 
T3.c_municipio_res = T4.municipios_clave AND T3.ce_entidad_res = T4.municipios_entidad) AS C2 
ON C1.Casos = C2.Defunciones;