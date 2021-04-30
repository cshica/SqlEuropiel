select * from rm_europiel.dbo.TABLA_NOTIFI_WHATSAPP 
where cast(HORA_EJECUCION as date)=cast(GETDATE() as date)
<<<<<<< HEAD
<<<<<<< HEAD
--and id_paciente=19584
=======
 --id_paciente=59966
>>>>>>> 16b7ffe8c0b94d355ff7a6866e4f0fc9dce6b539
=======
--and id_paciente=19584
>>>>>>> 620e7ca (Mensajes)
order by HORA_EJECUCION desc
--select * from #tabla

select * from rm_europiel_requerimientos.dbo.notifier_mensajes
where 
mobile_os='whatsapp'
and id_notifier=5
and cast(fecha_alta_registro as date)=cast(GETDATE() as date)
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 620e7ca (Mensajes)
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
--fn_formatear_telefono

<<<<<<< HEAD
--{"type":"whatsapp","device":"+34633977741","emitter":"+19794645556","environment":"PROD","token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ","payload":"Hola ELVIRA FERNANDEZ! Bienvenida a Europiel. Tu número de acceso de un solo uso es 3204, favor de no compartirlo con NADIE. Puedes solicitar uno nuevo desde tu App de Europiel."}
=======
and payload like '%tu cita para depilarte se aproxima%'
and bloque  like '%ESP%'
--and id_usuario=59966
order by fecha_alta_registro desc

--update rm_europiel.dbo.TABLA_NOTIFI_WHATSAPP set envio_confirmar='2021-04-27 17:38:00.000', enviado=0 where id_cita=1418717

--select fecha_confirmacion,* from rm_europiel.dbo.cita where id_cita=1418717
--select * from rm_europiel.dbo.PACIENTE where ap_paterno='shica'

--update rm_europiel.dbo.cita set fecha_confirmacion=null where id_cita=1418717
--update rm_europiel.dbo.cita set fecha_inicio='2021-04-30 22:55:00.000', fecha_fin='2021-04-30 23:12:00.000' where id_cita=1418717



>>>>>>> 16b7ffe8c0b94d355ff7a6866e4f0fc9dce6b539
=======
--{"type":"whatsapp","device":"+34633977741","emitter":"+19794645556","environment":"PROD","token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ","payload":"Hola ELVIRA FERNANDEZ! Bienvenida a Europiel. Tu número de acceso de un solo uso es 3204, favor de no compartirlo con NADIE. Puedes solicitar uno nuevo desde tu App de Europiel."}
>>>>>>> 620e7ca (Mensajes)
