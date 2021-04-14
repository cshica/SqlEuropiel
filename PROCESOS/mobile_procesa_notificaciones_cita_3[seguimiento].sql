--select * from TEMPORAL_TABLE_ENVIOS where ID_PACIENTE=59966
/**********************************************************************
declare @fecha datetime = CAST(GETDATE() AS DATE), @fecha_2dias datetime = CAST(DATEADD(DD,2,GETDATE()) as DATE), @fecha_1dia datetime = CAST(DATEADD(DD,1,GETDATE()) as DATE),
		@bloque varchar(32)='', @id_ejecucion int=0
declare TABLA_PACIENTES TypePacienteWhatsapp		
select top 1 @bloque=bloque from parametro

select @id_ejecucion=max(id_ejecucion) from mobile_notificacion
select @id_ejecucion=ISNULL(@id_ejecucion,0) + 1
alter table #mobile_notificacion alter column  tipo_notificacion  nvarchar(max)
alter table #mobile_notificacion alter column  mensaje  nvarchar(max)
select * from #mobile_notificacion
*****************************************************************************/

DECLARE @tipo_ejecucion INT=2

CREATE TABLE #TABLA_PACIENTES
(
	id INT identity(1,1)
	,id_paciente INT
	,mensaje varchar(max)
	,fecha_hora_msj DATETIME
	,fecha_msj DATE
	,hora_msj time
)

/*****************************************************************************/

declare @fecha datetime = CAST(GETDATE() AS DATE), @fecha_2dias datetime = CAST(DATEADD(DD,2,GETDATE()) as DATE), @fecha_1dia datetime = CAST(DATEADD(DD,1,GETDATE()) as DATE),
		@bloque varchar(32)='', @id_ejecucion int=0
declare @tablaPacientes TypePacienteWhatsapp

select top 1 @bloque=bloque from parametro

select @id_ejecucion=max(id_ejecucion) from mobile_notificacion
select @id_ejecucion=ISNULL(@id_ejecucion,0) + 1
DROP TABLE IF EXISTS #temp_citas
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
DROP TABLE IF EXISTS #temp_paquetes
create table #temp_paquetes(
 id int identity(1,1),
 id_paquete int,
 id_paciente int,
 fecha_negrita datetime,
 dias int
)
DROP TABLE IF EXISTS #temp_dia_notificacion
create table #temp_dia_notificacion(
 id int identity(1,1),
 dia int,
 hora int
)
DROP TABLE IF EXISTS #temp_citas_unir
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


insert into #temp_dia_notificacion (dia, hora)
select 1,11
union
select 1,16
union
select 4,19
union
select 5,11
union
select 5,16
union
select 8,19
union
select 9,11
union
select 9,16
union
select 12,19
union
select 13,9
union
select 13,15
union
select 15,18
union
select 16,9
union
select 16,15
union
select 18,18
union
select 19,9
union
select 19,15
union
select 21,18


insert into #temp_paquetes (id_paquete,id_paciente,fecha_negrita, dias)
select p.id_paquete,p.id_paciente,p.fecha_negrita, datediff(dd,p.fecha_negrita,cast(floor(convert(float,GETDATE())) as datetime)) + 1
from paquete p
where p.es_negrita = 1 
and datediff(dd,p.fecha_negrita,cast(floor(convert(float,GETDATE())) as datetime)) <= 21
and p.id_paciente not in (select mn.id_usuario from mobile_notificacion mn where mn.tipo_notificacion in ('PN-1','PN-2') and mn.fecha_envio is null)
/*********************************************************************************/

