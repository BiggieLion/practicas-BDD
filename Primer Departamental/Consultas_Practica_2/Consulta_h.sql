-- 8va Consulta: Determinar cuántosextranjeros  hay  registrados  con  casos  COVID  en  la  base  de datos, cuantas defunciones y cuantos recuperados.

use noroeste;

go
alter procedure consulta_8 as
begin
  declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @sql nvarchar(1000);
  declare @sqlF1 nvarchar(4000);
  
  declare @MyTable Table (Region varchar (15),Casos_Covid int,Defunciones int,Recuperados int);
  declare @clm1 int;
  declare @clm2 int;
  declare @clm3 int;

  declare @FechaDef nvarchar(15);
  declare @cont int;

  select @FechaDef='''''9999-99-99''''';

	select @cont = count(*) from diccionario_dist;
   while @cont>0
   begin
	select @servidor = servidor, @nom_bd = bd, @nom_tabla= ntabla 
	from diccionario_dist where id_fragmento=@cont
	   if @servidor = 'SV_CENTRO'
			 set @sql = 'select @clm1=Edad60,@clm2=Edad4060,@clm3=Edad1839  from openquery ('+@servidor+ ', ''select count(*) as "Edad60" from ' + @nom_bd + '.' + @nom_tabla +' where c_nacionalidad=2 and c_clasificacion_final in (1,2,3)''),
			  openquery ('+@servidor+ ', ''select count(*) as "Edad4060" from ' + @nom_bd + '.' + @nom_tabla +' where fecha_defuncion!='+ @FechaDef+'and c_clasificacion_final in (1,2,3)''),
			  openquery ('+@servidor+ ', ''select count(*) as "Edad1839" from ' + @nom_bd + '.' + @nom_tabla +' where fecha_defuncion='+ @FechaDef+'and c_clasificacion_final in (1,2,3) and c_tipo_pac=1'')'
		  else
			 set @sql = 'select  @clm1=Edad60,@clm2=Edad4060,@clm3=Edad1839 from(
			 select  count(*) "Edad60",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where c_nacionalidad=2 and c_clasificacion_final in (1,2,3)) as "Edad4060",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where fecha_defuncion!=''9999-99-99''and c_clasificacion_final in (1,2,3)) as "Edad1839"
			 from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where fecha_defuncion=''9999-99-99''and c_clasificacion_final in (1,2,3) and c_tipo_pac=1) as aux';

	   	   exec sys.sp_executesql @sql,N'@clm1 int OUTPUT,@clm2 int OUTPUT,@clm3 int OUTPUT',@clm1=@clm1 OUTPUT,@clm2=@clm2 OUTPUT,@clm3=@clm3 OUTPUT;
		   insert into @MyTable values(@nom_bd,@clm1,@clm2,@clm3);
		   select @cont=@cont-1;
	end

	select 'Toda_la_base' as Area,sum(Casos_Covid) as CasosCovid,sum(Defunciones) as Defunciones,sum(Recuperados) as Recuperados from @MyTable
end

exec consulta_8;
