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
 paciente varchar(128)
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
 borrar int default 0
)
insert into #temp_citas_unir (id_cita, id_paciente, fecha_inicio, fecha_fin, id_sucursal, sucursal, confirmada, fecha_confirmacion, tipo_confirmacion)
	select id_cita, c.id_paciente, c.fecha_inicio, c.fecha_fin, c.id_sucursal, s.descripcion,
			(case when c.fecha_confirmacion is null then 0 else 1 end),
			c.fecha_confirmacion,
			c.tipo_confirmacion
	from cita c
	join sucursal s on s.id_sucursal = c.id_sucursal
	join paciente pa on pa.id_paciente = c.id_paciente
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
	 
	 insert into #temp_citas (id_cita, id_paciente, fecha_inicio, id_sucursal, sucursal, confirmada, fecha_confirmacion, tipo_confirmacion, paciente)
						 select id_cita, id_paciente, fecha_inicio, id_sucursal, sucursal, confirmada, fecha_confirmacion, tipo_confirmacion, dbo.fn_paciente_primer_nombre(id_paciente)
						 from #temp_citas_unir
						 where borrar=0
						 
--select * from #temp_citas

-- DROP TABLE IF EXISTS TABLA_NOTIFI_TEST
-- CREATE TABLE TABLA_NOTIFI_TEST
-- (	id INT
-- 	,id_cita int
-- 	,id_paciente int
-- 	,fecha_inicio datetime
-- 	,id_sucursal int
-- 	,sucursal varchar(100)
-- 	,confirmada int
-- 	,fecha_confirmacion datetime
-- 	,tipo_confirmacion varchar(20)
-- 	,paciente varchar(50)
-- 	,envio_confirmar datetime --48 HORAS ANTES
-- 	,envio_recordatorio1 datetime--24 HORAS ANTES
-- 	,envio_recordatorio2 datetime--3 HORAS ANTES
-- 	,recordado1 bit
-- 	,recordado2 bit
--  ,HORA_EJECUCION DATETIME
-- )


drop table if exists  #TABLA_NOTIFI_TEST_temp

SELECT *,dateadd(MI,1,GETDATE() ) envio_confirmar ,dateadd(MI,2,GETDATE()) envio_recordatorio1,dateadd(MI,3,GETDATE()) envio_recordatorio2,0 recordado1,0 recordado2,GETDATE() HORA_EJECUCION INTO #TABLA_NOTIFI_TEST_temp FROM #temp_citas
--SELECT *,fecha_inicio -2 ,fecha_inicio -1,dateadd(hh,-3,fecha_inicio ),0,0 FROM #temp_citas
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
	from #TABLA_NOTIFI_TEST_temp 
	where 
	id_paciente in
	(
			select 
			id_paciente 
			--,count(*)
			from #TABLA_NOTIFI_TEST_temp
	
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
	delete from #TABLA_NOTIFI_TEST_temp where id in(select id from #tablita1 where orden>1)
--INSERTAMOS LOS VALORES SIN REPETIR EN LA TABLA
    
    DECLARE @HORA_EJECUCION DATETIME=(SELECT MAX(HORA_EJECUCION) FROM TABLA_NOTIFI_TEST)
    DECLARE @HORA_CADENA VARCHAR(16)=substring( convert(varchar(100),@HORA_EJECUCION,21 ),1,16)
    SET @HORA_EJECUCION =CONVERT(DATETIME,@HORA_CADENA,21)

    DECLARE @HORA_EVALUAR DATETIME=CONVERT(DATETIME,(substring( convert(varchar(100),GETDATE(),21 ),1,16)),21)
    SELECT  @HORA_EVALUAR ,@HORA_EJECUCION

    IF(@HORA_EVALUAR>=@HORA_EJECUCION)
    BEGIN
        insert into TABLA_NOTIFI_TEST
        
        select * from  #TABLA_NOTIFI_TEST_temp 
        WHERE id_cita IN
        (
        select t.id_cita  from  #TABLA_NOTIFI_TEST_temp tt
        inner join TABLA_NOTIFI_TEST t on t.id_cita=tt.id_cita
        group by t.id_cita
        having count(*)=1
        --order by t.id_cita desc 
        )
    END
    ELSE 
    BEGIN
        insert into TABLA_NOTIFI_TEST   
        select * from  #TABLA_NOTIFI_TEST_temp 
    END
   
---------------------------------------------------------------------------------------------------------------------------------------------------------
-- FIN DEL BORRADO DE REGISTROS REPETIDOS
---------------------------------------------------------------------------------------------------------------------------------------------------------
	--select id_paciente,count(*) from TABLA_NOTIFI_TEST group by id_paciente having count(*)>1 order by id_paciente desc

declare @fecha_hora datetime= getdate()
select c.id_paciente,
			mensaje='Hola1!, tu cita para depilarte se aproxima , el dia de hoy alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. ' + 
					'Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ' +
					'ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
			,c.envio_confirmar
	from TABLA_NOTIFI_TEST c	
	where substring( convert(varchar(100),c.envio_confirmar,21 ),1,16) = substring( convert(varchar(100),@fecha_hora,21 ),1,16)
	and c.confirmada=0

union

select c.id_paciente,
			mensaje='Hola2!, tu cita para depilarte se aproxima , el dia de hoy alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. ' + 
					'Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ' +
					'ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
			,c.envio_recordatorio1
	from TABLA_NOTIFI_TEST c	
	where substring( convert(varchar(100),c.envio_recordatorio1,21 ),1,16) = substring( convert(varchar(100),@fecha_hora,21 ),1,16)
	and c.recordado1=0
union
select c.id_paciente,
			mensaje='Hola3!, tu cita para depilarte se aproxima , el dia de hoy alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. ' + 
					'Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ' +
					'ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
			,c.envio_recordatorio2
	from TABLA_NOTIFI_TEST c	
	where substring( convert(varchar(100),c.envio_recordatorio2,21 ),1,16) = substring( convert(varchar(100),@fecha_hora,21 ),1,16)
	and c.recordado2=0
--select substring( convert(varchar(100),getdate(),21 ),1,16)

-- select id_paciente,count(*) from TABLA_NOTIFI_TEST group by id_paciente order by id_paciente desc
-- select * from TABLA_NOTIFI_TEST order by id_paciente desc

--truncate table TABLA_NOTIFI_TEST