if @tipo_ejecucion=0
 BEGIN
	insert into #temp_citas (id_cita, id_paciente, fecha_inicio, id_sucursal, sucursal, paciente)
	select id_cita, c.id_paciente, c.fecha_inicio, c.id_sucursal, s.descripcion, dbo.fn_paciente_primer_nombre(c.id_paciente)
	from cita c
	join sucursal s on s.id_sucursal = c.id_sucursal
	join paciente pa on pa.id_paciente = c.id_paciente
    -- HGU
    LEFT OUTER JOIN dbo.bloque b ON s.id_bloque = b.id_bloque
    LEFT OUTER JOIN rm_europiel_requerimientos.dbo.potencial_sucursales_antes_covid p ON b.abreviatura = p.bloque AND s.id_sucursal = p.id_sucursal
    -- HGU
	where c.estatus <> 'B'
	and (cast(floor(convert(float,c.fecha_inicio)) as datetime) = cast(floor(convert(float,GETDATE())) as datetime)
		or cast(floor(convert(float,c.fecha_inicio)) as datetime) = cast(floor(convert(float,dateadd(dd,1,GETDATE()))) as datetime))
	and c.id_padre = 0
	and pa.version_api in (1,2)
    -- HGU
    AND s.es_activa = 1 AND s.es_cerrada = 0 AND s.esta_aperturada = 1 AND ISNULL(p.reaperturada, 0) = 1
    -- HGU
		
 END
else
 BEGIN
	--insert into #temp_citas (id_cita, id_paciente, fecha_inicio, id_sucursal, sucursal, confirmada, fecha_confirmacion, tipo_confirmacion)
	--select id_cita, c.id_paciente, c.fecha_inicio, c.id_sucursal, s.descripcion,
	--		(case when c.fecha_confirmacion is null then 0 else 1 end),
	--		c.fecha_confirmacion,
	--		c.tipo_confirmacion
	--from cita c
	--join sucursal s on s.id_sucursal = c.id_sucursal
	--where c.estatus <> 'B'
	--and CAST(c.fecha_inicio AS DATE)=@fecha_analisis
	----and c.id_padre = 0
	--order by c.id_cita
	
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
 END
/***************************************************************************************************************/

DROP TABLE IF EXISTS #mobile_notificacion
select top 1 id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion into #mobile_notificacion from mobile_notificacion
delete from #mobile_notificacion
/*************************************NOTIFICACIONES VIEJAS*****************************************************/

if @tipo_ejecucion=0
BEGIN
	--CONFIRMACION 24HRS
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			'CC',
			'Favor de confirmar su cita del ' + CONVERT(CHAR(10),c.fecha_inicio,103) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + sucursal,
			DATEADD(HH,-24,c.fecha_inicio),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c
	where cast(floor(convert(float,c.fecha_inicio)) as datetime) = cast(floor(convert(float,dateadd(dd,1,GETDATE()))) as datetime)
	
	--RECORDATORIO 3HRS
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			'RC-3',
			'Le recordamos su cita de hoy a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal,
			DATEADD(HH,-3,c.fecha_inicio),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c
	where cast(floor(convert(float,c.fecha_inicio)) as datetime) = cast(floor(convert(float,GETDATE())) as datetime)

	--RECORDATORIO 1HR
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			'RC-1',
			'Le recordamos su cita de hoy a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal,
			DATEADD(HH,-1,c.fecha_inicio),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c
	where cast(floor(convert(float,c.fecha_inicio)) as datetime) = cast(floor(convert(float,GETDATE())) as datetime)

	--VALORACION 1DIA ANTES
	if GETDATE() > '20200731' -- Omitir valiraciones hasta el 31 de Julio
		begin


				insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
				select c.id_paciente,
						'Cliente',
						'CV-10',
						'Le recordamos que debe acudir a valoración antes de su cita del ' + CONVERT(CHAR(10),c.fecha_inicio,103) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))),
						@fecha + CAST('10:00:000' AS DATETIME),
						c.id_cita,
						@id_ejecucion
				from #temp_citas c
				where cast(floor(convert(float,c.fecha_inicio)) as datetime) = cast(floor(convert(float,dateadd(dd,1,GETDATE()))) as datetime)
				and dbo.fn_es_cita_valoracion(id_cita) = 1

				insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
				select c.id_paciente,
						'Cliente',
						'CV-12',
						'Le recordamos que debe acudir a valoración antes de su cita del ' + CONVERT(CHAR(10),c.fecha_inicio,103) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))),
						@fecha + CAST('12:00:000' AS DATETIME),
						c.id_cita,
						@id_ejecucion
				from #temp_citas c
				where cast(floor(convert(float,c.fecha_inicio)) as datetime) = cast(floor(convert(float,dateadd(dd,1,GETDATE()))) as datetime)
				and dbo.fn_es_cita_valoracion(id_cita) = 1

				insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
				select c.id_paciente,
						'Cliente',
						'CV-15',
						'Le recordamos que debe acudir a valoración antes de su cita del ' + + CONVERT(CHAR(10),c.fecha_inicio,103) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))),
						@fecha + CAST('15:00:000' AS DATETIME),
						c.id_cita,
						@id_ejecucion
				from #temp_citas c
				where cast(floor(convert(float,c.fecha_inicio)) as datetime) = cast(floor(convert(float,dateadd(dd,1,GETDATE()))) as datetime)
				and dbo.fn_es_cita_valoracion(id_cita) = 1



		end
