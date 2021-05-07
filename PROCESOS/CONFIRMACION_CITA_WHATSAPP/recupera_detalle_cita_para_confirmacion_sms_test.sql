USE [rm_europiel]
GO
/****** Object:  StoredProcedure [dbo].[recupera_detalle_cita_para_confirmacion_sms]    Script Date: 09/04/2021 11:13:17 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
DROP PROCEDURE IF EXISTS [dbo].[recupera_detalle_cita_para_confirmacion_sms_test]
GO
CREATE procedure [dbo].[recupera_detalle_cita_para_confirmacion_sms_test] --recupera_detalle_cita_para_confirmacion_sms_test 1364545,13941,'MTY1'
	@id_cita int,
	@id_paciente int,
	@bloque varchar(32)

as

declare @mensaje varchar(1024), @permitir int=1, @clave_bloque int=0

if @bloque in ('MTY', 'MTY1')
 begin
	select top 1 @clave_bloque=clave_bloque from rm_europiel.dbo.parametro
	select   p.nombre + ' ' + p.ap_paterno + ' ' + p.ap_materno + ',Test Favor de confirmar su cita del ' + 
						dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
						' en la sucursal ' + s.descripcion mensaje,@clave_bloque permitir,@clave_bloque clave_bloque,c.id_cita
	from rm_europiel.dbo.cita c 
	join rm_europiel.dbo.paciente p on p.id_paciente=c.id_paciente
	join rm_europiel.dbo.sucursal s on s.id_sucursal=c.id_sucursal
	where --c.id_cita=@id_cita
	 c.id_paciente=@id_paciente
	--and c.fecha_confirmacion is null
	and id_padre=0
	and c.fecha_inicio > GETDATE()
	
	
 end
else if @bloque='MTY2'
 begin
	select @mensaje = p.nombre + ' ' + p.ap_paterno + ' ' + p.ap_materno + ', Favor de confirmar su cita del ' + 
						dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
						' en la sucursal ' + s.descripcion
	from rm_europiel_mty2.dbo.cita c 
	join rm_europiel_mty2.dbo.paciente p on p.id_paciente=c.id_paciente
	join rm_europiel_mty2.dbo.sucursal s on s.id_sucursal=c.id_sucursal
	where --c.id_cita=@id_cita
	--and 
	c.id_paciente=@id_paciente
	--and c.fecha_confirmacion is null
	--and cast (c.fecha_inicio as date) between cast(GETDATE() as date)  and cast(getdate()+2 as date)
	and c.fecha_inicio > GETDATE()
	and c.id_padre = 0
	order by c.fecha_inicio
	/*where c.id_cita=@id_cita
	and c.id_paciente=@id_paciente
	and c.fecha_confirmacion is null
	and c.fecha_inicio > GETDATE()*/
	
	select top 1 @clave_bloque=clave_bloque from rm_europiel_mty2.dbo.parametro
 end
else if @bloque='SIN1'
 begin
	select @mensaje = p.nombre + ' ' + p.ap_paterno + ' ' + p.ap_materno + ', Favor de confirmar su cita del ' + 
						dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
						' en la sucursal ' + s.descripcion
	from rm_europiel_guadalajara.dbo.cita c 
	join rm_europiel_guadalajara.dbo.paciente p on p.id_paciente=c.id_paciente
	join rm_europiel_guadalajara.dbo.sucursal s on s.id_sucursal=c.id_sucursal
	where c.id_cita=@id_cita
	and c.id_paciente=@id_paciente
	and c.fecha_confirmacion is null
	and c.fecha_inicio > GETDATE()
	
	select top 1 @clave_bloque=clave_bloque from rm_europiel_guadalajara.dbo.parametro
 end
