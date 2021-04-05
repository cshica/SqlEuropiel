--SELECT * FROM notifier
--SELECT TOP 10 * FROM notifier_mensajes
--WHERE payload LIKE '%OK%'

SELECT  * FROM rm_europiel.DBO.mobile_notificacion where mensaje like '%ok%'

select * from rm_europiel.dbo.whatsapp_interfaz where telefono='+528261065393'
select * from rm_europiel.dbo.whatsapp_interfaz where telefono='+528120731030'
select top 10 * from dbo.webhook where referencia1='SM3871e3e6c723494ba370ee35c87bf227'
select * from notifier_mensajes where id_referencia='SM3871e3e6c723494ba370ee35c87bf227'
select * from notifier_mensajes where device_token='94E2730C-6977-4CF8-BD21-0455019DE75E'
select * from rm_europiel.dbo.mobile_device_info where id_device='94E2730C-6977-4CF8-BD21-0455019DE75E'

select top 1000 * from rm_europiel_guadalajara.dbo.whatsapp_interfaz where id_paquete in (17488,30212)


SELECT no_disponible_por_migracion, borrado_en_migracion, proviene_de_migracion, * FROM rm_europiel.dbo.PAQUETE
WHERE contrato ='AV-90072418'


update  rm_europiel.dbo.PAQUETE set fecha_compra='2019-04-05 00:00:00.000' where id_paquete=72418



SELECT TOP 10 * FROM rm_europiel_requerimientos.dbo.notifier_mensajes 

SELECT no_disponible_por_migracion, borrado_en_migracion, proviene_de_migracion, * FROM rm_europiel.dbo.PAQUETE
WHERE nombre_paciente_1 LIKE '%SHICA%'

SELECT  * FROM notifier_mensajes WHERE id_usuario=59966 and cast(fecha_envio as date) = cast(getdate() as date) order by fecha_envio
SELECT top 10  * FROM config_requerimientos_detalle-- where id_detalle='14659445' --receptor='+528261065393'