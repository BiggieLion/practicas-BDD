-- 4ta consulta Determinar  si  las  tres  ciudades  por  región  con  el  mayor  número  de  casos  COVID también  corresponden  a  las  tres  ciudades  por  región  con  el  mayor  número  de defunciones asociados a casos COVID.
use noroeste

go
alter procedure consulta_4 as
begin
  declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @sql nvarchar(2000);
  declare @FechaDef nvarchar(15);
  declare @NoCiudad nvarchar(15);
  declare @cont int;

  select @FechaDef='''''9999-99-99''''';
  select @NoCiudad='''''999''''';

   select @cont = count(*) from diccionario_dist;
   while @cont>0
   begin
	select @servidor = servidor, @nom_bd = bd, @nom_tabla= ntabla 
	from diccionario_dist where id_fragmento=@cont
	   if @servidor = 'SV_CENTRO'
			 set @sql = 'select * from openquery('+@servidor+',
						''select c1.Ciudad as Ciudad_centro,c1.Contagios,c2.Muertos from(
select c_entidad as Clave_entidad,municipio as Ciudad,total as Contagios from(
						 select c_municipio_res,ce_entidad_res, count(*) as total
						 from '+@nom_bd+'.'+@nom_tabla+'
						 where ce_entidad_res=ce_entidad_um and c_clasificacion_final in (1,2,3) and c_municipio_res!='+@NoCiudad+'
						 group by c_municipio_res,ce_entidad_res
						 order by total desc LIMIT 3) as t1
						 join '+@nom_bd+'.c_municipio as t2
						 on t1.c_municipio_res=t2.c_municipio_res
						 and t1.ce_entidad_res=t2.c_entidad
) as c1 cross join (
 select t2.c_entidad as Clave_entidad,municipio as Ciudad, Muertos from(
						 select  c_municipio_res,ce_entidad_res, count(*) as Muertos
						 from '+@nom_bd+'.'+@nom_tabla+'
						 where ce_entidad_res=ce_entidad_um and fecha_defuncion!='+@FechaDef+' and c_municipio_res!='+@NoCiudad+' and c_clasificacion_final in (1,2,3)
						 group by c_municipio_res,ce_entidad_res) as t1
						 join '+@nom_bd+'.c_municipio as t2
						 on t1.c_municipio_res=t2.c_municipio_res
						 and t1.ce_entidad_res=t2.c_entidad
						 order by Muertos desc LIMIT 3
) as c2
where c1.Clave_entidad=c2.Clave_entidad
and c1.Ciudad=c2.Ciudad;'')'
		  else
			 set @sql = 'select c1.Ciudad as Ciudad_'+@nom_bd+',c1.Contagios,c2.Muertos from(

select c_entidad as Clave_entidad,municipio as Ciudad,total as Contagios from(
						 select top 3 c_municipio_res,ce_entidad_res, count(*) as total
						 from '+@servidor+'.'+@nom_bd+'.dbo.'+@nom_tabla+'
						 where ce_entidad_res=ce_entidad_um and c_clasificacion_final in (1,2,3) and c_municipio_res!=''999''
						 group by c_municipio_res,ce_entidad_res
						 order by total desc) as t1
						 join '+@servidor+'.'+@nom_bd+'.dbo.c_municipio as t2
						 on t1.c_municipio_res=t2.c_municipio_res
						 and t1.ce_entidad_res=t2.c_entidad
) as c1 cross join (
 select top 3 t2.c_entidad as Clave_entidad,municipio as Ciudad, Muertos from(
						 select  c_municipio_res,ce_entidad_res, count(*) as Muertos
						 from '+@servidor+'.'+@nom_bd+'.dbo.'+@nom_tabla+'
						 where ce_entidad_res=ce_entidad_um and fecha_defuncion!=''9999-99-99'' and c_municipio_res!=''999'' and c_clasificacion_final in (1,2,3)
						 group by c_municipio_res,ce_entidad_res) as t1
						 join '+@servidor+'.'+@nom_bd+'.dbo.c_municipio as t2
						 on t1.c_municipio_res=t2.c_municipio_res
						 and t1.ce_entidad_res=t2.c_entidad
						 order by Muertos desc
) as c2
where c1.Clave_entidad=c2.Clave_entidad
and c1.Ciudad=c2.Ciudad'


	  select @cont = @cont - 1;
	  exec sys.sp_executesql @sql;
	end
end

exec consulta_4;
