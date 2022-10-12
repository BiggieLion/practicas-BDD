/* SCRIPT REALIZADO POR: Heber Jair León Ramírez & Enrique Javet Sanchéz Cerna 
El siguiente script es la definicion de la primera consulta en la Instancia 1
en la DB norenoro*/

/* 1.- Listar el total de casos COVID de cada region, en los siguientes rangos:
a) Mayores a 60 años.
b) Entre 40 y 60 años.
c) Entre 18 y 39 años.
d) Menor a 18 años. */

USE norenoro;
GO

ALTER PROCEDURE consulta_1 AS
BEGIN
	DECLARE @servidor NVARCHAR(100);
	DECLARE @nombreBD NVARCHAR(100);
	DECLARE @nombreTabla NVARCHAR(100);
	DECLARE @consultaInicial NVARCHAR(1000);
	DECLARE @consultaFINal NVARCHAR(4000);
	DECLARE @contador INT;
	DECLARE @maximo INT;


	SET @consultaFINal='';
	SELECT @contador = COUNT(*) FROM Diccionario;
	SELECT @maximo = COUNT(*) FROM Diccionario;
	
	WHILE @contador > 0
	BEGIN
		SELECT @servidor = diccionario_server, @nombreBD = diccionario_db, @nombreTabla= diccionario_tabla 
		FROM Diccionario WHERE diccionario_id_fragmento=@contador
		IF @servidor = 'SRVSURE'
			SET @consultaInicial = 'SELECT *  FROM OPENQUERY ('+@servidor+ ', ''SELECT "'+@nombreTabla+'" AS "Region" ,COUNT(*) AS "Mayores de 60 años" FROM ' + @nombreBD + '.' + @nombreTabla +' WHERE edad>60 AND c_clasificacion_final IN (1,2,3)''),
			OPENQUERY ('+@servidor+ ', ''SELECT COUNT(*) AS "Entre 40 y 60 años" FROM ' + @nombreBD + '.' + @nombreTabla +' WHERE edad BETWEEN 40 AND 60 AND c_clasificacion_final IN (1,2,3)''),
			OPENQUERY ('+@servidor+ ', ''SELECT COUNT(*) AS "Entre 18 y 39 años" FROM ' + @nombreBD + '.' + @nombreTabla +' WHERE edad BETWEEN 18 AND 39 AND c_clasificacion_final IN (1,2,3)''),
			OPENQUERY ('+@servidor+ ', ''SELECT COUNT(*) AS "Menores de 18 años" FROM ' + @nombreBD + '.' + @nombreTabla +' WHERE edad<18 AND c_clasificacion_final IN (1,2,3)'')'
		ELSE
			SET @consultaInicial = 'SELECT '''+@nombreTabla+''' AS Region, COUNT(*) AS "Mayores de 60 años",
			(SELECT COUNT(*) FROM ' + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' WHERE edad BETWEEN 40 AND 60 AND c_clasificacion_final IN (1,2,3)) AS "Entre 40 y 60 años",
			(SELECT COUNT(*) FROM ' + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' WHERE edad BETWEEN 18 AND 39 AND c_clasificacion_final IN (1,2,3)) AS "Entre 18 y 39 años",
			(SELECT COUNT(*) FROM ' + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' WHERE edad<18 AND c_clasificacion_final IN (1,2,3)) AS "Menores de 18 años"
			FROM ' + @servidor + '.' + @nombreBD + '.dbo.' + @nombreTabla + ' WHERE edad>60 AND c_clasificacion_final IN (1,2,3)';
		
		IF @contador != @maximo
			SET @consultaFINal = ''+@consultaFINal+' union '+@consultaInicial;
		
		ELSE
			SET @consultaFINal = ''+@consultaInicial;
		
		SELECT @contador = @contador - 1;
	END
	EXEC sys.sp_executesql @consultaFINal;
END

EXEC consulta_1;

