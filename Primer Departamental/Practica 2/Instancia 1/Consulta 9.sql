/* SCRIPT REALIZADO POR: Heber Jair León Ramírez & Enrique Javet Sanchéz Cerna 
El siguiente script es la definicion de la primera consulta en la Instancia 1
en la DB norenoro

9.- Determinar en cuantos casos a nivel nacional y por region difiere la entidad 
    de atencion medica en la entidad de residencia. */
USE norenoro;
GO

ALTER PROCEDURE consulta_9 AS 
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

    -- Consulta a nivel nacional
    SELECT COUNT(id_registro) AS "Total a nivel nacional" FROM SRVNORENORO.norenoro.dbo.CasosCovid
    WHERE ce_entidad_res != ce_entidad_um AND c_clasificacion_final IN (1, 2, 3);

    -- A nivel Region
    WHILE @contador > 0
    BEGIN
        SELECT @servidor = diccionario_server, @nombreBD = diccionario_db, @nombreTabla= diccionario_tabla 
		FROM Diccionario WHERE diccionario_id_fragmento = @contador

		IF @servidor = 'SRVSURE'
			SET @consultaInicial = 'SELECT *  FROM OPENQUERY ('+@servidor+ ', ''SELECT "'+@nombreTabla+'" AS "Region" ,COUNT(id_registro) AS "Total en la region" FROM ' + @nombreBD + '.' + @nombreTabla +' 
            WHERE ce_entidad_res != ce_entidad_um AND c_clasificacion_final IN (1, 2, 3)'')'
		ELSE
			SET @consultaInicial = 'SELECT '''+@nombreTabla+''' AS Region, COUNT(*) AS "Total en la region" FROM ' + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' 
            WHERE ce_entidad_res != ce_entidad_um AND c_clasificacion_final IN (1, 2, 3)';
		
		IF @contador != @maximo
			SET @consultaFinal = ''+@consultaFinal+' union '+@consultaInicial;
		
		ELSE
			SET @consultaFinal = ''+@consultaInicial;
		
		SELECT @contador = @contador - 1;
	END
	EXEC sys.sp_executesql @consultaFinal;
END

EXEC consulta_9;