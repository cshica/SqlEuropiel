drop table if exists #pacientes
drop table if exists #tabla
select top 1 * into #tabla from rm_europiel_requerimientos.dbo.notifier_mensajes
truncate table #tabla

create table #pacientes
(
	id int identity(1,1),
	id_paciente int,
	id_bloque int,
	bloque varchar(8),
	nombre varchar(512),
	apellidos varchar(512),
	telefono1 varchar(32),
	telefono2 varchar(32),
	clave_acceso varchar(32)
)


insert into #pacientes (id_paciente, id_bloque, bloque, nombre, apellidos, telefono1, telefono2, clave_acceso)
select top 50 pa.id_paciente, s.id_bloque, b.abreviatura, pa.nombre, pa.ap_paterno + ' ' + pa.ap_materno, 
		'+' + pai.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(pa.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pai.longitud_celulares) as telefono_1, 
		'+' + pai.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(pa.telefono_2,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pai.longitud_celulares) as telefono_2,
		clave_acceso = dbo.fn_clave_acceso(pa.id_paciente)
from paciente pa (nolock)
join sucursal s (nolock) on s.id_sucursal = pa.id_sucursal
join bloque b (nolock) on b.id_bloque = s.id_bloque
join pais pai (nolock) on pai.id_pais = s.id_pais
where not exists (select 1 
					from expediente_servicio ex (nolock) 
					where ex.id_paciente = pa.id_paciente)
and exists (select 1 
			from paquete paq (nolock) 
			where paq.id_paciente = pa.id_paciente
			and paq.saldo_total > 2000
			and paq.saldo_total = (paq.costo_total - paq.anticipo)
			and paq.fecha_pago_1 < dateadd(day,-50,getdate())
			and paq.proviene_de_migracion = 0
			and paq.no_disponible_por_migracion = 0
			and paq.borrado_en_migracion = 0)
and not exists (select 1 
				 from rm_europiel_requerimientos.dbo.notifier_mensajes nm (nolock)
				 where nm.id_usuario = pa.id_paciente
				 and nm.id_notifier = 13)
and s.id_pais = 1
and (len(pa.telefono_2) >= 10 or len(pa.telefono_1) >= 10)
order by pa.fecha_alta desc



--insert into #pacientes (id_paciente, id_bloque, bloque, nombre, apellidos, telefono1, telefono2, clave_acceso)
--select top 1 pa.id_paciente, s.id_bloque, b.abreviatura, pa.nombre, pa.ap_paterno + ' ' + pa.ap_materno, 
--		'+' + pai.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(pa.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pai.longitud_celulares) as telefono_1, 
--		'+' + pai.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(pa.telefono_2,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pai.longitud_celulares) as telefono_2,
--		clave_acceso = dbo.fn_clave_acceso(pa.id_paciente)
--from paciente pa (nolock)
--join sucursal s (nolock) on s.id_sucursal = pa.id_sucursal
--join bloque b (nolock) on b.id_bloque = s.id_bloque
--join pais pai (nolock) on pai.id_pais = s.id_pais
--where pa.id_paciente = 49205
--order by pa.fecha_alta desc

--insert into #pacientes (id_paciente, id_bloque, bloque, nombre, apellidos, telefono1, telefono2, clave_acceso)
--select top 1 pa.id_paciente, s.id_bloque, b.abreviatura, pa.nombre, pa.ap_paterno + ' ' + pa.ap_materno, 
--		'+' + pai.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(pa.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pai.longitud_celulares) as telefono_1, 
--		'+' + pai.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(pa.telefono_2,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pai.longitud_celulares) as telefono_2,
--		clave_acceso = dbo.fn_clave_acceso(pa.id_paciente)
--from paciente pa (nolock)
--join sucursal s (nolock) on s.id_sucursal = pa.id_sucursal
--join bloque b (nolock) on b.id_bloque = s.id_bloque
--join pais pai (nolock) on pai.id_pais = s.id_pais
--where pa.id_paciente = 49238
--order by pa.fecha_alta desc


-- select * from bloque


declare @num_pagos int =6
declare @currId int = 1,
		@maxId int = 0

select @maxId = max(id) from #pacientes

while @currId <= @maxId
  begin
	declare @id_paciente int = 0,
			@id_bloque int = 0,
			@bloque varchar(8) = '',
			@saldo_total decimal(18,2) = 0,
			@saldo_convertido varchar(32) = '',
			@pagos_convertido varchar(32) = '',
			@nombre varchar(512) = '',
			@apellidos varchar(512) = '',
			@payload varchar(2048),
			@emisor varchar(32) = '+14157022948',
			@telefono_destino varchar(32),
			@clave_acceso varchar(32) = ''

	select @id_paciente = id_paciente,
			@nombre = nombre,
			@apellidos = apellidos,
			@telefono_destino = (case when len(telefono2) >=10 then telefono2 else telefono1 end),
			@clave_acceso = clave_acceso,
			@id_bloque = id_bloque,
			@bloque = bloque
	from #pacientes where id = @currId

	--print '-------------------------------'
	--print '@id_paciente: ' + convert(varchar,@id_paciente)
	--print '@nombre: ' + @nombre
	--print '@apellidos: ' + @apellidos
	--print '@clave_acceso: ' + @clave_acceso


	--select @telefono_destino = 

	select @saldo_total = sum(saldo_total)
	from paquete p (nolock)
	where p.id_paciente = @id_paciente

	--print '@saldo_total: ' + convert(varchar,@saldo_total)
	select @saldo_total = @saldo_total * 0.9
	--print '-------------------------------'
	--print '@saldo_total DESC: ' + convert(varchar,@saldo_total)

	select @saldo_convertido = CONVERT(varchar, CAST(@saldo_total AS money), 1)
	select @pagos_convertido = CONVERT(varchar, CAST((@saldo_total/@num_pagos) AS money), 1)--CSHICA 25-05-2021- Se cambió a 6 quincenas, el valor anterior fue de 8 (@saldo_total/8.0)

