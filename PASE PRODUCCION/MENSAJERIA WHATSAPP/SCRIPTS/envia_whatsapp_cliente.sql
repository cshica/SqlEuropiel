GO
DROP PROC IF EXISTS envia_whatsapp_cliente
GO
CREATE procedure [dbo].[envia_whatsapp_cliente]
	@tablaPacientes TypePacienteWhatsapp READONLY
as
/**************************************************
--SOLO PARA PRUEBAS - CSHICA 16/04/2021 12:00 medio dia
	LUEGO SE DEBE BORRAR ESTA TABLA
	DROP TABLE IF EXISTS TEMPORAL_TABLE_ENVIOS
	CREATE TABLE TEMPORAL_TABLE_ENVIOS
	(
		ID INT
		,ID_PACIENTE INT
		,MENSAJE VARCHAR(MAX)
		,FECHA_ENVIO DATETIME
	)
*/
--select * from  TEMPORAL_TABLE_ENVIOS
INSERT INTO TEMPORAL_TABLE_ENVIOS
SELECT *,GETDATE() FROM @tablaPacientes order by id desc
--**************************************************
--declare @id_paciente int = 1,
--		@mensaje varchar(1024) = 'Hola!, tu cita para depilarte se aproxima , el {{1}} alas {{2}}. Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'

--select @mensaje = 'Para confirmar su cita pulse aquí {{1}}'

declare @emisor varchar(32)
SELECT top 1 @emisor = emiter
FROM rm_europiel_requerimientos.dbo.whatsapp_emiter
ORDER BY cantidad_limite - cantidad_mensajes_enviados_hoy DESC


insert into rm_europiel_requerimientos.dbo.notifier_mensajes (id_notifier, id_usuario, id_bloque, bloque, telefono, payload, mobile_os, fecha_alta_registro, emisor)
select id_notifier=5,
		id_usuario=p.id_paciente,
		s.id_bloque,
		b.abreviatura,
		telefono = /*'+528115991351'*/(case 
						when ltrim(rtrim(p.telefono_2)) like '+%' then replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'(',''),')','')
						else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
					end),
		payload = '{"type":"' + (case when pa.id_pais=2 then 'sms' else 'whatsapp' end) + '", 
"device":"' + /*'+528115991351'*/(case 
						when ltrim(rtrim(p.telefono_2)) like '+%' then replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'(',''),')','')
						else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
					end) + '", 
"emitter":"' + @emisor + '", 
"environment":"PROD", 
"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ", 
"payload":"' + tp.mensaje + '"}',
		mobile_os = (case when pa.id_pais=2 then 'sms' else 'whatsapp' end),
		fecha_alta_registro = getdate(),
		@emisor
from paciente p (nolock)
join sucursal s (nolock) on s.id_sucursal = p.id_sucursal_2
join pais pa (nolock) on pa.id_pais = s.id_pais
join bloque b (nolock) on b.id_bloque = s.id_bloque
join @tablaPacientes tp on tp.id_paciente = p.id_paciente
order by tp.id
GO
/******************************************************************************************************************************************/
DROP PROC IF EXISTS envia_whatsapp_cliente_test
GO
CREATE procedure [dbo].[envia_whatsapp_cliente_test]
	@tablaPacientes TypePacienteWhatsapp READONLY
as

--declare @id_paciente int = 1,
--		@mensaje varchar(1024) = 'Hola!, tu cita para depilarte se aproxima , el {{1}} alas {{2}}. Te recomendamos estar 10 minutos antes, para evitar contratiempos. Recuerda que no puedes traer desodorante maquillaje cremas loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'

--select @mensaje = 'Para confirmar su cita pulse aquí {{1}}'

declare @emisor varchar(32)
SELECT top 1 @emisor = emiter
FROM rm_europiel_requerimientos.dbo.whatsapp_emiter
ORDER BY cantidad_limite - cantidad_mensajes_enviados_hoy DESC


insert into rm_europiel_requerimientos.dbo.notifier_mensajes_whatsapp (id_notifier, id_usuario, id_bloque, bloque, telefono, payload, mobile_os, fecha_alta_registro, emisor)
select id_notifier=5,
		id_usuario=p.id_paciente,
		s.id_bloque,
		b.abreviatura,
		telefono = /*'+528115991351'*/(case 
						when ltrim(rtrim(p.telefono_2)) like '+%' then replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'(',''),')','')
						else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
					end),
		payload = '{"type":"' + (case when pa.id_pais=2 then 'sms' else 'whatsapp' end) + '", 
"device":"' + /*'+528115991351'*/(case 
						when ltrim(rtrim(p.telefono_2)) like '+%' then replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'(',''),')','')
						else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
					end) + '", 
"emitter":"' + @emisor + '", 
"environment":"PROD", 
"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ", 
"payload":"' + tp.mensaje + '"}',
		mobile_os = (case when pa.id_pais=2 then 'sms' else 'whatsapp' end),
		fecha_alta_registro = getdate(),
		@emisor
from paciente p (nolock)
join sucursal s (nolock) on s.id_sucursal = p.id_sucursal_2
join pais pa (nolock) on pa.id_pais = s.id_pais
join bloque b (nolock) on b.id_bloque = s.id_bloque
join @tablaPacientes tp on tp.id_paciente = p.id_paciente
order by tp.id
GO