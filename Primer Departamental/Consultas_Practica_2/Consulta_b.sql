-- 2nda consulta: Listar las  tres  ciudades  por  región con  el  mayor  número  de  casosde  COVID registrados.

use noroeste

go
alter procedure consulta_2 as
begin
  declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @sql nvarchar(1000);
  declare @cont int;

  declare @MyTable Table (Region varchar (15),Ciudad1 varchar(30),Ciudad2 varchar(30),Ciudad3 varchar(30));
  declare @clm1 varchar(30);
  declare @clm2 varchar(30);
  declare @clm3 varchar(30);

   select @cont = count(*) from diccionario_dist;
   while @cont>0
   begin
	select @servidor = servidor, @nom_bd = bd, @nom_tabla= ntabla
	from diccionario_dist where id_fragmento=@cont
	   if @servidor = 'SV_CENTRO'
			 set @sql = 'Declare  MyCursor CURSOR FOR
						select * from openquery('+@servidor+',
						''select municipio as '+@nom_bd+' from(
						select c_municipio_res,ce_entidad_res, count(*) as total
						from '+@nom_bd+'.'+@nom_tabla+'
						where ce_entidad_res=ce_entidad_um and c_clasificacion_final in (1,2,3) and c_municipio_res!=''''999''''
						group by c_municipio_res,ce_entidad_res
						order by total desc LIMIT 3) as t1
						join '+@nom_bd+'.c_municipio as t2
						on t1.c_municipio_res=t2.c_municipio_res
						and t1.ce_entidad_res=t2.c_entidad
						order by total desc;'')'
		  else
			 set @sql = 'Declare  MyCursor CURSOR FOR
						 select municipio as '+@nom_bd+' from(
						 select top 3 c_municipio_res,ce_entidad_res, count(*) as total
						 from '+@servidor+'.'+@nom_bd+'.dbo.'+@nom_tabla+'
						 where ce_entidad_res=ce_entidad_um and c_clasificacion_final in (1,2,3) and c_municipio_res!=''999''
						 group by c_municipio_res,ce_entidad_res
						 order by total desc) as t1
						 join '+@servidor+'.'+@nom_bd+'.dbo.c_municipio as t2
						 on t1.c_municipio_res=t2.c_municipio_res
						 and t1.ce_entidad_res=t2.c_entidad
						 order by total desc;'

						exec sys.sp_executesql @sql
						OPEN MyCursor
						FETCH NEXT FROM MyCursor Into @clm1;
						FETCH NEXT FROM MyCursor Into @clm2;
						FETCH NEXT FROM MyCursor Into @clm3;
						CLOSE MyCursor
						DEALLOCATE MyCursor
	  insert into @MyTable values(@nom_bd,@clm1,@clm2,@clm3);
	  select @cont = @cont - 1;
	end
	select * from @MyTable;
end

exec consulta_2;
