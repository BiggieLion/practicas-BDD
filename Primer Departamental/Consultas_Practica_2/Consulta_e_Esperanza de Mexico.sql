-- 5nta Consulta: Listar por rango de edades listados en la consulta (a) el total de defunciones a nivel nacional y por región.
use noroeste

go
alter procedure consulta_5 as
begin
  declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @sql nvarchar(1000);
  declare @sqlF1 nvarchar(4000);
  
  declare @MyTable Table (Region varchar (15),Mayores_a_60 int,Entre_40_y_60 int,Entre_18_y_39 int,Menor_a_18 int);
  declare @MyTable2 Table (Region varchar (15),Mayores_a_60 int,Entre_40_y_60 int,Entre_18_y_39 int,Menor_a_18 int);
  declare @clm1 int;
  declare @clm2 int;
  declare @clm3 int;
  declare @clm4 int;

  declare @FechaDef nvarchar(15);
  declare @cont int;

  select @FechaDef='''''9999-99-99''''';

   select @cont = count(*) from diccionario_dist;
   while @cont>0
   begin
	select @servidor = servidor, @nom_bd = bd, @nom_tabla= ntabla 
	from diccionario_dist where id_fragmento=@cont
	   if @servidor = 'SV_CENTRO'
			 set @sql = 'select @clm1=Edad60,@clm2=Edad4060,@clm3=Edad1839,@clm4=Edad18  from openquery ('+@servidor+ ', ''select count(*) as "Edad60" from ' + @nom_bd + '.' + @nom_tabla +' where ce_entidad_res=ce_entidad_um and edad>60 and fecha_defuncion!='+ @FechaDef+'and c_clasificacion_final in (1,2,3)''),
			  openquery ('+@servidor+ ', ''select count(*) as "Edad4060" from ' + @nom_bd + '.' + @nom_tabla +' where ce_entidad_res=ce_entidad_um and edad between 40 and 60 and  fecha_defuncion!='+ @FechaDef+'and c_clasificacion_final in (1,2,3)''),
			  openquery ('+@servidor+ ', ''select count(*) as "Edad1839" from ' + @nom_bd + '.' + @nom_tabla +' where ce_entidad_res=ce_entidad_um and edad between 18 and 39 and  fecha_defuncion!='+ @FechaDef+'and c_clasificacion_final in (1,2,3)''),
			  openquery ('+@servidor+ ', ''select count(*) as "Edad18" from ' + @nom_bd + '.' + @nom_tabla +' where ce_entidad_res=ce_entidad_um and edad<18 and  fecha_defuncion!='+ @FechaDef+'and c_clasificacion_final in (1,2,3)'')'
		  else
			 set @sql = 'select  @clm1=Edad60,@clm2=Edad4060,@clm3=Edad1839,@clm4=Edad18 from(
			 select  count(*) "Edad60",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where ce_entidad_res=ce_entidad_um and edad between 40 and 60 and fecha_defuncion!=''9999-99-99''and c_clasificacion_final in (1,2,3)) as "Edad4060",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where ce_entidad_res=ce_entidad_um and edad between 18 and 39 and fecha_defuncion!=''9999-99-99''and c_clasificacion_final in (1,2,3)) as "Edad1839",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where ce_entidad_res=ce_entidad_um and edad<18 and fecha_defuncion!=''9999-99-99''and c_clasificacion_final in (1,2,3)) as "Edad18"
			 from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where ce_entidad_res=ce_entidad_um and edad>60 and fecha_defuncion!=''9999-99-99''and c_clasificacion_final in (1,2,3)) as aux';

	   	   exec sys.sp_executesql @sql,N'@clm1 int OUTPUT,@clm2 int OUTPUT,@clm3 int OUTPUT,@clm4 int OUTPUT',@clm1=@clm1 OUTPUT,@clm2=@clm2 OUTPUT,@clm3=@clm3 OUTPUT,@clm4=@clm4 OUTPUT;
		   insert into @MyTable values(@nom_bd,@clm1,@clm2,@clm3,@clm4);
		   select @cont=@cont-1;
	end

	select @cont = count(*) from diccionario_dist;
   while @cont>0
   begin
	select @servidor = servidor, @nom_bd = bd, @nom_tabla= ntabla 
	from diccionario_dist where id_fragmento=@cont
	   if @servidor = 'SV_CENTRO'
			 set @sql = 'select @clm1=Edad60,@clm2=Edad4060,@clm3=Edad1839,@clm4=Edad18  from openquery ('+@servidor+ ', ''select count(*) as "Edad60" from ' + @nom_bd + '.' + @nom_tabla +' where edad>60 and fecha_defuncion!='+ @FechaDef+'and c_clasificacion_final in (1,2,3)''),
			  openquery ('+@servidor+ ', ''select count(*) as "Edad4060" from ' + @nom_bd + '.' + @nom_tabla +' where edad between 40 and 60 and  fecha_defuncion!='+ @FechaDef+'and c_clasificacion_final in (1,2,3)''),
			  openquery ('+@servidor+ ', ''select count(*) as "Edad1839" from ' + @nom_bd + '.' + @nom_tabla +' where edad between 18 and 39 and  fecha_defuncion!='+ @FechaDef+'and c_clasificacion_final in (1,2,3)''),
			  openquery ('+@servidor+ ', ''select count(*) as "Edad18" from ' + @nom_bd + '.' + @nom_tabla +' where edad<18 and  fecha_defuncion!='+ @FechaDef+'and c_clasificacion_final in (1,2,3)'')'
		  else
			 set @sql = 'select  @clm1=Edad60,@clm2=Edad4060,@clm3=Edad1839,@clm4=Edad18 from(
			 select  count(*) "Edad60",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where edad between 40 and 60 and fecha_defuncion!=''9999-99-99''and c_clasificacion_final in (1,2,3)) as "Edad4060",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where edad between 18 and 39 and fecha_defuncion!=''9999-99-99''and c_clasificacion_final in (1,2,3)) as "Edad1839",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where edad<18 and fecha_defuncion!=''9999-99-99''and c_clasificacion_final in (1,2,3)) as "Edad18"
			 from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where edad>60 and fecha_defuncion!=''9999-99-99''and c_clasificacion_final in (1,2,3)) as aux';

	   	   exec sys.sp_executesql @sql,N'@clm1 int OUTPUT,@clm2 int OUTPUT,@clm3 int OUTPUT,@clm4 int OUTPUT',@clm1=@clm1 OUTPUT,@clm2=@clm2 OUTPUT,@clm3=@clm3 OUTPUT,@clm4=@clm4 OUTPUT;
		   insert into @MyTable2 values(@nom_bd,@clm1,@clm2,@clm3,@clm4);
		   select @cont=@cont-1;
	end

	select * from @MyTable;
	select 'Nacional' as Area,sum(Mayores_a_60) as Mayores_a_60,sum(Entre_40_y_60) as Entre_40_y_60,sum(Entre_18_y_39) as Entre_18_y_39,sum(Menor_a_18) as Menor_a_18 from @MyTable2
end

exec consulta_5;
