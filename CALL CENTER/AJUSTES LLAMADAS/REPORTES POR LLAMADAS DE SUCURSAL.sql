
	DECLARE @TIPO_REPORTE INT=NULL
	DECLARE @FECHA_ACTUAL DATE=NULL

	declare @id_paciente int
	declare @fecha datetime
	drop table if exists #tabla_final
		create table #tabla_final
		(
			id_paciente int
			,observaciones nvarchar(max)
			,bloque varchar(5)
			,id_tipo_reporte int
			,fecha_registro datetime
			,Sucursal nvarchar(100)
			,NombreCliente nvarchar(100)
			,Agente nvarchar(50)
			,id_sucursal int
			,NombreAgente nvarchar(max)
			

		)

	IF @FECHA_ACTUAL IS NULL
	BEGIN
			SET @FECHA_ACTUAL  = GETDATE()
	END


	IF @TIPO_REPORTE IS NULL
	BEGIN
		drop table if exists #tabla
		select  b.id_paciente,observaciones,b.bloque,b.id_tipo_reporte,b.fecha_registro,t.Sucursal,t.NombreCliente,t.Agente,t.IdSucursal into #tabla from bitacora_callcenter b
		inner join LLAMADAS_TWILIO t on t.ClienteId=b.id_cliente_callcenter and b.bloque=t.Bloque
		where 
		(cast(b.fecha_registro as date) between '20210801' and  '20210831')
		--and b.id_tipo_reporte=26
		and b.id_sucursal=20 and b.bloque='SIN3'
		group by b.id_paciente,observaciones,b.bloque,b.id_tipo_reporte,b.fecha_registro,t.Sucursal,t.NombreCliente,t.Agente,t.IdSucursal
		order by b.id_paciente desc

		insert into #tabla_final
		select *,(SELECT AGENTE FROM dbo.fn_Obtener_Agente_Twilio(agente)) NombreAgente  from #tabla where agente is not null

		-----------------------------------------------------------------------------------------------------------------------------------------
		--TODO ESTO ES PARA QUITAR LOS DUPLICADOS
		-----------------------------------------------------------------------------------------------------------------------------------------
		drop table if exists #tabla_duplicados
		select * into #tabla_duplicados from #tabla_final--TABLA DONDE SE GUARDARÁN LOS DUPLICADOS
		delete from #tabla_duplicados

		drop table if exists #tabla_nombre
		select * into #tabla_nombre from #tabla_final

		DECLARE CUR CURSOR
		FOR 
					select id_paciente,fecha_registro  from #tabla_final group by id_paciente,fecha_registro having count(*)>1--obtenemos todos los duplicados
		OPEN CUR
			FETCH NEXT FROM CUR INTO @id_paciente,@fecha 
		WHILE @@FETCH_STATUS=0
		BEGIN
			IF NOT EXISTS(SELECT * FROM #tabla_duplicados WHERE id_paciente=@id_paciente AND fecha_registro=@fecha)
			
			BEGIN
				INSERT INTO #tabla_duplicados
				SELECT TOP 1 * FROM #tabla_final WHERE id_paciente=@id_paciente AND fecha_registro=@fecha--solo registramos un valor

				DELETE FROM #tabla_final WHERE id_paciente=@id_paciente AND fecha_registro=@fecha--luego de registrar el valor, nos encargamos de borrar todos los registros de la tabla
			END
		FETCH NEXT FROM CUR INTO @id_paciente,@fecha 
		END
	CLOSE CUR
	DEALLOCATE CUR

	
	INSERT INTO #tabla_final --a la tabla principal, ya no le quedan los registros que tenían duplicados, por eso le agregaremos los registros que guardamos en la tabla #tabla_duplicados
	SELECT * FROM #tabla_duplicados
	-----------------------------------------------------------------------------------------------------------------------------------------
	--CON ESTO OBTENEMOS TODOS LOS AGENTES QUE ESCRIBIERON ALGUNA OBSERVACION Y LOS CONCATENAMOS EN UN SOLO VALOR (NombreAgente)
	-----------------------------------------------------------------------------------------------------------------------------------------
	update #tabla_final set NombreAgente=null
		DECLARE CUR1 CURSOR
			FOR 
				select id_paciente,fecha_registro  from #tabla_nombre  --where agente is not null
				OPEN CUR1
					FETCH NEXT FROM CUR1 INTO @id_paciente,@fecha 
				WHILE @@FETCH_STATUS=0
				BEGIN

					declare @valor nvarchar(max)
						declare @item varchar(100)=(select top 1 NombreAgente from #tabla_nombre where id_paciente=@id_paciente AND fecha_registro=@fecha)
						if(select NombreAgente from #tabla_final where  id_paciente=@id_paciente AND fecha_registro=@fecha) is null
						begin
							set @valor=null
						end
						set @valor=concat(@valor,',',@item)
						delete from #tabla_nombre where id_paciente=@id_paciente and fecha_registro=@fecha and NombreAgente=@item

						print concat('Valor: ', substring(@valor,2,len (@valor)))
					update #tabla_final set NombreAgente=substring(@valor,2,len (@valor)) where id_paciente=@id_paciente AND fecha_registro=@fecha

				FETCH NEXT FROM CUR1 INTO @id_paciente,@fecha 
				END
			CLOSE CUR1
		DEALLOCATE CUR1
	SELECT * FROM #tabla_final
	END

	ELSE

	BEGIN
		drop table if exists #tabla2
		select  b.id_paciente,observaciones,b.bloque,b.id_tipo_reporte,b.fecha_registro,t.Sucursal,t.NombreCliente,t.Agente,t.IdSucursal into #tabla2 from bitacora_callcenter b
		inner join LLAMADAS_TWILIO t on t.ClienteId=b.id_cliente_callcenter and b.bloque=t.Bloque
		where 
		cast(b.fecha_registro as date)=@FECHA_ACTUAL
		and b.id_tipo_reporte=@TIPO_REPORTE
		group by b.id_paciente,observaciones,b.bloque,b.id_tipo_reporte,b.fecha_registro,t.Sucursal,t.NombreCliente,t.Agente,t.IdSucursal
		order by b.id_paciente desc

		
		insert into #tabla_final
		select *,(SELECT AGENTE FROM dbo.fn_Obtener_Agente_Twilio(agente)) NombreAgente  from #tabla2 where agente is not null

	--	-----------------------------------------------------------------------------------------------------------------------------------------
	--	--TODO ESTO ES PARA QUITAR LOS DUPLICADOS
	--	-----------------------------------------------------------------------------------------------------------------------------------------
		drop table if exists #tabla_duplicados1
		select * into #tabla_duplicados1 from #tabla_final--TABLA DONDE SE GUARDARÁN LOS DUPLICADOS
		delete from #tabla_duplicados1
		


		drop table if exists #tabla_nombre1
		select * into #tabla_nombre1 from #tabla_final

		DECLARE CUR CURSOR
		FOR 
			select id_paciente,fecha_registro  from #tabla_final group by id_paciente,fecha_registro having count(*)>1--obtenemos todos los duplicados
			OPEN CUR
				FETCH NEXT FROM CUR INTO @id_paciente,@fecha 
			WHILE @@FETCH_STATUS=0
			BEGIN
				IF NOT EXISTS(SELECT * FROM #tabla_duplicados1 WHERE id_paciente=@id_paciente AND fecha_registro=@fecha)
			
				BEGIN
					INSERT INTO #tabla_duplicados1
					SELECT TOP 1 * FROM #tabla_final WHERE id_paciente=@id_paciente AND fecha_registro=@fecha--solo registramos un valor

					DELETE FROM #tabla_final WHERE id_paciente=@id_paciente AND fecha_registro=@fecha--luego de registrar el valor, nos encargamos de borrar todos los registros de la tabla
				END
			FETCH NEXT FROM CUR INTO @id_paciente,@fecha 
			END
			CLOSE CUR
		DEALLOCATE CUR

	
	INSERT INTO #tabla_final --a la tabla principal, ya no le quedan los registros que tenían duplicados, por eso le agregaremos los registros que guardamos en la tabla #tabla_duplicados1
	SELECT * FROM #tabla_duplicados1
	-----------------------------------------------------------------------------------------------------------------------------------------
	--CON ESTO OBTENEMOS TODOS LOS AGENTES QUE ESCRIBIERON ALGUNA OBSERVACION Y LOS CONCATENAMOS EN UN SOLO VALOR (NombreAgente)
	-----------------------------------------------------------------------------------------------------------------------------------------
	update #tabla_final set NombreAgente=null
		DECLARE CUR1 CURSOR
			FOR 
				select id_paciente,fecha_registro  from #tabla_nombre1  --where agente is not null
				OPEN CUR1
					FETCH NEXT FROM CUR1 INTO @id_paciente,@fecha 
				WHILE @@FETCH_STATUS=0
				BEGIN

					declare @valor1 nvarchar(max)
						declare @item1 varchar(100)=(select top 1 NombreAgente from #tabla_nombre1 where id_paciente=@id_paciente AND fecha_registro=@fecha)
						if(select NombreAgente from #tabla_final where  id_paciente=@id_paciente AND fecha_registro=@fecha) is null
						begin
							set @valor1=null
						end
						set @valor1=concat(@valor1,',',@item1)
						delete from #tabla_nombre1 where id_paciente=@id_paciente and fecha_registro=@fecha and NombreAgente=@item1

						print concat('Valor: ', substring(@valor1,2,len (@valor1)))
					update #tabla_final set NombreAgente=substring(@valor1,2,len (@valor1)) where id_paciente=@id_paciente AND fecha_registro=@fecha

				FETCH NEXT FROM CUR1 INTO @id_paciente,@fecha 
				END
			CLOSE CUR1
		DEALLOCATE CUR1


	select * from #tabla_final order by fecha_registro desc

	

	SELECT  id_tipo_reporte, COUNT(*) FROM #tabla_final  
	where cast(fecha_registro as date) =cast(GETDATE() as date)
	group by id_tipo_reporte

	SELECT id_tipo_reporte, COUNT(*) FROM #tabla_final  
	where cast(fecha_registro as date) between '20210822' and '20210828'
	group by id_tipo_reporte

	SELECT id_tipo_reporte, COUNT(*) FROM #tabla_final  
	group by id_tipo_reporte
END
	-----------------------------------------------------------------------------------------------------------------------------