END
/*************************************NOTIFICACIONES VIEJAS*****************************************************/


/*************************************NOTIFICACIONES NUEVAS*****************************************************/
if @tipo_ejecucion=1
BEGIN
	--RECORDATORIO DIA DE LA CITA 3 HORAS ANTES DE LA CITA
	--CITAS DESPUES DE LAS 12:00 SE NOTIFICAN A LAS 12:00					@tipo_ejecucion=2
	--CITAS ENTRE 10:00 y 12:00 SE NOTIFICAN A LAS 9:00						@tipo_ejecucion=1
	--CITAS ENTRE 08:00 y 10:00 SE NOTIFICAN UN DIA ANTES A LAS 8:00PM		@tipo_ejecucion=1
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			case when c.tipo_confirmacion='APP' then 'RC-3' else 'SMS-RC' end,
			--'Le recordamos su cita de hoy a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal,
			case 
				when c.tipo_confirmacion='APP' then 'Le recordamos su cita de hoy a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal
				 else c.paciente + ', le recordamos su cita de hoy a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en Europiel'
			end,			
			CAST(c.fecha_inicio as DATE) + CAST('09:00:000' AS DATETIME),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c	
	where c.fecha_inicio between DATEADD(HH,10,@fecha) and DATEADD(HH,12,@fecha) 
	and c.confirmada=1
	UNION
	select c.id_paciente,
			'Cliente',
			case when c.tipo_confirmacion='APP' then 'RC-3' else 'SMS-RC' end,
			--'Le recordamos su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal,
			case 
				when c.tipo_confirmacion='APP' then 'Le recordamos su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal
				 else c.paciente + ', le recordamos su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en Europiel'
			end,			
			CAST(DATEADD(DD,-1,c.fecha_inicio) as DATE) + CAST('20:00:000' AS DATETIME),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c
	where CAST(DATEADD(DD,-1,c.fecha_inicio) as DATE) = @fecha	
	and c.fecha_inicio < DATEADD(HH,10,@fecha_1dia)
	and c.confirmada=1	


	insert into #TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el dia de hoy alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. ' + 
					'Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ' +
					'ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c	
	where c.fecha_inicio between DATEADD(HH,10,@fecha) and DATEADD(HH,12,@fecha) 
	and c.confirmada=1
	UNION
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
					'alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
					'10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas ' +
					'loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c
	where CAST(DATEADD(DD,-1,c.fecha_inicio) as DATE) = @fecha	
	and c.fecha_inicio < DATEADD(HH,10,@fecha_1dia)
	and c.confirmada=1	





	
	--RECORDATORIO 2 HORAS ANTES
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			case when c.tipo_confirmacion='APP' then 'RC-2' else 'SMS-RC' end,
			--'Favor de llegar 15 minutos antes de su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))),
			case
				when c.tipo_confirmacion='APP' then 'Favor de llegar 15 minutos antes de su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8)))
				 else c.paciente + ', favor de llegar 15 min antes de su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en Europiel'
			end,
			DATEADD(hh,-2,c.fecha_inicio),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha
	and c.confirmada=1

	insert into #TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el dia de hoy alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. ' +
					'Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ' +
					'ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha
	and c.confirmada=1






	
	--RECORDATORIO 2 HORAS ANTES
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			case when c.tipo_confirmacion='APP' then 'RC-2' else 'SMS-RC' end,
			--'Si no asiste super bien rasurada(o) con rastrillo de horas antes no se le podra atender en su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1)+ ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))),
			case
				when c.tipo_confirmacion='APP' then 'Si no asiste super bien rasurada(o) con rastrillo de horas antes no se le podra atender en su cita del ' + 
														dbo.fn_fecha_dia_mes(c.fecha_inicio,1)+ ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8)))
				 else c.paciente + ', si no asiste super bien rasurada(o) con rastrillo de horas antes no se le podra atender en su cita del ' + 
						dbo.fn_fecha_dia_mes(c.fecha_inicio,1)+ ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en Europiel'
			end,			
			DATEADD(hh,-2,c.fecha_inicio),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha
	and c.confirmada=1
