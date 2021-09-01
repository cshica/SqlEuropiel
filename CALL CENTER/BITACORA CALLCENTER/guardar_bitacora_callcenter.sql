USE [rm_europiel_requerimientos]
GO
/****** Object:  StoredProcedure [dbo].[guardar_bitacora_callcenter]    Script Date: 30/08/2021 07:10:18 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER procedure [dbo].[guardar_bitacora_callcenter](
@id_bitacora int,
@id_usuario int,
@id_paciente int,
@id_tipo_reporte int,
@observaciones varchar(max),
@bloque varchar(10),
@id_sucursal int,
@id_agente varchar(64),
@agente varchar(64),
@id_prioridad int,
@estatus int,
@id_cliente_callcenter varchar(50)
)
as
 BEGIN
	
	--Si se pierde el id asignar el usuario de Iramm
	IF @id_usuario = 0 SET @id_usuario = 71226
	IF @bloque = 'ESP1' OR @bloque = 'ESP2' SET @bloque = 'ESP'


	declare @folio varchar(50), @fecha_registro datetime, @fecha_vencimiento datetime, @id int

	set @fecha_registro = getdate()
	set @fecha_vencimiento = dateadd(hour, 4, @fecha_registro)

	if @id_bitacora = -1
		begin
			set @folio = (select 'TW' + cast(count(*) + 1 as varchar(30)) from bitacora_callcenter where folio is not null)--dbo.fn_genera_folio(5)

			insert into bitacora_callcenter(id_paciente, id_tipo_reporte, observaciones, fecha_registro, bloque, id_sucursal, id_agente, agente, id_prioridad, estatus, id_cliente_callcenter, tipo,
											fecha_vencimiento,folio)
									 values(@id_paciente, @id_tipo_reporte, @observaciones, @fecha_registro, @bloque, @id_sucursal, @id_agente, @agente, @id_prioridad, @estatus, @id_cliente_callcenter, 'C',
									        @fecha_vencimiento,@folio)

		end
	else
		begin

			update bitacora_callcenter
			set    id_tipo_reporte=@id_tipo_reporte, 
				   observaciones=@observaciones, 
				   bloque=@bloque, 
				   id_sucursal=@id_sucursal, 
				   id_agente=@id_agente,
				   agente=@agente, 
				   id_prioridad=@id_prioridad, 
				   estatus=@estatus,
				   id_cliente_callcenter=@id_cliente_callcenter
			 where id_bitacora=@id_bitacora

		end

		if @estatus = 5
			begin
				set @id = @@identity
				if @id_bitacora > 0
					begin
						set @folio = ('TW' + cast(@id_bitacora as varchar(50)))
					end				

				if not exists (select 1 from incidencias where folio=@folio)
					begin
						insert into incidencias(fecha_registro,tipo_incidencia,id_usuario_alta,id_sucursal,bloque,id_paciente,
						                canal,tipo_queja,observaciones1,observaciones2,estatus, folio, telefono, url_red_social, 
										fecha_vencimiento)
								 values(@fecha_registro,1,@id_usuario,@id_sucursal,@bloque,@id_paciente,
						                5,@id_tipo_reporte,@observaciones,'',4,@folio,'','',@fecha_vencimiento)

					end

				update bitacora_callcenter
				   set estatus=3
				where id_bitacora=@id

			end

 end





