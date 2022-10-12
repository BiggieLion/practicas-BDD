/* SCRIPT REALIZADO POR: Heber Jair León Ramírez & Enrique Javet Sanchéz Cerna 
El siguiente script es la definicion de la primera consulta en la Instancia 1
en la DB norenoro

2.- Listar las tres ciudades por region con el mayor numero de casos de COVID registrados*/

USE norenoro;
GO

ALTER PROCEDURE consulta_2 AS
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

    WHILE @contador > 0
    BEGIN
        SELECT @servidor = diccionario_server, @nombreBD = diccionario_db, @nombreTabla= diccionario_tabla 
		FROM Diccionario WHERE diccionario_id_fragmento = @contador

        IF @servidor = 'SRVSURE'
            SET @consultaInicial = 'SELECT * FROM ('+@servidor+', ''SELECT municipios_nombre AS ' + @nombreTabla + ' FROM (
            SELECT c_municipio_res, ce_entidad_res, COUNT(id_registro) AS Cantidad FROM '+@nombreBD+'.'+@nombreTabla+
            ' WHERE ce_entidad_res = ce_entidad_um AND c_clasificacion_final IN (1, 2, 3) AND c_municipio_res != ''''9999'''' 
            GROUP BY c_municipio_res, ce_entidad_res ORDER BY Cantidad DESC LIMIT 3) AS T1 
            JOIN '+ @nombreBD + '.' + @nombreTabla + ' as T2 ON 
            T1.c_municipio_res = T2.municipios_clave AND T1.ce_entidad_tes = T2.municipios_entidad 
            ORDER BY Cantidad DESC;'')'
        ELSE
            SET @consultaInicial = 'SELECT municipios_nombre AS ''' + @nombreTabla + '''FROM (
                SELECT TOP 3 c_municipio_res, ce_entidad_res, COUNT(id_registro) AS Cantidad FROM '
                + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' WHERE ce_entidad_res = ce_entidad_um 
                AND c_clasificacion_final IN (1, 2, 3) AND c_municipio_res != ''999'' GROUP BY c_municipio_res, ce_entidad_res 
                ORDER BY Cantidad DESC) AS T1
                JOIN ' + @servidor + '.' + @nombreBD + '.dbo.Municipios AS T2 
                ON T1.c_municipio_res = T2.municipios_clave AND T1.ce_entidad_res = T2.municipios_entidad 
                ORDER BY Cantidad DESC;'

        EXEC sys.sp_executesql @consultaInicial;
        SELECT @contador = @contador - 1;
    END
END

EXEC consulta_2;
