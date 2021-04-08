--select * from TEMPORAL_TABLE_ENVIOS where ID_PACIENTE=59966
/**********************************************************************
declare @fecha datetime = CAST(GETDATE() AS DATE), @fecha_2dias datetime = CAST(DATEADD(DD,2,GETDATE()) as DATE), @fecha_1dia datetime = CAST(DATEADD(DD,1,GETDATE()) as DATE),
		@bloque varchar(32)='', @id_ejecucion int=0
declare @tablaPacientes TypePacienteWhatsapp		
select top 1 @bloque=bloque from parametro

select @id_ejecucion=max(id_ejecucion) from mobile_notificacion
select @id_ejecucion=ISNULL(@id_ejecucion,0) + 1
alter table #mobile_notificacion alter column  tipo_notificacion  nvarchar(max)
alter table #mobile_notificacion alter column  mensaje  nvarchar(max)
select * from #mobile_notificacion
*****************************************************************************/


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
/*********************************************************************************/

/*********************************************************************************/
--select cast(floor(convert(float,GETDATE())) as datetime) 
--select   datediff(dd,'2021-04-07 16:06:54.490',cast(floor(convert(float,GETDATE())) as datetime)) 
--select * from #temp_citas WHERE id_paciente=59966
--select * from #temp_paquetes  WHERE id_paciente=59966
--select * from #temp_dia_notificacion
--select * from #temp_citas_unir where id_paciente=59966
--select* from mobile_notificacion mn where mn.id_usuario=59966
--SELECT * FROM PAQUETE WHERE fecha_negrita IS NOT NULL 
--SELECT * FROM PAQUETE WHERE id_paciente=59966
/*********************************************************************************/

--declare @fecha datetime = CAST(GETDATE() AS DATE), @fecha_2dias datetime = CAST(DATEADD(DD,2,GETDATE()) as DATE), @fecha_1dia datetime = CAST(DATEADD(DD,1,GETDATE()) as DATE),
--		@bloque varchar(32)='', @id_ejecucion int=0
--declare @tablaPacientes TypePacienteWhatsapp		
--select top 1 @bloque=bloque from parametro

--select @id_ejecucion=max(id_ejecucion) from mobile_notificacion
--select @id_ejecucion=ISNULL(@id_ejecucion,0) + 1
/*********************************************************************************/
DROP TABLE IF EXISTS #mobile_notificacion
select c.id_paciente id_usuario, 
			'Cliente' tipo_usuario,
			'CC' tipo_notificacion,
			--'Favor de confirmar su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
			--		' en la sucursal ' + sucursal + ' para evitar que sea cancelada',
			'Notificacion urgente de tu cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ', da click para abrir' mensaje,
			@fecha + CAST('12:00:000' AS DATETIME) fecha_ejecucion,
			c.id_cita id_cita,
			@id_ejecucion id_ejecucion
			INTO #mobile_notificacion  --TABLA mobile_notificacion
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias

	alter table #mobile_notificacion alter column  tipo_notificacion  nvarchar(max)
	alter table #mobile_notificacion alter column  mensaje  nvarchar(max)
	/**********************************************************************************/
	--select c.id_paciente id_usuario, 
	--		'Cliente' tipo_usuario,
	--		'CC' tipo_notificacion,
	--		--'Favor de confirmar su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
	--		--		' en la sucursal ' + sucursal + ' para evitar que sea cancelada',
	--		'Notificacion urgente de tu cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ', da click para abrir' mensaje,
	--		cast('2021-04-07'as DATETIME) + CAST('12:00:000' AS DATETIME) fecha_ejecucion,
	--		c.id_cita id_cita,
	--		2 id_ejecucion
			
	--from #temp_citas c
	--where c.confirmada=0
	--and CAST(c.fecha_inicio as DATE) = '2021-04-09'
	--and c.id_paciente=59966
	/**********************************************************************************/
	
/**********************************************************************************/

