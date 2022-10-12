-- 9ena Consulta: Determinar en  cuantos  casos a  nivel nacional  ypor  regióndifiere  la  entidad  de atención médica de la entidad de residencia.

go
alter procedure consulta_9 as
begin
  declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @sql nvarchar(1000);
  declare @sqlF nvarchar(4000);
  declare @sqlF2 nvarchar(4000);
  declare @cont int;
  declare @contMax int;


   set @sqlF='';
   select @cont = count(*) from diccionario_dist;
   select @contMax = count(*) from diccionario_dist;
   while @cont>0
   begin
	select @servidor = servidor, @nom_bd = bd, @nom_tabla= ntabla 
	from diccionario_dist where id_fragmento=@cont
	   if @servidor = 'SV_CENTRO'
			 set @sql = 'select * from openquery('+@servidor+',''select '''''+@nom_bd+''''' as region,ABS(Igual-Diferente) as Diferencia from(
							select count(*) as Igual from '+@nom_bd+'.'+@nom_tabla+'
							where ce_entidad_res=ce_entidad_um) as c1
							cross join (
							select count(*) as Diferente from centro.casoscovid
							where ce_entidad_res!=ce_entidad_um) as c2'')';
		  else
			 set @sql = 'select '''+@nom_bd+''' as region,ABS(Igual-Diferente) as Diferencia from(
							select count(*) as Igual from '+@servidor+'.'+@nom_bd+'.dbo.'+@nom_tabla+'
							where ce_entidad_res=ce_entidad_um) as c1
							cross join (
							select count(*) as Diferente from '+@servidor+'.'+@nom_bd+'.dbo.'+@nom_tabla+'
							where ce_entidad_res!=ce_entidad_um) as c2';
	   if @cont!=@contMax
				set @sqlF=''+@sqlF+' union '+@sql;
		else
				set @sqlF=''+@sql;
	  select @cont = @cont - 1;
	end
	set @sqlF2='select sum(Diferencia) as "Diferencia nivel nacional" from('+@sqlF+') as nac';
	exec sys.sp_executesql @sqlF;
	exec sys.sp_executesql @sqlF2;
end

exec consulta_9;
