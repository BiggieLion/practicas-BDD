/* SCRIPT REALIZADO POR: Heber Jair León Ramírez & Enrique Jvet Sanchéz Cerna 
El siguiente script es respecto a la region Noroeste y Noreste de la instancia 1
de SQLServer*/

-- Creamos la base de datos para la zona Noreste Noroeste 
DROP DATABASE IF EXISTS norenoro;
CREATE DATABASE norenoro;
USE norenoro;

-- Creamos la tabla donde guardaremos todo los datos de COVID
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

-- Importamos a la tabla
BULK INSERT CasosCovid FROM 'C:\users\public\covid_mexico.csv' WITH(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = 65001,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);

/* Creamos una segunda tabla donde guardaremos los datos exclusivos de los estados de la zona Noroeste y Noreste
Noroeste: Baja California, Baja California Sur, Chihuahua, Sinaloa y Sonora
Noreste: Coahuila, Durango, Nuevo Leon, San Luis Potosi y Tamaulipas. */
-- Creando la tabla para los estados
CREATE TABLE estados (
    estados_clave TINYINT,
    estados_nombre VARCHAR(60),
    estados_abreviatura VARCHAR(5)
);

BULK INSERT estados FROM 'C:\users\public\Entidades.csv' WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = 65001,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

-- Creacion de la tabla Noreste
CREATE TABLE RegNoreste (
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

-- Se inserta los datos a la tabla de Region Noreste 
INSERT INTO norenoro.dbo.RegNoreste
SELECT * FROM CasosCovid WHERE ce_entidad_um in (
    SELECT estados_clave FROM estados WHERE estados_nombre IN ('COAHUILA DE ZARAGOZA', 'DURANGO', 'NUEVO LEÓN', 'SAN LUIS POTOSÍ', 'TAMAULIPAS')
);

-- Creacion de la tabla de la region Noroeste
CREATE TABLE RegNoroeste (
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

-- Se inserta los datos de los estados de la region noroeste a la tabla correspondiente
INSERT INTO norenoro.dbo.RegNoroeste
SELECT * FROM CasosCovid WHERE ce_entidad_um IN (
    SELECT estados_clave FROM estados WHERE estados_nombre IN ('BAJA CALIFORNIA', 'BAJA CALIFORNIA SUR', 'CHIHUAHUA', 'SINALOA', 'SONORA')
);

-- Se fragmenta la tabla de la region Centro y Occidente
INSERT INTO SRVCENOCC.cenocc.dbo.RegCentro
SELECT * FROM CasosCovid WHERE ce_entidad_um IN (
    SELECT estados_clave FROM estados WHERE estados_nombre IN ('CIUDAD DE MÉXICO', 'MÉXICO', 'GUERRERO', 'HIDALGO', 'MORELOS', 'PUEBLA', 'TLAXCALA')
);

INSERT INTO SRVCENOCC.cenocc.dbo.RegOccidente
SELECT * FROM CasosCovid WHERE ce_entidad_um IN (
    SELECT estados_clave FROM estados WHERE estados_nombre IN ('AGUASCALIENTES', 'COLIMA', 'GUANAJUATO', 'JALISCO', 'MICHOACÁN DE OCAMPO', 'NAYARIT', 'QUERÉTARO', 'ZACATECAS')
);

-- Se fragmenta la tabla de la region sureste (instancia MySQL) desde su servidor vinculado.
INSERT INTO OPENQUERY (SRVSURE, 'SELECT * FROM sureste.RegSureste')
SELECT * FROM norenoro.dbo.CasosCovid WHERE ce_entidad_um in (
    SELECT estados_clave FROM estados WHERE estados_nombre IN ('CAMPECHE', 'CHIAPAS', 'OAXACA', 'QUINTANA ROO', 'TABASCO', 'VERACRUZ DE IGNACIO DE LA LLAVE', 'YUCATÁN')
);

-- Ya desfragmentada la DB, se elimina las tablas de CasosCovid y Estados
DROP TABLE IF EXISTS casoscovid;
DROP TABLE IF EXISTS estados;

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

SELECT * FROM norenoro.dbo.Diccionario; -- Se verifica que se haya insertado los valores de manera correcta

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


SELECT * FROM norenoro.dbo.Rel_Fragmento_Entidad; -- Se verifica que los datos se hayan ingresado de manera correcta

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
SELECT * FROM norenoro.dbo.Municipios;