DROP TABLE IF EXISTS #tablaPacientes
select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
					'alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
					'10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas ' +
					'loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	into #tablaPacientes
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias
/**********************************************************************************/	
	
	insert into #tablaPacientes 
	select c.id_paciente,
			mensaje='Para confirmar su cita pulse aquí http://citas.europiel.com.mx/ConfirmarCita.aspx?c=' + convert(varchar(16),c.id_cita) + '&p=' + convert(varchar(16),c.id_paciente) + '&b=' + @bloque + ' escribe OK para activar el link'
	from #temp_citas c
	where c.confirmada=0
	and CAST(c.fecha_inicio as DATE) = @fecha_2dias
/**********************************************************************************/	

	--RECORDATORIO 1 DIA ANTES 12:00
	--select * from #mobile_notificacion
	insert into #mobile_notificacion 
	select c.id_paciente paciente,
			'Cliente' cliente,
			case when c.tipo_confirmacion='APP' then 'RC-1D' else 'SMS-RC' end tipo,
			--'Le recordamos su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal,
			case 
				when c.tipo_confirmacion='APP' then 'Le recordamos su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en la sucursal ' + c.sucursal
				 else c.paciente + ', le recordamos su cita del ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + ' en Europiel'
			end msg,			
			@fecha + CAST('12:00:000' AS DATETIME) fecha,
			c.id_cita cita,
			@id_ejecucion ejecucion
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha_1dia
	and c.confirmada=1
/**********************************************************************************/	

insert into #tablaPacientes 
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el ' + dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' ' +
					'alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. Te recomendamos estar ' +
					'10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje ' +
					'cremas loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha_1dia
	and c.confirmada=1
/**********************************************************************************/	
--RECORDATORIO DIA DE LA CITA 3 HORAS ANTES DE LA CITA
	--CITAS DESPUES DE LAS 12:00 SE NOTIFICAN A LAS 12:00					@tipo_ejecucion=2
	--CITAS ENTRE 10:00 y 12:00 SE NOTIFICAN A LAS 9:00						@tipo_ejecucion=1
	--CITAS ENTRE 08:00 y 10:00 SE NOTIFICAN UN DIA ANTES A LAS 8:00PM		@tipo_ejecucion=1

	insert into #mobile_notificacion 
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
/**********************************************************************************/

insert into #tablaPacientes 
	select c.id_paciente,
			mensaje='Hola!, tu cita para depilarte se aproxima , el dia de hoy alas ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + '. ' +
					'Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ' +
					'ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'
	from #temp_citas c
	where CAST(c.fecha_inicio as DATE) = @fecha
	and c.confirmada=1
	and c.fecha_inicio > DATEADD(HH,12,@fecha)
/**********************************************************************************/

if GETDATE() > '20200731' -- Omitir valiraciones hasta el 31 de Julio
		begin

	
				--RECORDATORIO VALORACION 1 DIA ANTES 12:00
				insert into #mobile_notificacion 
				select c.id_paciente idpaciente,
						'Cliente' cliente,
						case when c.tipo_confirmacion='APP' then 'CV-12' else 'SMS-RC' end tipo,
						--'Acudir hoy a valoración a Europiel de lo contrario mañana no se le podra atender en la sucursal ' + c.sucursal,
						case
							when c.tipo_confirmacion='APP' then 'Acudir hoy a valoracion a Europiel de lo contrario mañana no se le podra atender en la sucursal ' + c.sucursal
							 else c.paciente + ', acudir hoy a valoracion a Europiel de lo contrario mañana no se le podra atender'
						end msg,	
						@fecha + CAST('12:00:000' AS DATETIME) fecha,
						c.id_cita id_cita,
						@id_ejecucion ejecucion
				from #temp_citas c
				where CAST(c.fecha_inicio as DATE) = @fecha_1dia
				and c.confirmada=1
				and dbo.fn_es_cita_valoracion(id_cita) = 1

		end
/**********************************************************************************/
	--select * from #mobile_notificacion where id_usuario=59966
	select * from #tablaPacientes  where id_paciente=59966


