USE [rm_europiel_requerimientos]
GO
/****** Object:  StoredProcedure [dbo].[recupera_bitacora_callcenter_x_id]    Script Date: 30/08/2021 07:36:11 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[recupera_bitacora_callcenter_x_id](
@id_bitacora int
)
as
 begin
 
	select b.id_bitacora,
		   b.bloque,
		   b.id_sucursal,
		   s.descripcion as sucursal,
		   b.id_paciente,
		   b.agente,
		   b.fecha_registro,
		   b.id_tipo_reporte,
		   bt.descripcion as tipo_reporte,
		   b.observaciones,
		   b.id_prioridad,
		   prioridad = (case when id_prioridad = 1 then 'Baja'
						     when id_prioridad = 2 then 'Media'
							 when id_prioridad = 3 then 'Alta' else '' end),
		   b.estatus,
		   estado = (case when estatus = 1 then 'Abierto'
						     when estatus = 2 then 'Pendiente'
							 when estatus = 3 then 'Completado'
							 when estatus = 4 then 'Inconcluso' 
							 else '' end)
	  from bitacora_callcenter b
	  join bitacora_callcenter_tipo_reporte bt on b.id_tipo_reporte=bt.id_tipo_reporte
	  join v_sucursales s on b.id_sucursal=s.id_sucursal and b.bloque=s.bloque
	 where b.id_bitacora=@id_bitacora
  
 end