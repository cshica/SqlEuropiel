
select * from rm_europiel_sinergia3.dbo.TABLA_NOTIFI_WHATSAPP 
where 
--cast(HORA_EJECUCION as time)='00:00:00.000'				and 
--cast(HORA_EJECUCION as date)=cast(GETDATE() as date)	and 
cast(envio_confirmar as time)='08:00:00.000'			and 
cast(envio_confirmar as date)=cast(GETDATE() as date)	and 
cast(fecha_inicio as date)=cast(GETDATE() as date)		and 
cast(fecha_inicio as time)='08:00:00.000'
order by HORA_EJECUCION desc


update rm_europiel_sinergia3.dbo.TABLA_NOTIFI_WHATSAPP 
set envio_confirmar=(envio_confirmar+1)
where id_cita in
(
	select id_cita from rm_europiel_sinergia3.dbo.TABLA_NOTIFI_WHATSAPP 
	where 
	cast(HORA_EJECUCION as time)='00:00:00.000'
	and cast(HORA_EJECUCION as date)=cast(GETDATE() as date)
	and cast(envio_confirmar as time)='08:00:00.000'
	and cast(fecha_inicio as date)=cast(GETDATE() as date)
)

update rm_europiel_sinergia3.dbo.TABLA_NOTIFI_WHATSAPP 
set envio_confirmar=dateadd(MI,-20,envio_confirmar)
where id_cita in
(
	select id_cita from rm_europiel_sinergia3.dbo.TABLA_NOTIFI_WHATSAPP 
	where 
	cast(envio_confirmar as time)='08:00:00.000'			and 
	cast(envio_confirmar as date)=cast(GETDATE() as date)	and 
	cast(fecha_inicio as date)=cast(GETDATE() as date)		and 
	cast(fecha_inicio as time)='08:00:00.000'
)