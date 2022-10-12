/* SCRIPT REALIZADO POR: Heber Jair León Ramírez & Enrique Javet Sanchéz Cerna 
El siguiente script es la definicion de la primera consulta en la Instancia 1
en la DB norenoro

3.- Listar el total de defunciones asociadas al COVID19 a nivel nacional, a nivel regional y por ciudad/region*/    

USE norenoro;
GO

ALTER PROCEDURE consulta_3 AS
BEGIN
    DECLARE @servidor NVARCHAR(100);
	DECLARE @nombreBD NVARCHAR(100);
	DECLARE @nombreTabla NVARCHAR(100);
	DECLARE @consultaInicial NVARCHAR(1000);
	DECLARE @consultaFinal NVARCHAR(4000);
	DECLARE @contador INT;
	DECLARE @maximo INT;

    SET @consultaFinal = '';
	SELECT @contador = COUNT(*) FROM Diccionario;
	SELECT @maximo = COUNT(*) FROM Diccionario;

    -- Consulta a nivel nacional
    SELECT COUNT(id_registro) AS "Total de defunciones a nievl nacional" 
    FROM SRVNORENORO.norenoro.dbo.CasosCovid WHERE fecha_defuncion != '9999-99-99';

    -- Consulta de las muertes a nivel region
    WHILE @contador > 0
    BEGIN
        SELECT @servidor = diccionario_server, @nombreBD = diccionario_db, @nombreTabla = diccionario_tabla 
        FROM Diccionario WHERE @contador = diccionario_id_fragmento

        IF @servidor = 'SRVSURE'
            set @consultaInicial = 'SELECT * FROM OPENQUERY('+@servidor+', ''SELECT "' +@nombreTabla+'" AS Region, COUNT(id_registro) AS "Total de defuniones a nivel regional" 
            FROM '+@nombreBD+'.'+@nombreTabla+ ' WHERE fecha_defuncion != ''''9999-99-99'''' '')'

        ELSE
            SET @consultaInicial = 'SELECT '''+@nombreTabla+'''AS Region, COUNT(*) AS "Total de defunciones a nivel regional" 
            FROM '+@servidor+'.'+@nombreBD+'.dbo.'+@nombreTabla+' WHERE fecha_defuncion != ''9999-99-99'''
        
        IF @contador != @maximo
            SET @consultaFinal = ''+@consultaFinal+ ' UNION '+@consultaInicial;

        ELSE
            SET @consultaFinal = '' + @consultaInicial;

        SELECT @contador = @contador - 1;
    END
    EXEC sys.sp_executesql @consultaFinal;

    -- Consulta por region
    SET @consultaFinal = '';
	SELECT @contador = COUNT(*) FROM Diccionario;
	SELECT @maximo = COUNT(*) FROM Diccionario;
    WHILE @contador > 0
    BEGIN
        SELECT @servidor = diccionario_server, @nombreBD = diccionario_db, @nombreTabla = diccionario_tabla 
        FROM Diccionario WHERE @contador = diccionario_id_fragmento

        IF @servidor = 'SRVSURE'
            SET @consultaInicial = 'SELECT * FROM OPENQUERY ('+@servidor+ ', ''SELECT "'+@nombreTabla+'" AS Region, municipios_nombre AS Ciudad, COUNT(*) AS "Total de defunciones por ciudad" 
            FROM '+@nombreBD+'.Municipios A JOIN '+@nombreBD+'.'+@nombreTabla+' B ON 
            A.municipios_clave = B.c_municipio_res AND
            A.municipios_entidad = B.ce_entidad_res 
            WHERE B.fecha_defuncion != ''''9999-99-99'''' 
            GROUP BY municipios_nombre ORDER BY COUNT(*) DESC'')'

        ELSE 
            SET @consultaInicial = 'SELECT '''+@nombreTabla+''' AS Region, municipios_nombre AS Ciudad, COUNT(*) AS "Total de defunciones por ciudad" 
            FROM '+@servidor+'.'+@nombreBD+'.dbo.Municipios A JOIN '+@servidor+'.'+@nombreBD+'.dbo.'+@nombreTabla+' B ON 
            A.municipios_clave = B.c_municipio_res AND
            A.municipios_entidad = B.ce_entidad_res 
            WHERE B.fecha_defuncion != ''9999-99-99''
            GROUP BY municipios_nombre ORDER BY COUNT(*) DESC'

        EXEC sys.sp_executesql @consultaInicial;
        SELECT @contador = @contador - 1;
    END
END

EXEC consulta_3;
