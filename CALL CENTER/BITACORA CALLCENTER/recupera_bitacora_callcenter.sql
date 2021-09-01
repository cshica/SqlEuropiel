USE [rm_europiel_requerimientos]
GO
/****** Object:  StoredProcedure [dbo].[recupera_bitacora_callcenter]    Script Date: 30/08/2021 07:37:44 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[recupera_bitacora_callcenter](
@id_paciente int
)
as
 begin
	set language 'spanish'
	select b.id_bitacora,
	       b.id_sucursal,
		   b.bloque,
		   b.id_paciente,
		   b.id_agente,
		   b.agente,
		   fecha_registro = DATENAME(weekday,b.fecha_registro) + ' ' + Format(b.fecha_registro, 'dd MMM yy'),
		   convert(varchar, b.fecha_registro, 112) as fecha_corta,
		   bt.descripcion as tipo_reporte,
		   b.observaciones,
		   estatus = (case when b.estatus = 1 then 'Abierto'
		                  when b.estatus = 2 then 'Pendiente'
						  when b.estatus = 3 then 'Completado'
						  when b.estatus = 4 then 'Inconcluso' else '' end),
		   Isnull(b.id_cliente_callcenter,0) as id_cliente_callcenter
	  from bitacora_callcenter b
	  join bitacora_callcenter_tipo_reporte bt on b.id_tipo_reporte=bt.id_tipo_reporte
	 where b.id_paciente=@id_paciente
  order by b.id_bitacora desc

 end
