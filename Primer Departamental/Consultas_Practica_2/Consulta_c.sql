-- 3era Consulta: Listar el total de defunciones asociadas a COVID-19 a nivel nacional, a nivel región y por ciudad/región.
use noroeste

go
alter procedure consulta_3 as
begin
  declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @sql nvarchar(1000);
  declare @sqlF1 nvarchar(4000);
  declare @sqlF2 nvarchar(4000);
  declare @sqlF3 nvarchar(4000);
  declare @cont int;
  declare @FechaDef nvarchar(15);
  declare @NoCiudad nvarchar(15);
  declare @contMax int;

  select @FechaDef='''''9999-99-99''''';
  select @NoCiudad='''''999''''';

   select @cont = count(*) from diccionario_dist;
   select @contMax = count(*) from diccionario_dist;

   while @cont>0
   begin
		select @servidor = servidor, @nom_bd = bd, @nom_tabla= ntabla 
		from diccionario_dist where id_fragmento=@cont

		if @servidor = 'SV_CENTRO'
			set @sql = 'select * from openquery('+@servidor+',''select '''''+@nom_bd+''''' as region, count(*) as Defunciones_nivel_regional from '+@nom_bd+'.'+@nom_tabla+' where ce_entidad_res=ce_entidad_um and fecha_defuncion!='+@FechaDef+' and c_clasificacion_final in (1,2,3)'')'
		else
			set @sql = 'select '''+@nom_bd+''' as region, count(*) as Defunciones_nivel_regional from '+@servidor+'.'+@nom_bd+'.dbo.'+@nom_tabla+' where ce_entidad_res=ce_entidad_um and fecha_defuncion!=''9999-99-99'' and c_clasificacion_final in (1,2,3)'

		if @cont!=@contMax
				set @sqlF2=''+@sqlF2+' union '+@sql;
		else
				set @sqlF2=''+@sql;
		select @cont = @cont - 1;

	end

	select @cont = count(*) from diccionario_dist;

   while @cont>0
   begin
	select @servidor = servidor, @nom_bd = bd, @nom_tabla= ntabla 
	from diccionario_dist where id_fragmento=@cont
	   if @servidor = 'SV_CENTRO'
			 set @sql = 'select * from openquery('+@servidor+',
						''select t2.c_entidad as Clave_entidad,municipio as Ciudad,Muertos as Defunciones_nivel_ciudad from(
						 select  c_municipio_res,ce_entidad_res, count(*) as Muertos
						 from '+@nom_bd+'.'+@nom_tabla+'
						 where ce_entidad_res=ce_entidad_um and fecha_defuncion!='+@FechaDef+' and c_municipio_res!='+@NoCiudad+' and c_clasificacion_final in (1,2,3)
						 group by c_municipio_res,ce_entidad_res) as t1
						 join '+@nom_bd+'.c_municipio as t2
						 on t1.c_municipio_res=t2.c_municipio_res
						 and t1.ce_entidad_res=t2.c_entidad;'')'
		  else
			 set @sql = 'select t2.c_entidad as Clave_entidad,municipio as Ciudad,Muertos as Defunciones_nivel_ciudad from(
						 select  c_municipio_res,ce_entidad_res, count(*) as Muertos
						 from '+@servidor+'.'+@nom_bd+'.dbo.'+@nom_tabla+'
						 where ce_entidad_res=ce_entidad_um and fecha_defuncion!=''9999-99-99'' and c_municipio_res!=''999'' and c_clasificacion_final in (1,2,3)
						 group by c_municipio_res,ce_entidad_res) as t1
						 join '+@servidor+'.'+@nom_bd+'.dbo.c_municipio as t2
						 on t1.c_municipio_res=t2.c_municipio_res
						 and t1.ce_entidad_res=t2.c_entidad'
		 if @cont!=@contMax
				set @sqlF3=''+@sqlF3+' union '+@sql;
		else
				set @sqlF3=''+@sql;
		select @cont = @cont - 1;
	end
	set @sqlF1='select sum(Defunciones_nivel_regional) as Defuciones_Nivel_Nacional from('+@sqlF2+') as nac';
		exec sys.sp_executesql @sqlF1;
		exec sys.sp_executesql @sqlF2;
		exec sys.sp_executesql @sqlF3;
end

exec consulta_3