/*	select @payload = '{
		"type":"whatsapp",
		"device":"' + @telefono_destino + '",
		"emitter":"' + @emisor + '",
		"environment":"PROD",
		"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",
		"payload":"Hola ' + @nombre + ', nos comunicamos de EUROPIEL. Para seguir depilándose, solo queremos ver si acepta su nuevo saldo de ' + @saldo_convertido + ' a pagarse en 8 quincenas de ' + @pagos_convertido + ' pesos, por favor díganos qué hacemos con
 su cita, ya estás a punto de no volver a tener vello nunca más!"
}'*/

--	select @payload = '{
--		"type":"whatsapp",
--		"device":"' + @telefono_destino + '",
--		"emitter":"' + @emisor + '",
--		"environment":"PROD",
--		"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",
--		"payload":"¡Hola ' + @nombre + '!, esperando y todo bien nos comunicamos de Europiel para apoyarte en lo que necesites ya que analizando tu cuenta, vemos la opción de un nuevo saldo para ti de  ' + @saldo_convertido + ' el cuál estamos ofreciéndote desglozarlo en  8 quincenas de ' + @pagos_convertido + ' para tu mayor comodidad. Así que aceptando esto, solo haznos saber cuándo se te facilita tu primer cita y así puedas continuar con tus sesiones sin ningún problema. ¿Cómo ves, cuándo te agendamos?"
--}'

	select @payload = '{
		"type":"whatsapp",
		"device":"' + @telefono_destino + '",
		"emitter":"' + @emisor + '",
		"environment":"PROD",
		"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",
		"payload":"¡Hola '+@nombre+'!, esperamos te encuentres muy bien, nos contactamos de *EUROPIEL* ya que analizando tu cuenta, vemos la opción de un mejor plan de pagos para ti de *'+@saldo_convertido+'* el cual pudiéramos desglosar en *'+cast(@num_pagos as varchar(10))+'* quincenas de *'+@pagos_convertido+'* para tu mayor comodidad.\n\n¿Aceptas esta propuesta?"
}'

	--print @payload

	

	insert into #tabla (id_notifier, id_usuario, id_bloque, bloque, telefono, device_token, payload, fecha_envio, ultimo_estatus, 
																	fecha_ultimo_estatus, mobile_os, id_referencia, fecha_alta_registro, clave_acceso, emisor, nombre_cliente)
	values (13,@id_paciente,@id_bloque,@bloque,@telefono_destino,null,@payload,null,null,null,'whatsapp',null,getdate(),@clave_acceso, @emisor, @nombre + ' ' + @apellidos)

	/*
	
insert into notifier_mensajes values (13,0,2,'MTY2',@telefono_destino,null,'{
		"type":"whatsapp",
		"device":"' + @telefono_destino + '",
		"emitter":"' + @emisor + '",
		"environment":"PROD",
		"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",
		"payload":"Hola Roberto, nos comunicamos de EUROPIEL. Para seguir depilándose, solo queremos ver si acepta su nuevo saldo de 5500 a pagarse en 8 quincenas de 250 pesos, por favor díganos qué hacemos con su cita, ya estás a punto de no volver a tener vello nunca más!"
}',null,null,null,'whatsapp',null,getdate(),@clave_acceso, @emisor, 'Roberto Frias')
	*/


	select @currId=@currId+1
  end


select top 1 * from #tabla

select * from PACIENTE where ap_paterno='pruebas' --59966

delete from #tabla where telefono !='+528116086379'
update #tabla set id_usuario=59966, emisor='+14159416424',telefono='+528261065393',payload='{		"type":"whatsapp",		"device":"+528261065393",		"emitter":"+14159416424",		"environment":"PROD",		"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",		"payload":"¡Hola CESAR!, esperamos te encuentres muy bien, nos contactamos de *EUROPIEL* ya que analizando tu cuenta, vemos la opción de un mejor plan de pagos para ti de *3,420.00* el cual pudiéramos desglosar en *6* quincenas de *570.00* para tu mayor comodidad.\n\n¿Aceptas esta propuesta?"}' where telefono='+528261065393'

insert into rm_europiel_requerimientos.dbo.notifier_mensajes (id_notifier, id_usuario, id_bloque, bloque, telefono, device_token, payload, fecha_envio, ultimo_estatus, 
																	fecha_ultimo_estatus, mobile_os, id_referencia, fecha_alta_registro, clave_acceso, emisor, nombre_cliente)
select id_notifier, id_usuario, id_bloque, bloque, telefono, device_token, payload, fecha_envio, ultimo_estatus, 
																	fecha_ultimo_estatus, mobile_os, id_referencia, fecha_alta_registro, clave_acceso, emisor, nombre_cliente from #tabla


																	


