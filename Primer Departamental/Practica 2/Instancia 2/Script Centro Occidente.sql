/* SCRIPT REALIZADO POR: Heber Jair León Ramírez & Enrique Jvet Sanchéz Cerna 
El siguiente script es respecto a la region Centro y Occidente de la instancia 2
de SQLServer*/
DROP DATABASE IF EXISTS cenocc;
CREATE DATABASE cenocc;
USE cenocc;

-- Se crea la tabla de los casos COVID para la region Occidente
CREATE TABLE CasosCovid (
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

-- Se inserta desde el archivo CSV los datos de la DB Covid
BULK INSERT CasosCovid FROM 'C:\users\public\covid_mexico.csv' WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = 65001,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Se crea la tabla de la region OCCIDENTE
CREATE TABLE RegOccidente (
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

ALTER TABLE RegCentro
ALTER COLUMN id_registro VARCHAR(10) COLLATE 

-- Se crea la tabla de los casos COVID de la region CENTRO
CREATE TABLE RegCentro (
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

-- Se crea la tabla de entidades para poder fragmentar la DB
CREATE TABLE Estados (
    Estados_Clave  TINYINT,
    Estados_Nombre VARCHAR(60),
    Estados_Abreviatura VARCHAR(5)
);

-- Se inserta a la tabla de estados los datos desde el archivo CSV
BULK INSERT estados FROM 'C:\users\public\Entidades.csv' WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = 65001,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

-- Se fragmenta la DB con los datos de la region CENTRO
INSERT INTO cenocc.dbo.RegCentro
SELECT * FROM CasosCovid WHERE ce_entidad_um IN (
    SELECT Estados_Clave FROM Estados WHERE Estados_Nombre IN ('CIUDAD DE MÉXICO', 'MÉXICO', 'GUERRERO', 'HIDALGO', 'MORELOS','PUEBLA','TLAXCALA')
);

-- Se fragmenta la DB con los datos de la region OCCIDENTE
INSERT INTO cenocc.dbo.RegOccidente
SELECT * FROM CasosCovid WHERE ce_entidad_um IN (
    SELECT Estados_Clave FROM Estados WHERE Estados_Nombre IN ('AGUASCALIENTES', 'COLIMA', 'GUANAJUATO', 'JALISCO', 'MICHOACÁN DE OCAMPO', 'NAYARIT', 'QUERÉTARO', 'ZACATECAS')
);

-- Ya desfragmentada la DB, se elimina las tablas de CasosCovid y Estados
DROP TABLE IF EXISTS CasosCovid;
DROP TABLE IF EXISTS Estados;

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

SELECT * FROM cenocc.dbo.Diccionario; -- Se verifica que se haya insertado los valores de manera correcta

-- Se inserta los datos de los estados en la tabla relacional (las entidades se insertan por orden alfabetico)
-- Region Noreste
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '5'); -- COAHUILA DE ZARAGOZA
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '10'); -- DURANGO
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '19'); -- NUEVO LEÓN
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '24'); -- SAN LUIS POTOSÍ
INSERT INTO Rel_Fragmento_Entidad VALUES (1, '28'); -- TAMAULIPAS

-- Region Noroeste
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '2'); -- BAJA CALIFORNIA
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '3'); --BAJA CALIFORNIA SUR
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '8'); --CHIHUAHUA
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '25'); --SINALOA
INSERT INTO Rel_Fragmento_Entidad VALUES (2, '26'); --SONORA

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

SELECT * FROM Rel_Fragmento_Entidad;

-- Creamos una tabla auxiliar de Municipios para las consultas.
CREATE TABLE Municipios (
    municipios_clave VARCHAR(40) COLLATE Modern_Spanish_CI_AS,
    municipios_nombre VARCHAR (100) COLLATE Modern_Spanish_CI_AS,
    municipios_entidad TINYINT
);

-- Insertamos los datos a la tabla de Municipios
BULK INSERT Municipios FROM 'C:\users\public\Municipios.csv' WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = 65001,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

-- Verificamos que se hayan ingresados los datos de manera correcta
SELECT * FROM cenocc.dbo.Municipios;