CREATE DATABASE COVID_MX;

SELECT name, collation_name FROM sys.databases WHERE name = N'COVID_MX';
GO
ALTER DATABASE COVID_MX COLLATE Latin1_General_100_CI_AS_SC

USE COVID_MX;

-- Eliminamos la tabla si existe
DROP TABLE IF EXISTS Casos_Covid;

GO
-- Create the table in the specified schema
CREATE TABLE Casos_Covid
(
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
GO

BULK INSERT Casos_Covid 
FROM 'C:\Users\Public\covid_mexico.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    CODEPAGE = 65001,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
)

SELECT * FROM Casos_Covid;