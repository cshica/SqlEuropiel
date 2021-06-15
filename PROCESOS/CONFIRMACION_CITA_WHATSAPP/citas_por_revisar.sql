select * from rm_europiel.dbo.TABLA_NOTIFI_WHATSAPP 
where 
-- cast(HORA_EJECUCION as date)=cast(GETDATE() as date)	
telefono like '%3002533342%'


order by HORA_EJECUCION desc

select * from rm_europiel.dbo.log_cancelacion_masiva where id_sucursal=17 order by id_log desc

select * from notifier_mensajes where telefono like '%3002533342%' and id_cita=1467242

select * from rm_europiel.dbo.CITA where id_cita=1467242
select * from rm_europiel.dbo.CITA_LOG where id_cita=1467242 order by id_log desc


select * from rm_europiel.dbo.SUCURSAL where descripcion like '%Barranquilla%'
select * from rm_europiel.dbo.bloque where abreviatura='COL2'



select * from user_global where telefono_personal like '%323223%'