else if @bloque='SIN2'
 begin
	select @mensaje = p.nombre + ' ' + p.ap_paterno + ' ' + p.ap_materno + ', Favor de confirmar su cita del ' + 
						dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
						' en la sucursal ' + s.descripcion
	from rm_europiel_juarez.dbo.cita c 
	join rm_europiel_juarez.dbo.paciente p on p.id_paciente=c.id_paciente
	join rm_europiel_juarez.dbo.sucursal s on s.id_sucursal=c.id_sucursal
	where c.id_cita=@id_cita
	and c.id_paciente=@id_paciente
	and c.fecha_confirmacion is null
	and c.fecha_inicio > GETDATE()
	
	select top 1 @clave_bloque=clave_bloque from rm_europiel_juarez.dbo.parametro
 end
else if @bloque='SIN3'
 begin
	select @mensaje = p.nombre + ' ' + p.ap_paterno + ' ' + p.ap_materno + ', Favor de confirmar su cita del ' + 
						dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
						' en la sucursal ' + s.descripcion
	from rm_europiel_sinergia3.dbo.cita c 
	join rm_europiel_sinergia3.dbo.paciente p on p.id_paciente=c.id_paciente
	join rm_europiel_sinergia3.dbo.sucursal s on s.id_sucursal=c.id_sucursal
	where c.id_cita=@id_cita
	and c.id_paciente=@id_paciente
	and c.fecha_confirmacion is null
	and c.fecha_inicio > GETDATE()
	
	select top 1 @clave_bloque=clave_bloque from rm_europiel_sinergia3.dbo.parametro
 end
else if @bloque='USA1'
 begin
	select @mensaje = p.nombre + ' ' + p.ap_paterno + ' ' + p.ap_materno + ', Favor de confirmar su cita del ' + 
						dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
						' en la sucursal ' + s.descripcion
	from rm_europiel_usa1.dbo.cita c 
	join rm_europiel_usa1.dbo.paciente p on p.id_paciente=c.id_paciente
	join rm_europiel_usa1.dbo.sucursal s on s.id_sucursal=c.id_sucursal
	where c.id_cita=@id_cita
	and c.id_paciente=@id_paciente
	and c.fecha_confirmacion is null
	and c.fecha_inicio > GETDATE()
	
	select top 1 @clave_bloque=clave_bloque from rm_europiel_usa1.dbo.parametro
 end
else if @bloque='ESP'
 begin
	select @mensaje = p.nombre + ' ' + p.ap_paterno + ' ' + p.ap_materno + ', Favor de confirmar su cita del ' + 
						dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
						' en la sucursal ' + s.descripcion
	from rm_europiel_espana.dbo.cita c 
	join rm_europiel_espana.dbo.paciente p on p.id_paciente=c.id_paciente
	join rm_europiel_espana.dbo.sucursal s on s.id_sucursal=c.id_sucursal
	where c.id_cita=@id_cita
	and c.id_paciente=@id_paciente
	and c.fecha_confirmacion is null
	and c.fecha_inicio > GETDATE()
	
	select top 1 @clave_bloque=clave_bloque from rm_europiel_espana.dbo.parametro
 end
--else if @bloque='TEST'
-- begin
--	select @mensaje = p.nombre + ' ' + p.ap_paterno + ' ' + p.ap_materno + ', Favor de confirmar su cita del ' + 
--						dbo.fn_fecha_dia_mes(c.fecha_inicio,1) + ' a las ' + lower(ltrim(right(convert(varchar(32),c.fecha_inicio,100),8))) + 
--						' en la sucursal ' + s.descripcion
--	from rm_europiel_test.dbo.cita c 
--	join rm_europiel_test.dbo.paciente p on p.id_paciente=c.id_paciente
--	join rm_europiel_test.dbo.sucursal s on s.id_sucursal=c.id_sucursal
--	where c.id_cita=@id_cita
--	and c.id_paciente=@id_paciente
--	and c.fecha_confirmacion is null
--	and c.fecha_inicio > GETDATE()
	
--	select top 1 @clave_bloque=clave_bloque from rm_europiel_test.dbo.parametro
-- end 
 
--select @mensaje=ISNULL(@mensaje,'')

--if LEN(@mensaje)=0
--begin
--	select @mensaje='Este link ya expiró o ya fue utilizado previamente', @permitir=0
--end

--select mensaje=@mensaje, permitir=@permitir, clave_bloque=@clave_bloque

