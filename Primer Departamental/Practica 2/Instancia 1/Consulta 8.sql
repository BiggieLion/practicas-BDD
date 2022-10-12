/* SCRIPT REALIZADO POR: Heber Jair León Ramírez & Enrique Javet Sanchéz Cerna 
El siguiente script es la definicion de la primera consulta en la Instancia 1
en la DB norenoro

8.- Determinar cuantos extranjeros hay registrados con casos COVID en la base de datos, cuantas defunciones y
    cuantos recupereados. */
USE norenoro;
GO

ALTER PROCEDURE consulta_8 AS
BEGIN
    -- Verificamos cuantos extranjeros hay
    SELECT COUNT(id_registro) AS Extranjeros FROM SRVNORENORO.norenoro.dbo.CasosCovid 
    WHERE csn_migrante = 1;

    -- Verificamos cuantas defunciones de extranjeros hay
    SELECT COUNT(id_registro) AS Defunciones FROM SRVNORENORO.norenoro.dbo.CasosCovid
    WHERE csn_migrante = 1 AND fecha_defuncion != '9999-99-99';

    -- Verificamos cuantos extranjeros se recuperaron
    SELECT COUNT(id_registro) AS Recuperados FROM SRVNORENORO.norenoro.dbo.CasosCovid
    WHERE csn_migrante = 1 AND fecha_defuncion = '9999-99-99' AND c_tipo_pac = 1 AND c_clasificacion_final IN (1, 2, 3);
END

EXEC consulta_8;