END
if @tipo_ejecucion=2
BEGIN	 
	--CONFIRMACION 2 DIAS ANTES 12:00
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			'CC',
			--'Favor de confirmar su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
			--		' en la sucursal ' + sucursal + ' para evitar que sea cancelada',
			'Notificacion urgente de tu cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ', da click para abrir',
			@fecha + CAST('12:00:000' AS DATETIME),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias
/**************************************************************************************************************
MODIFICADO POR CSHICA:
	1	Evita que se envíen dos mensajes 
	    - Mensaje de alerta 
	    - Mensaje con el link de confirmacion de cita
	2	Se creó una nueva plantilla en twilio con esta nueva estructura (Name Template: confirmar_cita)
**************************************************************************************************************/
	insert into #TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
					'a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
					'10 minutos antes, para evitar contratiempos. *Recuerda* que no puedes traer desodorante maquillaje cremas '+
					'loción ni ninguna sustancia ni químico en la piel. Así mismo debes venir rasurado(a) con rastrillo el mismo día de tu cita.'+
					'\n\nPara confirmar su cita pulse aquí http://citas.europiel.com.mx/ConfirmarCita.aspx?c=' + convert(varchar(16),c.id_cita) + '&p=' + convert(varchar(16),c.id_paciente) + '&b=' + @bloque + ' escribe OK para activar el link'
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias
/*************************************************************************************************************
	--VALOR ANTERIOR (antes de la modificación de arriba)
**************************************************************************************************************
	insert into TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
					'alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
					'10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas ' +
					'loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias

	
	insert into TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Para confirmar su cita pulse aquí http://citas.europiel.com.mx/ConfirmarCita.aspx?c=' + convert(varchar(16),c.id_cita) + '&p=' + convert(varchar(16),c.id_paciente) + '&b=' + @bloque + ' escribe OK para activar el link'
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias
***********************************************************************************/
	
	--RECORDATORIO 1 DIA ANTES 12:00
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			case when c.tipo_confirmacion='APP' then 'RC-1D' else 'SMS-RC' end,
			--'Le recordamos su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal,
			case 
				when c.tipo_confirmacion='APP' then 'Le recordamos su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal
				 else c.paciente + ', le recordamos su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en Europiel'
			end,			
			@fecha + CAST('12:00:000' AS DATETIME),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha_1dia
	and c.confirmada=1

	insert into #TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima tttt , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
					'alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
					'10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje ' +
					'cremas loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha_1dia
	and c.confirmada=1
	
	--RECORDATORIO DIA DE LA CITA 3 HORAS ANTES DE LA CITA
	--CITAS DESPUES DE LAS 12:00 SE NOTIFICAN A LAS 12:00					@tipo_ejecucion=2
	--CITAS ENTRE 10:00 y 12:00 SE NOTIFICAN A LAS 9:00						@tipo_ejecucion=1
	--CITAS ENTRE 08:00 y 10:00 SE NOTIFICAN UN DIA ANTES A LAS 8:00PM		@tipo_ejecucion=1
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			case when c.tipo_confirmacion='APP' then 'RC-3' else 'SMS-RC' end,
			--'Le recordamos su cita de hoy a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal,
			case 
				when c.tipo_confirmacion='APP' then 'Le recordamos su cita de hoy a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal
				 else c.paciente + ', le recordamos su cita de hoy a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en Europiel'
			end,
			CAST(c.fecha_inicio as DATE) + CAST('12:00:000' AS DATETIME),
			c.id_cita,
			@id_ejecucion
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha
	and c.confirmada=1
	and c.fecha_inicio > DATEADD(HH,12,@fecha)

	insert into #TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el dia de hoy alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. ' +
					'Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ' +
					'ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha
	and c.confirmada=1
	and c.fecha_inicio > DATEADD(HH,12,@fecha)


	if GETDATE() > '20200731' -- Omitir valiraciones hasta el 31 de Julio
		begin

	
				--RECORDATORIO VALORACION 1 DIA ANTES 12:00
				insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
				select c.id_paciente,
						'Cliente',
						case when c.tipo_confirmacion='APP' then 'CV-12' else 'SMS-RC' end,
						--'Acudir hoy a valoración a Europiel de lo contrario mañana no se le podra atender en la sucursal ' + c.sucursal,
						case
							when c.tipo_confirmacion='APP' then 'Acudir hoy a valoracion a Europiel de lo contrario mañana no se le podra atender en la sucursal ' + c.sucursal
							 else c.paciente + ', acudir hoy a valoracion a Europiel de lo contrario mañana no se le podra atender'
						end,	
						@fecha + CAST('12:00:000' AS DATETIME),
						c.id_cita,
						@id_ejecucion
				from #temp_citas c
				where CAST(c.fecha_inicio as DATE) = @fecha_1dia
				and c.confirmada=1
				and dbo.fn_es_cita_valoracion(id_cita) = 1

		end

