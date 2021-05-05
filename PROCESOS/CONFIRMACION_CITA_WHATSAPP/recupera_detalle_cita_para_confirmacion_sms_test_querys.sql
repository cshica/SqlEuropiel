	declare @id_cita int =1364545
	declare @id_paciente int=13941
	declare @bloque varchar(32)='MTY1'

declare @mensaje varchar(1024), @permitir int=1, @clave_bloque int=0

select   p.nombre + ' ' + p.ap_paterno + ' ' + p.ap_materno + ', Favor de confirmar su cita del ' + 
						dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
						' en la sucursal ' + s.descripcion,c.id_padre,*
	from rm_europiel.dbo.cita c 
	join rm_europiel.dbo.paciente p on p.id_paciente=c.id_paciente
	join rm_europiel.dbo.sucursal s on s.id_sucursal=c.id_sucursal
	where --c.id_cita=@id_cita
	--and 
	c.id_paciente=@id_paciente
	--and c.fecha_confirmacion is null
	--and cast (c.fecha_inicio as date) between cast(GETDATE() as date)  and cast(getdate()+2 as date)
	and c.fecha_inicio > GETDATE()
	--select @mensaje
	--and c.id_padre = 0
	order by c.fecha_inicio
	/***************************************************************/

	select id_cita, c.id_paciente, c.fecha_inicio, c.fecha_fin, c.id_sucursal, s.descripcion,
			(case when c.fecha_confirmacion is null then 0 else 1 end),
			c.fecha_confirmacion,
			c.tipo_confirmacion
	from cita c
	join sucursal s on s.id_sucursal = c.id_sucursal
	join paciente pa on pa.id_paciente = c.id_paciente
	where c.estatus <> 'B'
	and CAST(c.fecha_inicio AS DATE) >getdate()
	--and pa.version_api in (3)
	and c.id_padre = 0
	and c.id_paciente=@id_paciente
	--and c.fecha_confirmacion is null
	order by c.id_cita


	select clave_bloque,* from rm_europiel_mty2.dbo.parametro