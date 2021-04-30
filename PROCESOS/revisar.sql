select * from rm_europiel.dbo.TABLA_NOTIFI_WHATSAPP 
where cast(HORA_EJECUCION as date)=cast(GETDATE() as date)

order by HORA_EJECUCION desc
--select * from #tabla

select * from rm_europiel_requerimientos.dbo.notifier_mensajes
where 
mobile_os='whatsapp'
and id_notifier=5
and cast(fecha_alta_registro as date)=cast(GETDATE() as date)
and (payload   not like '%preferenica%'
or  payload  not like '%Tu número de acceso%' 
or  payload  not like '%Actualiza tu APP%' 
or  payload  not like '%hemos terminado%' 
or  payload  not like '%Agradecemos tu confianza al tomar el tratamiento%' 
or  payload  not like '%Gracias por tu preferencia.%' 
)
--and bloque not like '%ESP%'
--and id_usuario=19584
order by fecha_alta_registro,id_usuario desc