END
if @tipo_ejecucion=3
BEGIN	 
	--CONFIRMACION 2 DIAS ANTES 15:00
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select c.id_paciente,
			'Cliente',
			'CC',
			--'Favor de confirmar su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
			--		' en la sucursal ' + sucursal + ' para evitar que sea cancelada',
			'Notificacion urgente de tu cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ', da click para abrir',
			@fecha + CAST('15:00:000' AS DATETIME),
			c.id_cita,
			@id_ejecucion	
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias



	insert into #TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
					'alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
					'10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas ' +
					'loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias

	insert into #TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Para confirmar su cita pulse aquí http://citas.europiel.com.mx/ConfirmarCita.aspx?c=' + convert(varchar(16),c.id_cita) + '&p=' + convert(varchar(16),c.id_paciente) + '&b=' + @bloque + ' escribe OK para activar el link'
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias

END
if @tipo_ejecucion=4
BEGIN	 
	--CONFIRMACION 48HRS 16:00 VIA SMS
	--insert into mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion,mensaje_v2)
	--select c.id_paciente,
	--		'Cliente',
	--		'SMS-CC',
	--		--'Favor de confirmar su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + sucursal,
	--		--c.paciente + ', para confirmar su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
	--		--				' en Europiel para evitar que sea cancelada, da clic aqui: ',
	--		c.paciente + ', notificacion urgente de tu cita en Europiel, da click para abrir: ',
	--		@fecha + CAST('16:00:000' AS DATETIME),
	--		c.id_cita,
	--		@id_ejecucion,
	--		'Hola!, tu cita para depilarte se aproxima, el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + 
	--		lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
	--		'. Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante, maquillaje, cremas, ' +
	--		'loción ni ninguna sustancia ni químico en la piel, así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	--from #temp_citas c
	--where c.confirmada=0
	--and CAST(c.fecha_inicio as DATE) = @fecha_2dias



	insert into #TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
					'alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
					'10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas ' +
					'loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias

	insert into #TABLA_PACIENTES (id_paciente, mensaje)
	select c.id_paciente,
			mensaje='Para confirmar su cita pulse aquí http://citas.europiel.com.mx/ConfirmarCita.aspx?c=' + convert(varchar(16),c.id_cita) + '&p=' + convert(varchar(16),c.id_paciente) + '&b=' + @bloque + ' escribe OK para activar el link'
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias

