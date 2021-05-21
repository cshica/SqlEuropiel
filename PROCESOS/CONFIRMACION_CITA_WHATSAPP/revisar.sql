select * from rm_europiel.dbo.TABLA_NOTIFI_WHATSAPP 
where cast(HORA_EJECUCION as date)=cast(GETDATE() as date)
--telefono like '%4423434013%'
order by HORA_EJECUCION desc
--select * from #tabla

select * from rm_europiel_requerimientos.dbo.notifier_mensajes
where 
mobile_os='whatsapp'
and id_notifier=5
and cast(fecha_alta_registro as date)=cast(GETDATE()  as date)
and payload like '%Hola!, tu cita para depilarte se aproxima%'

--and bloque not like '%ESP%'
--and id_usuario=19584
order by fecha_alta_registro,id_usuario desc


-- revisar p`rocedure mobile_confirmacion_cita_v2

select * from paciente where ap_paterno='shica'



/***************************************************************************************/
--INDICES
CREATE NONCLUSTERED INDEX [IDX_12052021] ON [dbo].[TABLA_NOTIFI_WHATSAPP]
(
	[HORA_EJECUCION] ASC
)
INCLUDE([id_cita]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO





CREATE NONCLUSTERED INDEX [IDX_12052021] ON [dbo].[cita_borrada]
(
	[id_cita] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


