/* SCRIPT REALIZADO POR: Heber Jair León Ramírez & Enrique Javet Sanchéz Cerna 
El siguiente script es la definicion de la primera consulta en la Instancia 1
en la DB norenoro

4.- Determinar si las tres ciudades por region con el mayor numero de casos COVID tambien
    corresponden a las tres ciudades por region con el mayor numero de defunciones asociados
    a casos COVID*/    

USE norenoro;
GO

ALTER PROCEDURE consulta_4 AS
BEGIN
    DECLARE @servidor NVARCHAR(100);
	DECLARE @nombreBD NVARCHAR(100);
	DECLARE @nombreTabla NVARCHAR(100);
	DECLARE @consultaInicial NVARCHAR(2000);
	DECLARE @consultaFinal NVARCHAR(4000);
	DECLARE @contador INT;
	DECLARE @maximo INT;

    SET @consultaFinal = '';
	SELECT @contador = COUNT(*) FROM Diccionario;
	SELECT @maximo = COUNT(*) FROM Diccionario;

    WHILE @contador > 0
    BEGIN
        SET @consultaInicial = '';
        SELECT @servidor = diccionario_server, @nombreBD = diccionario_db, @nombreTabla = diccionario_tabla 
        FROM Diccionario WHERE @contador = diccionario_id_fragmento

        IF @servidor = 'SRVSURE'
            SET @consultaInicial = 'SELECT * FROM OPENQUERY('+@servidor+', ''SELECT *, "'+@nombreTabla+'" AS Region FROM (
                SELECT municipios_nombre as Casos FROM (
                    SELECT c_municipio_res, ce_entidad_res, COUNT(id_registro) AS Cantidad FROM '+@nombreBD+'.'+@nombreTabla+' 
                    WHERE ce_entidad_res = ce_entidad_um AND c_clasificacion_final IN (1, 2, 3) AND c_municipio_res != "999" 
                    GROUP BY c_municipio_res, ce_entidad_res ORDER BY Cantidad DESC LIMIT 3) AS T1 
                    JOIN '+@nombreBD+'.Municipios AS T2 ON 
                    T1.c_municipio_res = T2.municipios_clave AND T1.ce_entidad_res = T2.municipios_entidad) AS C1 
                    LEFT JOIN (
                    SELECT municipios_nombre AS Defunciones FROM (
                    SELECT c_municipio_res, ce_entidad_res, COUNT(id_registro) AS Cantidad 
                    FROM '+@nombreBD+'.'+@nombreTabla+' WHERE ce_entidad_res = ce_entidad_um AND 
                    fecha_defuncion != "9999-99-99" AND c_municipio_res != "999" 
                    GROUP BY c_municipio_res, ce_entidad_res ORDER BY Cantidad DESC LIMIT 3) AS T3 
                    JOIN ' +@nombreBD+'.Municipios AS T4 ON 
                    T3.c_municipio_res = T4.municipios_clave AND T3.ce_entidad_res = T4.municipios_entidad) AS C2 
                    ON C1.Casos = C2.Defunciones'')';

        ELSE 
            SET @consultaInicial = 'SELECT '''+@nombreTabla+''' AS Region, * FROM (
            SELECT municipios_nombre AS "Casos por region" FROM (
                    SELECT TOP 3 c_municipio_res, ce_entidad_res, COUNT(id_registro) AS Cantidad
                    FROM '+@servidor+'.'+@nombreBD+'.dbo.'+@nombreTabla+' WHERE ce_entidad_res = ce_entidad_um AND 
                    c_clasificacion_final IN (1, 2, 3) AND c_municipio_res != ''999'' 
                    GROUP BY c_municipio_res, ce_entidad_res ORDER BY Cantidad DESC) AS T1 
                    JOIN '+@servidor+'.'+@nombreBD+'.dbo.Municipios AS T2 ON 
                T1.c_municipio_res = T2.municipios_clave AND T1.ce_entidad_res = T2.municipios_entidad) AS C1
                LEFT JOIN (
                    SELECT municipios_nombre AS "Defunciones por region" FROM (
                        SELECT TOP 3 c_municipio_res, ce_entidad_res, COUNT(id_registro) AS Cantidad
                        FROM '+@servidor+'.'+@nombreBD+'.dbo.'+@nombreTabla+' WHERE ce_entidad_res = ce_entidad_um AND
                        fecha_defuncion != ''9999-99-99'' AND c_municipio_res != ''999'' 
                        GROUP BY c_municipio_res, ce_entidad_res ORDER BY Cantidad DESC) AS T3 
                        JOIN '+@servidor+'.'+@nombreBD+'.dbo.Municipios AS T4 ON 
                        T3.c_municipio_res = T4.municipios_clave AND T3.ce_entidad_res = T4.municipios_entidad) AS C2 ON
                        C1.[Casos por region] = C2.[Defunciones por region]'

        EXEC sys.sp_executesql @consultaInicial;
        SELECT @contador = @contador - 1;
    END
END

EXEC consulta_4;