END

/*************************************NOTIFICACIONES NUEVAS*****************************************************/
if @tipo_ejecucion=0-- or @tipo_ejecucion=1
BEGIN
	/****************************LB20210311 Roberto solicito desactivar esta notificacion****************************/
	----AGENDAR CITA
	--insert into mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	--select p.id_paciente,
	--		'Cliente',
	--		'PN-1',
	--		'Favor de agendar cita para depilacion laser',
	--		dateadd(hh,d.hora,@fecha),
	--		null,--,d.dia 
	--		@id_ejecucion
	--from #temp_paquetes p
	--join #temp_dia_notificacion d on d.dia = p.dias		
	--where p.dias <= 12
	/****************************LB20210311 Roberto solicito desactivar esta notificacion****************************/
	
	/****************************AJAL20210317 Roberto solicito desactivar esta notificacion****************************/
	----AGENDAR CITA
	--insert into mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	--select p.id_paciente,
	--		'Cliente',
	--		'PN-2',
	--		'No pierdas tu cita de depilacion laser',
	--		dateadd(hh,d.hora,@fecha),
	--		null,--,d.dia 
	--		@id_ejecucion
	--from #temp_paquetes p
	--join #temp_dia_notificacion d on d.dia = p.dias		
	--where p.dias > 12
	/****************************AJAL20210317 Roberto solicito desactivar esta notificacion****************************/

	--RECORDATORIO ACUDIR A SUCURSAL A PASAR TARJETA A MSI
	insert into #mobile_notificacion (id_usuario,tipo_usuario,tipo_notificacion,mensaje,fecha_ejecucion,id_cita,id_ejecucion)
	select p.id_paciente,
			'Cliente',
			'RP',
			'Distinguido cliente, le recordamos pasar mañana a la sucursal ' + s.descripcion + ' a pasar su tarjeta a meses sin intereses en Europiel, ' +
			'de lo contrario se le realizara un solo cargo directo en automatico, gracias',
			@fecha + CAST('12:00:000' AS DATETIME),
			null,--,d.dia 
			@id_ejecucion
	from paquete p
	join sucursal s on s.id_sucursal=p.id_sucursal_origen
	where p.saldo_total>0
	and p.pagos_x_cubrir=1
	and p.fecha_pago_1=@fecha_1dia
	and p.forma_pago in ('C','D')
	and p.tipo_cobranza_1='A'

END

if @bloque='ESP'
begin
	update n set
		fecha_ejecucion=dbo.fn_horario_con_timezone(n.fecha_ejecucion, pa.id_sucursal)
	from #mobile_notificacion as n
	join paciente pa on pa.id_paciente=n.id_usuario
	where n.id_ejecucion=@id_ejecucion
end







	--select * from #mobile_notificacion where id_usuario=59966
	--insert into #tablaPacientes
	drop table if exists #tablaPacientes
	select * into #tablaPacientes  from #TABLA_PACIENTES 
/**************************************FIN DE TODO EL PROCESO****************************************************/
	select distinct * from #tablaPacientes where id_paciente in(


	select 
	id_paciente 
	from #tablaPacientes
	
	group by id_paciente

	having count(*)>1
	
	)
	order by id_paciente