/******************************************************************************************************************************************/
DROP PROC IF EXISTS NotificarWhastApp
GO
/******************************************************************************************************************************************/
CREATE procedure NotificarWhastApp
as
BEGIN
declare @fecha datetime = CAST(GETDATE() AS DATE)
		, @fecha_2dias datetime = CAST(DATEADD(DD,2,GETDATE()) as DATE)
		, @fecha_1dia datetime = CAST(DATEADD(DD,1,GETDATE()) as DATE)
		, @bloque varchar(32)=''
		, @id_ejecucion int=0
			
	select top 1 @bloque=bloque from parametro

	select @id_ejecucion=max(id_ejecucion) from mobile_notificacion
	select @id_ejecucion=ISNULL(@id_ejecucion,0) + 1

	drop table if exists #temp_citas
	create table #temp_citas(
	id int identity(1,1),
	id_cita int,
	id_paciente int,
	fecha_inicio datetime,
	id_sucursal int,
	sucursal varchar(64),
	confirmada int,
	fecha_confirmacion datetime,
	tipo_confirmacion varchar(32),
	paciente varchar(128),
	telefono nvarchar(30)
	)

	drop table if exists #temp_citas_unir
	create table #temp_citas_unir
	(  
	id int identity(1,1),
	id_cita int,
	id_paciente int,
	fecha_inicio datetime,
	fecha_fin datetime,
	id_sucursal int,
	sucursal varchar(64),
	confirmada int,
	fecha_confirmacion datetime,
	tipo_confirmacion varchar(32),
	id_padre int default 0,
	es_padre int,
	borrar int default 0,
	telefono nvarchar(30)
	)
	insert into #temp_citas_unir (id_cita, id_paciente, fecha_inicio, fecha_fin, id_sucursal, sucursal, confirmada, fecha_confirmacion, tipo_confirmacion,telefono)
		select id_cita, c.id_paciente, c.fecha_inicio, c.fecha_fin, c.id_sucursal, s.descripcion,
				(case when c.fecha_confirmacion is null then 0 else 1 end),
				c.fecha_confirmacion,
				c.tipo_confirmacion,
				telefono=(case when ltrim(rtrim(pa.telefono_2)) like '+%' then replace(replace(replace(replace(pa.telefono_2,' ',''),'-',''),'(',''),')','')
						else '+' + p.codigo_pais + left(replace(replace(replace(replace(replace(pa.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),p.longitud_celulares)
					end)
		from cita c
		join sucursal s on s.id_sucursal = c.id_sucursal
		join paciente pa on pa.id_paciente = c.id_paciente
		JOIN PAIS p ON p.id_pais=s.id_pais
		where c.estatus <> 'B'
		and CAST(c.fecha_inicio AS DATE) between @fecha and @fecha_2dias
		and pa.version_api in (3)
		and c.id_padre = 0
		order by c.id_cita
			
		declare @currUnirId int = 1,
				@maxUnirId int

		select @maxUnirId = max(id) from #temp_citas_unir

		while @currUnirId <= @maxUnirId
		begin
			declare @fecha_inicio_unir datetime,
					@prevUnirId int,
					@currIdPaciente int,
					@currIdSucursal int

			select @fecha_inicio_unir = fecha_inicio, @currIdPaciente=id_paciente, @currIdSucursal=id_sucursal from #temp_citas_unir where id = @currUnirId
			select top 1 @prevUnirId = id from #temp_citas_unir where id < @currUnirId and borrar = 0 order by id desc

			if exists(select 1 from #temp_citas_unir where fecha_fin = @fecha_inicio_unir and id = isNull(@prevUnirId,0) and id_paciente=isnull(@currIdPaciente,0) and id_sucursal=isnull(@currIdSucursal,0))
				begin
					update #temp_citas_unir set
						fecha_fin = (select fecha_fin from #temp_citas_unir tc2 where tc2.id = @currUnirId),
						es_padre=1
					where id = isNull(@prevUnirId,0)

					update #temp_citas_unir set
						borrar = 1,
						id_padre = isNull(@prevUnirId,0)
					where id = @currUnirId
				end

			select @currUnirId = @currUnirId + 1
		end
		
		insert into #temp_citas (id_cita, id_paciente, fecha_inicio, id_sucursal, sucursal, confirmada, fecha_confirmacion, tipo_confirmacion, paciente,telefono)
							select id_cita, id_paciente, fecha_inicio, id_sucursal, sucursal, confirmada, fecha_confirmacion, tipo_confirmacion, dbo.fn_paciente_primer_nombre(id_paciente),telefono
							from #temp_citas_unir
							where borrar=0
							
	drop table if exists  #TABLA_NOTIFI_WHATSAPP_temp

	--SELECT *,dateadd(MI,1,fecha_inicio ) envio_confirmar ,dateadd(MI,2,fecha_inicio) envio_recordatorio1,dateadd(MI,3,fecha_inicio) envio_recordatorio2,0 enviado,0 recordado1,0 recordado2,GETDATE() HORA_EJECUCION INTO #TABLA_NOTIFI_WHATSAPP_temp FROM #temp_citas
	 SELECT *,(fecha_inicio -2) envio_confirmar,(fecha_inicio -1) envio_recordatorio1,dateadd(hh,-3,fecha_inicio ) envio_recordatorio2,0 enviado,0 recordado1,0 recordado2, GETDATE() HORA_EJECUCION INTO #TABLA_NOTIFI_WHATSAPP_temp  FROM #temp_citas
	---------------------------------------------------------------------------------------------------------------------------------------------------------
	--	BORRAMOS LOS REGISTROS REPETIDOS
	---------------------------------------------------------------------------------------------------------------------------------------------------------
	--OBTENEMOS TODOS LOS id_paciente QUE SE REPITEN PARA LUEGO ELIMINAR LOS QUE TIENGAN MAYOR fecha_inicio
		drop table if exists  #tablita

		select 
		id
		,id_paciente
		,fecha_inicio
		, min(fecha_inicio) over(PARTITION by fecha_inicio order by fecha_inicio desc ) orden  
		into #tablita 
		from #TABLA_NOTIFI_WHATSAPP_temp 
		where 
		id_paciente in
		(
				select 
				id_paciente 
				--,count(*)
				from #TABLA_NOTIFI_WHATSAPP_temp
		
				group by id_paciente

				having count(*)>1
		)   
		order by id_paciente, fecha_inicio
	--LA COLUMNA orden INDICA LA CANTIDAD DE VECES QUE SE ESTÁ REPITIENDO ESTE REGISTRO, POR TAL MOTIVO GUARDAMOS  TODOS LOS QUE TENGAN orden >1, PARA QUEDARNOS SOLO CON UN REGISTRO
		drop table if exists  #tablita1
		select   ROW_NUMBER()  over(PARTITION by id_paciente ORDER BY (select null))  as orden
		,id
		,id_paciente
		,fecha_inicio 
		into 
		#tablita1 from #tablita 

	-- ELIMINAMOS DE LA TABLA TODOS LOS REGISTROS REPETIDOS, QUE SON LOS QUUE ANTERIORMENTE TENIAN orden >1
		delete from #TABLA_NOTIFI_WHATSAPP_temp where id in(select id from #tablita1 where orden>1)
	---------------------------------------------------------------------------------------------------------------------------------------------------------
	--	FIN DEL PROCESO BORRAR LOS REGISTROS REPETIDOS
	---------------------------------------------------------------------------------------------------------------------------------------------------------

	/*
		INSERTAMOS LOS VALORES SIN REPETIR EN LA TABLA
		===============================================
		- Como este procesos va ejecutarse cada minuto, los registros que son guardados en la tabla temporal #TABLA_NOTIFI_WHATSAPP_temp, 
		deben ser comparados con la tabla física TABLA_NOTIFI_WHATSAPP, y luego, insertar a la tabla física TABLA_NOTIFI_WHATSAPP, solo los valores que NO SE REPITEN.

		- Para esta evaluación nos basamos en la columna HORA_EJECUCION de la tabla TABLA_NOTIFI_WHATSAPP
	*/ 

		DECLARE @HORA_EJECUCION DATETIME=(SELECT MAX(HORA_EJECUCION) FROM TABLA_NOTIFI_WHATSAPP)
		DECLARE @HORA_CADENA VARCHAR(16)=substring( convert(varchar(100),@HORA_EJECUCION,21 ),1,16)
		SET @HORA_EJECUCION =CONVERT(DATETIME,@HORA_CADENA,21)

		DECLARE @HORA_EVALUAR DATETIME=CONVERT(DATETIME,(substring( convert(varchar(100),GETDATE(),21 ),1,16)),21)
		--SELECT  @HORA_EVALUAR hora_evalua ,@HORA_EJECUCION HORA_EJECUCION
        DROP TABLE IF EXISTS #NUEVA_TABLA
        SELECT TOP 1 * INTO #NUEVA_TABLA FROM TABLA_NOTIFI_WHATSAPP
        DELETE FROM #NUEVA_TABLA

		IF(@HORA_EVALUAR>=@HORA_EJECUCION)
		BEGIN
			--insert into TABLA_NOTIFI_WHATSAPP
			INSERT INTO #NUEVA_TABLA
			select * from  #TABLA_NOTIFI_WHATSAPP_temp 
			WHERE id_cita not IN
			(
			select tt.id_cita from  #TABLA_NOTIFI_WHATSAPP_temp tt
			inner join TABLA_NOTIFI_WHATSAPP t on t.id_cita=tt.id_cita
			group by tt.id_cita
			)
		END

		IF(@HORA_EJECUCION is null)
		BEGIN
			-- insert into TABLA_NOTIFI_WHATSAPP   
            INSERT INTO #NUEVA_TABLA
			select * from  #TABLA_NOTIFI_WHATSAPP_temp 
		END
	---------------------------------------------------------------------------------------------------------------------------------------------------------  
	/*
		REGLAS:
		Mensaje 1. Confirmación de cita 2 días antes de la cita (48hrs. antes de la cita)
		Mensaje 2. Recordatorio 24 horas antes de la cita1
		Mensaje 3. Recordatorio 3 horas antes de la cita
	*/

	-- update TABLA_NOTIFI_WHATSAPP set 
    update #NUEVA_TABLA set 
	envio_confirmar		=CONVERT(DATETIME,substring( convert(varchar(100),envio_confirmar,21 ),1,16),21)
	,envio_recordatorio1=CONVERT(DATETIME,substring( convert(varchar(100),envio_recordatorio1,21 ),1,16),21)
	,envio_recordatorio2=CONVERT(DATETIME,substring( convert(varchar(100),envio_recordatorio2,21 ),1,16),21)
	,HORA_EJECUCION		=CONVERT(DATETIME,substring( convert(varchar(100),HORA_EJECUCION,21 ),1,16),21)
--========================================================================================================================================================================================
/*
	CASO 1: Cuando la cita es para HOY:
			-	CONFIRMACIÓN:	5 Minutos después de haberse creado la cita
			-	RECORDATORIO1:	2 Hora antes de la cita
			-	RECORDATORIO2:	30 minutos antes de la cita
	CASO 2:	Cuando la cita es para MAÑANA:
			-	CONFIRMACIÓN:	5 Minutos después de haberse creado la cita
			-	RECORDATORIO1:	2 Hora antes de la cita
			-	RECORDATORIO2:	30 minutos antes de la cita
	CASO 3: Cuando la cita es para PASADO MAÑANA
			-	CONFIRMACIÓN:	5 Minutos después de haberse creado la cita
			-	RECORDATORIO1:	24 Hora antes de la cita
			-	RECORDATORIO2:	3 horas antes de la cita
*/
--==========================================================================================================================================================================================
---Consideramos la columna HORA_EJECUCION de la tabla TABLA_NOTIFI_WHATSAPP, como la fecha de creación de la cita.(comparar con la columna FECHA_ALTA de la tabla CITA)
--CASO 1:
	DECLARE @FECHA_INICIO DATE=CAST(@HORA_EJECUCION AS DATE)
	SELECT GETDATE()
	SELECT CONVERT(DATETIME,GETDATE())
	UPDATE T SET 
	T.envio_confirmar=DATEADD(MINUTE,5, T.HORA_EJECUCION)
	,T.envio_recordatorio1=DATEADD(HOUR,-2, T.fecha_inicio)
	,T.envio_recordatorio2=DATEADD(MINUTE,-30, T.fecha_inicio)
    -- from TABLA_NOTIFI_WHATSAPP  T
	   from #NUEVA_TABLA  T
	WHERE CAST(T.fecha_inicio AS DATE)=@FECHA_INICIO 
--CASO 2:
	UPDATE T SET 
	T.envio_confirmar=DATEADD(MINUTE,5, T.HORA_EJECUCION)
	,T.envio_recordatorio1=DATEADD(HOUR,-2, T.fecha_inicio)
	,T.envio_recordatorio2=DATEADD(MINUTE,-30, T.fecha_inicio)
	--    from TABLA_NOTIFI_WHATSAPP  T
    from #NUEVA_TABLA  T
	WHERE CAST(T.fecha_inicio AS DATE)=DATEADD(DAY,1,@FECHA_INICIO )
--CASO 3:
	UPDATE T SET 
	T.envio_confirmar=DATEADD(MINUTE,5, T.HORA_EJECUCION)
	,T.envio_recordatorio1=DATEADD(HOUR,-24, T.fecha_inicio)
	,T.envio_recordatorio2=DATEADD(HOUR,-3, T.fecha_inicio)
	--    from TABLA_NOTIFI_WHATSAPP  T
    from #NUEVA_TABLA  T
	WHERE CAST(T.fecha_inicio AS DATE)=DATEADD(DAY,2,@FECHA_INICIO )

--==========================================================================================================================================================================================
-- Los mensajes que estan programados para ser enviados en horarios fuera del rango de Envio de Notificaciones (tabla rm_europiel_requerimientos.CONFIGURACIONES_MENSAJES_TWILIO) 
-- que normalmente es de 8am a 9pm, se enviarán MEDIA HORA antes de la cita programada. (Ver rm_europiel_requerimientos.dbo.genera_notifier_mensajes_bienvenida_cliente)
-- recordatorios: Menores de las 9am se enviarán a las 8:30 am
-- Obtenemos todos los registos que tengan una hora de envio que no esté en el rango de envíos (tabla rm_europiel_requerimientos.CONFIGURACIONES_MENSAJES_TWILIO)
-- y actualizamos su hora a MEDIA HORA antes para que pueda ser considerado el envío
--==========================================================================================================================================================================================
declare @hora_inicio TIME =(select HoraIncioEnvio from rm_europiel_requerimientos.dbo.CONFIGURACIONES_MENSAJES_TWILIO  where id=1)
declare @dia_hora_inicio DATETIME=( DATEADD(HOUR,DATEPART(hour,@hora_inicio), cast(@FECHA_INICIO as datetime)))

--==========================================================================================================================================================================================

update  #NUEVA_TABLA set  envio_confirmar=@dia_hora_inicio
where 
(
    cast(envio_confirmar as time) <= @hora_inicio 
) 
-- update  TABLA_NOTIFI_WHATSAPP set  envio_recordatorio2=DATEADD(MINUTE,-30,fecha_inicio) 
update  #NUEVA_TABLA set  envio_recordatorio2=DATEADD(MINUTE,-30,fecha_inicio) 
where 
(
    cast(envio_recordatorio2 as time) <= @hora_inicio 
)
--==========================================================================================================================================================================================
INSERT INTO TABLA_NOTIFI_WHATSAPP
SELECT * FROM #NUEVA_TABLA
/*********************************************************************************************************
POR ALGUN MOTIVO, LA TABLA_NOTIFI_WHATSAPP LLENA CITAS QUE NO EXISTEN EN LA TABLA CITA
- PUEDE SER QUE DESPUES DE HABERCE CREADO LA CITA, LO CANCELEN Y CREEN UNA NUEVA CITA CON UN NUEVO HORARIO
	Para evitar estos duplicados, se realizará una validacion en la tabla CITA, y las citas que no esten en la tabla CITA
	serán eliminadas de la tabla TABLA_NOTIFI_WHATSAPP
***********************************************************************************************************/

drop table if exists #citas_duplicadas
drop table if exists #TABLA_PACIENTES_CON_CITA_DUPLCIADA


	--obtenenmos todas los pacientes con citas duplicadas
SELECT id_paciente,count(*) num  INTO #TABLA_PACIENTES_CON_CITA_DUPLCIADA from TABLA_NOTIFI_WHATSAPP group by id_paciente having count(*)>1-- order by id_paciente desc
	

--OBTENGO TODAS LAS CITAS DUPLICADAS DE LOS PACIENTES Y LAS GUARDO EN UNA TABLA TEMPORAL #citas_duplicadas
SELECT m.* into #citas_duplicadas FROM TABLA_NOTIFI_WHATSAPP m
right join #TABLA_PACIENTES_CON_CITA_DUPLCIADA p on p.id_paciente=m.id_paciente

select * from #citas_duplicadas
--borramos de las citas que existen en la tabla cita
--para dejar solo las que no existen y luego borrarlas de la tabla TABLA_NOTIFI_WHATSAPP
delete from #citas_duplicadas where id_cita   in
(
	--estas son las sitas que si existen en la tabla cita
	select c.id_cita from CITA C
	inner join #citas_duplicadas cd on c.id_cita=cd.id_cita
	and c.estatus <> 'B'
)
--FINALMENTE BORRO DE LA TABLA TABLA_NOTIFI_WHATSAPP , LAS CITAS QUE NO EXISTEN EN LA TABLA CITA
delete from TABLA_NOTIFI_WHATSAPP where id_cita in
(
select id_cita from #citas_duplicadas
)
--------------------------------------------------------------------------------------------------------------
--									FIN DEL BORRADO DE DUPLICADOS
--------------------------------------------------------------------------------------------------------------
	declare @TABLA_ENVIOS TypePacienteWhatsapp
	--SELECT substring( convert(varchar(100),GETDATE(),21 ),1,16)

	drop table if exists  #TABLA_ENVIOS
	CREATE TABLE #TABLA_ENVIOS
	(
		id_paciente int
		,mensaje varchar(max)
	)
	declare @fecha_hora datetime= CONVERT(DATETIME,substring( convert(varchar(100),GETDATE(),21 ),1,16),21)
	insert into @TABLA_ENVIOS
	----------------------------------------------------------------------------------
	--MENSAJE 1:Confirmación de cita 2 días antes de la cita (48hrs. antes de la cita)
	----------------------------------------------------------------------------------
	select c.id_paciente,
				mensaje='Hola!, tu cita para depilarte se aproxima , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
						'a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
						'10 minutos antes, para evitar contratiempos. *Recuerda* que no puedes traer desodorante maquillaje cremas '+
						'loción ni ninguna sustancia ni químico en la piel. Así mismo debes venir rasurado(a) con rastrillo el mismo día de tu cita.'+
						'\n\nPara confirmar su cita pulse aquí http://citas.europiel.com.mx/ConfirmarCita.aspx?c=' + convert(varchar(16),c.id_cita) + '&p=' + convert(varchar(16),c.id_paciente) + '&b=' + @bloque + ' escribe OK para activar el link' 
				
		from TABLA_NOTIFI_WHATSAPP c	
		where c.envio_confirmar =@fecha_hora
		and c.enviado=0

	union
	----------------------------------------------------------------------------------
	--MENSAJE 2:Recordatorio de cita 1 día antes de la cita (24hrs. antes de la cita)
	----------------------------------------------------------------------------------
	select c.id_paciente,
				mensaje='Hola!, tu cita para depilarte se aproxima , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
						'alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
						'10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje ' +
						'cremas loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
		from TABLA_NOTIFI_WHATSAPP c	
		where  c.envio_recordatorio1  =  @fecha_hora 
		and c.recordado1=0
	union
	----------------------------------------------------------------------------------
	--MENSAJE 3:Recordatorio de cita 3 horas antes de la cita (3hrs. antes de la cita)
	----------------------------------------------------------------------------------
	select c.id_paciente,
				mensaje='Hola!, tu cita para depilarte se aproxima , el dia de hoy alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. ' +
						'Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ' +
						'ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
		from TABLA_NOTIFI_WHATSAPP c	
		where  c.envio_recordatorio2  =  @fecha_hora 
		and c.recordado2=0

	-------------------------------------------------------------------------
    PRINT 'PASO 1'
	--actualizamos los valores
	update TABLA_NOTIFI_WHATSAPP set enviado=1
		where envio_confirmar =@fecha_hora
		and enviado=0

	update TABLA_NOTIFI_WHATSAPP set recordado1=1
		where envio_recordatorio1 =@fecha_hora
		and recordado1=0

	update TABLA_NOTIFI_WHATSAPP set recordado2=1
		where envio_recordatorio2 =@fecha_hora
		and recordado2=0
        PRINT 'PASO 2'
	------------------------------------------------------------------------
	-- insert into #TABLA_ENVIOS
	-- select id_paciente,mensaje from @TABLA_ENVIOS
	--exec envia_whatsapp_cliente_test @tablaPacientes=@TABLA_ENVIOS --PARA PREUBAS
	exec envia_whatsapp_cliente @tablaPacientes=@TABLA_ENVIOS -- PARA PRODUCCION
	-----------------------------------------------------------------------
END

