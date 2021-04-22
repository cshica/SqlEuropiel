--SELECT * FROM CONFIGURACIONES_MENSAJES_TWILIO
select * from rm_europiel.dbo.TABLA_NOTIFI_WHATSAPP 
--where ID_PACIENTE=60176
WHERE id_cita=1410360
--WHERE CAST(fecha_inicio AS DATE)=CAST(GETDATE() AS DATE)
order by HORA_EJECUCION desc

SELECT * FROM rm_europiel_requerimientos.dbo.notifier_mensajes
where mobile_os='whatsapp'
and CAST(fecha_alta_registro AS DATE)=CAST(GETDATE() AS DATE)
and id_usuario=58779
order by id_detalle desc
