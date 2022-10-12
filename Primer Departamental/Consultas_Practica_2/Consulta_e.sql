-- 5nta Consulta: Listar por rango de edades listados en la consulta (a) el total de defunciones a nivel nacional y por región.

go
alter procedure consulta_5 as
begin
  declare @servidor nvarchar(100);
  declare @nom_bd nvarchar(100);
  declare @nom_tabla nvarchar(100);
  declare @sql nvarchar(1000);
  declare @sqlF1 nvarchar(4000);
  declare @sqlF2 nvarchar(4000);
  declare @FechaDef nvarchar(15);
  declare @cont int;
  declare @contMax int;

  select @FechaDef='''''9999-99-99''''';

   set @sqlF2='';
   select @cont = count(*) from diccionario_dist;
   select @contMax = count(*) from diccionario_dist;
   while @cont>0
   begin
	select @servidor = servidor, @nom_bd = bd, @nom_tabla= ntabla 
	from diccionario_dist where id_fragmento=@cont
	   if @servidor = 'SV_CENTRO'
			 set @sql = 'select *  from openquery ('+@servidor+ ', ''select "'+@nom_bd+'" as "region" ,count(*) as "Mayores_a_60" from ' + @nom_bd + '.' + @nom_tabla +' where ce_entidad_res=ce_entidad_um and edad>60 and fecha_defuncion!='+ @FechaDef+'''),
			  openquery ('+@servidor+ ', ''select count(*) as "Entre_40_y_60" from ' + @nom_bd + '.' + @nom_tabla +' where ce_entidad_res=ce_entidad_um and edad between 40 and 60 and  fecha_defuncion!='+ @FechaDef+'''),
			  openquery ('+@servidor+ ', ''select count(*) as "Entre_18_y_39" from ' + @nom_bd + '.' + @nom_tabla +' where ce_entidad_res=ce_entidad_um and edad between 18 and 39 and  fecha_defuncion!='+ @FechaDef+'''),
			  openquery ('+@servidor+ ', ''select count(*) as "Menor_a_18" from ' + @nom_bd + '.' + @nom_tabla +' where ce_entidad_res=ce_entidad_um and edad<18 and  fecha_defuncion!='+ @FechaDef+''')'
		  else
			 set @sql = 'select '''+@nom_bd+''' as region, count(*) as "Mayores_a_60",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where ce_entidad_res=ce_entidad_um and edad between 40 and 60 and fecha_defuncion!=''9999-99-99'') as "Entre_40_y_60",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where ce_entidad_res=ce_entidad_um and edad between 18 and 39 and fecha_defuncion!=''9999-99-99'') as "Entre_18_y_39",
			 (select count(*) from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where ce_entidad_res=ce_entidad_um and edad<18 and fecha_defuncion!=''9999-99-99'') as "Menor_a_18"
			 from ' + @servidor + '.' + @nom_bd + '.dbo.' + @nom_tabla + ' where ce_entidad_res=ce_entidad_um and edad>60 and fecha_defuncion!=''9999-99-99''';
	   if @cont!=@contMax
				set @sqlF2=''+@sqlF2+' union '+@sql;
		else
				set @sqlF2=''+@sql;
	  select @cont = @cont - 1;
	end
	set @sqlF1='select ''Nacional'' as Area ,sum(Mayores_a_60) as Mayores_a_60, sum(Entre_40_y_60) as Entre_40_y_60, sum(Entre_18_y_39) as Entre_18_y_39, sum(Menor_a_18) as Menor_a_18
				from('+@sqlF2+') as nac';
	exec sys.sp_executesql @sqlF1;
	exec sys.sp_executesql @sqlF2;
end

exec consulta_5;