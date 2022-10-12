DROP DATABASE IF EXISTS COVID19;
CREATE DATABASE COVID19;
USE COVID19;

CREATE TABLE Datos
(
	fecha_act date,
	id_registro varchar(40),
	c_origen tinyint,
	c_sector tinyint,
	ce_entidad_um tinyint,
	c_sexo tinyint,
	ce_entidad_nac tinyint,
	ce_entidad_res tinyint,
	c_municipio_res varchar(4),
	c_tipo_pac tinyint,
	fecha_ingreso date,
	fecha_sintomas date,
	fecha_defuncion varchar(10),
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
	c_pais_nac varchar(500),
	c_pais_ori varchar (500),
	csn_uci tinyint
);


