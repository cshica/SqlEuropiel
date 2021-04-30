select * from TABLA_NOTIFI_WHATSAPP 
where cast(HORA_EJECUCION as date)=cast(GETDATE() as date)
--and id_paciente=25226
order by HORA_EJECUCION desc
--select * from #tabla

select * from rm_europiel_requerimientos.dbo.notifier_mensajes
where 
mobile_os='whatsapp'
and id_notifier=5
and cast(fecha_alta_registro as date)=cast(GETDATE() as date)
--and bloque not like '%ESP%'
--and id_usuario=36746
order by fecha_alta_registro,id_usuario desc


--fn_formatear_telefono