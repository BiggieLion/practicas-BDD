/* SCRIPT REALIZADO POR: Heber Jair León Ramírez & Enrique Javet Sanchéz Cerna 
El siguiente script es la definicion de la primera consulta en la Instancia 1
en la DB norenoro

5.- Listar por rango de edad listados en la consulta (a) el total de defunciones 
    a nivel nacional y por region */

USE norenoro;
GO

ALTER PROCEDURE consulta_5 AS
BEGIN
    DECLARE @servidor NVARCHAR(100);
	DECLARE @nombreBD NVARCHAR(100);
	DECLARE @nombreTabla NVARCHAR(100);
	DECLARE @consultaInicial NVARCHAR(2000);
	DECLARE @consultaFinal NVARCHAR(4000);
	DECLARE @contador INT;
	DECLARE @maximo INT;

	SELECT @contador = COUNT(*) FROM Diccionario;
	SELECT @maximo = COUNT(*) FROM Diccionario;

    -- Consulta a nivel nacional
    
    SELECT COUNT(id_registro) AS "Defunciones a nivel nacional en Mayores de 60 años", 
    (SELECT COUNT(id_registro) FROM SRVNORENORO.norenoro.dbo.CasosCovid WHERE edad BETWEEN 40 AND 60 AND fecha_defuncion != '9999-99-99') AS "Defunciones a nivel nacional entre 40 y 60 años", 
    (SELECT COUNT(id_registro) FROM SRVNORENORO.norenoro.dbo.CasosCovid WHERE edad BETWEEN 18 AND 39 AND fecha_defuncion != '9999-99-99') AS "Defunciones a nivel nacioanl entre 18 y 40 años", 
    (SELECT COUNT(id_registro) FROM SRVNORENORO.norenoro.dbo.CasosCovid WHERE edad < 18 AND fecha_defuncion != '9999-99-99') AS "Defunciones a nivel nacional en menores de 18 años"
    FROM SRVNORENORO.norenoro.dbo.CasosCovid WHERE edad > 60 AND fecha_defuncion != '9999-99-99';

    SET @consultaInicial = '';
    SET @consultaFinal = '';

    WHILE @contador > 0
    BEGIN
        SELECT @servidor = diccionario_server, @nombreBD = diccionario_db, @nombreTabla= diccionario_tabla 
		FROM Diccionario WHERE diccionario_id_fragmento=@contador
		IF @servidor = 'SRVSURE'
			SET @consultaInicial = 'SELECT *  FROM OPENQUERY ('+@servidor+ ', ''SELECT "'+@nombreTabla+'" AS "Region" ,COUNT(*) AS "Mayores de 60 años" FROM ' + @nombreBD + '.' + @nombreTabla +' WHERE edad>60 AND fecha_defuncion != "9999-99-99"''),
			OPENQUERY ('+@servidor+ ', ''SELECT COUNT(*) AS "Entre 40 y 60 años" FROM ' + @nombreBD + '.' + @nombreTabla +' WHERE edad BETWEEN 40 AND 60 AND fecha_defuncion != "9999-99-99"''),
			OPENQUERY ('+@servidor+ ', ''SELECT COUNT(*) AS "Entre 18 y 39 años" FROM ' + @nombreBD + '.' + @nombreTabla +' WHERE edad BETWEEN 18 AND 39 AND fecha_defuncion != "9999-99-99"''),
			OPENQUERY ('+@servidor+ ', ''SELECT COUNT(*) AS "Menores de 18 años" FROM ' + @nombreBD + '.' + @nombreTabla +' WHERE edad<18 AND fecha_defuncion != "9999-99-99"'')'
		ELSE
			SET @consultaInicial = 'SELECT '''+@nombreTabla+''' AS Region, COUNT(*) AS "Mayores de 60 años",
			(SELECT COUNT(*) FROM ' + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' WHERE edad BETWEEN 40 AND 60 AND fecha_defuncion != ''9999-99-99'') AS "Entre 40 y 60 años",
			(SELECT COUNT(*) FROM ' + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' WHERE edad BETWEEN 18 AND 39 AND fecha_defuncion != ''9999-99-99'') AS "Entre 18 y 39 años",
			(SELECT COUNT(*) FROM ' + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' WHERE edad<18 AND fecha_defuncion != ''9999-99-99'') AS "Menores de 18 años"
			FROM ' + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' WHERE edad>60 AND fecha_defuncion != ''9999-99-99''';
		
		IF @contador != @maximo
			SET @consultaFinal = ''+@consultaFinal+' union '+@consultaInicial;
		
		ELSE
			SET @consultaFinal = ''+@consultaInicial;
		
		SELECT @contador = @contador - 1;
	END
	EXEC sys.sp_executesql @consultaFinal;
END

EXEC consulta_5;
