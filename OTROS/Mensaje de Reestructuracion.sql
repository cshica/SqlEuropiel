
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

drop table if exists #tabla
	select top 1 id_notifier, id_usuario, id_bloque, bloque, telefono, device_token, payload, fecha_envio, ultimo_estatus, fecha_ultimo_estatus, mobile_os, id_referencia, fecha_alta_registro, clave_acceso, emisor, nombre_cliente into #tabla
	from  rm_europiel_requerimientos.dbo.notifier_mensajes

	delete from #tabla

DECLARE @NUM_MSG INTEGER = (select N1 from rm_europiel_requerimientos.dbo.CONFIGURACIONES_MENSAJES_TWILIO where Id=20)

insert into #pacientes (id_paciente, id_bloque, bloque, nombre, apellidos, telefono1, telefono2, clave_acceso)
select top (@NUM_MSG) pa.id_paciente, s.id_bloque, b.abreviatura, pa.nombre, pa.ap_paterno + ' ' + pa.ap_materno, -- se amplió el numero de mensajes de 50 a 100 a solicitud de IRAMM. cshica 16-06-2021
		'+' + pai.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(pa.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pai.longitud_celulares) as telefono_1, 
		'+' + pai.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(pa.telefono_2,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pai.longitud_celulares) as telefono_2,
		clave_acceso = dbo.fn_clave_acceso(pa.id_paciente)
from paciente pa (nolock)
join sucursal s (nolock) on s.id_sucursal = pa.id_sucursal
join bloque b (nolock) on b.id_bloque = s.id_bloque
join pais pai (nolock) on pai.id_pais = s.id_pais

and exists (select 1 
			from paquete paq (nolock) 
			where paq.id_paciente = pa.id_paciente
			and paq.fecha_compra>='2021-01-01'-- se agregó este foltro a solicitud de IRAMM, Todos los paquetes comprados a partir del 01 de enero del 2020 hasta la actualidad. cshica 16-06-2021
			and paq.saldo_total > 2500 --valor anterior 2000 Modificado: 20-07-2021
			--and paq.saldo_total = (paq.costo_total - paq.anticipo) -- se quitó por prueba Modificado: 20-07-2021
			and paq.fecha_pago_1 < dateadd(day,-50,getdate())--se cambio de 61 a 50 dias : cshica 25-05-2021
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

	print '-------------------------------'
	print '@id_paciente: ' + convert(varchar,@id_paciente)
	print '@nombre: ' + @nombre
	print '@apellidos: ' + @apellidos
	print '@clave_acceso: ' + @clave_acceso


	--select @telefono_destino = 

	declare @saldo_original decimal(18,2)
	select @saldo_total = sum(saldo_total)	
	from paquete p (nolock)
	where p.id_paciente = @id_paciente

	set @saldo_original=@saldo_total

	print '@saldo_total: ' + convert(varchar,@saldo_total)
	select @saldo_total = @saldo_total * 0.9
	print '-------------------------------'
	print '@saldo_total DESC: ' + convert(varchar,@saldo_total)

	select @saldo_convertido = CONVERT(varchar, CAST(@saldo_total AS money), 1)
	select @pagos_convertido = CONVERT(varchar, CAST((@saldo_total/@num_pagos) AS money), 1)--CSHICA 25-05-2021- Se cambió a 6 quincenas, el valor anterior fue de 8 (@saldo_total/8.0)
	select @payload = '{
		"type":"whatsapp",
		"device":"' + @telefono_destino + '",
		"emitter":"' + @emisor + '",
		"environment":"PROD",
		"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",
		"payload":"*¡Felicidades '+@nombre+'!*\n\nHas sido seleccionado para obtener un *DESCUENTO GRATIS* en el saldo de tu Cuenta con Europiel.\n\nActualmente tus pagos de '+cast(@saldo_original as nvarchar(50))+' pueden ser *REDUCIDOS a '+@saldo_convertido + ' en '+ cast(@num_pagos as varchar(10))+' quincenas* de tan solo '+@pagos_convertido+'.\n\n¿Te gustaría aprovechar esta oportunidad ahora?"
}'



	print @payload

	


	insert into #tabla (id_notifier, id_usuario, id_bloque, bloque, telefono, device_token, payload, fecha_envio, ultimo_estatus, 
																	fecha_ultimo_estatus, mobile_os, id_referencia, fecha_alta_registro, clave_acceso, emisor, nombre_cliente)
	values (13,@id_paciente,@id_bloque,@bloque,@telefono_destino,null,@payload,null,null,null,'whatsapp',null,getdate(),@clave_acceso, @emisor, @nombre + ' ' + @apellidos)

	
	


	select @currId=@currId+1
  end


select * from #tabla
select * from #pacientes
