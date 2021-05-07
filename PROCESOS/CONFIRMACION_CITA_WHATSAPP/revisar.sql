select * from rm_europiel.dbo.TABLA_NOTIFI_WHATSAPP 
where cast(HORA_EJECUCION as date)=cast(GETDATE() as date)
 --id_paciente=59966
order by HORA_EJECUCION desc
--select * from #tabla

select * from rm_europiel_requerimientos.dbo.notifier_mensajes
where 
mobile_os='whatsapp'
and id_notifier=5
and cast(fecha_alta_registro as date)=cast(GETDATE() as date)
and payload like '%tu cita para depilarte se aproxima%'
and bloque  like '%ESP%'
--and id_usuario=59966
order by fecha_alta_registro desc

--update rm_europiel.dbo.TABLA_NOTIFI_WHATSAPP set envio_confirmar='2021-04-27 17:38:00.000', enviado=0 where id_cita=1418717

--select fecha_confirmacion,* from rm_europiel.dbo.cita where id_cita=1418717
--select * from rm_europiel.dbo.PACIENTE where ap_paterno='shica'

--update rm_europiel.dbo.cita set fecha_confirmacion=null where id_cita=1418717
--update rm_europiel.dbo.cita set fecha_inicio='2021-04-30 22:55:00.000', fecha_fin='2021-04-30 23:12:00.000' where id_cita=1418717



