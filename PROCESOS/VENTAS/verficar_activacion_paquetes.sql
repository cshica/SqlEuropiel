/**********************************************************************************************************************************************************************/
/***********************************************************************PAQUETE****************************************************************************************/
/**********************************************************************************************************************************************************************/
declare	@from varchar(16)='+14159416424'
declare	@to varchar(16)='+5218261065393'


declare @IdPackage varchar(32)

select top 1 @IdPackage = IdPackage
	from rm_europiel_requerimientos.dbo.v_paquete_pendiente_activacion (nolock)
	where emisor = @from
	and telefono = replace(@to,'+521','+52')
	order by id desc

select IdPackage=isNull(@IdPackage,'')
select * from rm_europiel_requerimientos.dbo.paquete_activacion where id_referencia=@IdPackage  order by fecha_registro desc
select * from rm_europiel.dbo.whatsapp_interfaz where telefono='+528261065393' and id_paquete = right(@IdPackage,5)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EJECUTAMOS PARA DESACTIVAR LA CONFIRMACION O NEGACION DEL PAQUETE
update rm_europiel.dbo.whatsapp_interfaz set fecha_proceso=null,estatus=null,respuesta_cliente=null where id=14982


/**********************************************************************************************************************************************************************/
/***********************************************************************ÁREA*******************************************************************************************/
/**********************************************************************************************************************************************************************/
go
--Probar con este ID @IdPackage=MTY1WEB000000054483
declare	@from varchar(16)='+14157022948'
declare	@to varchar(16)='+5218261065393'
set @to=replace(@to,'+521','+52')

declare @IdPackage varchar(32)

select top 1 @IdPackage = IdPackage
	from rm_europiel_requerimientos.dbo.v_alta_pendiente_activacion (nolock)
	where emisor = @from
	and telefono = replace(@to,'+521','+52')
	order by id desc

select IdPackage=isNull(@IdPackage,'')
select top 1 * from rm_europiel_requerimientos.dbo.alta_activacion where id_referencia=@IdPackage  order by fecha_registro desc
select * from rm_europiel.dbo.whatsapp_interfaz_altas where id=3533
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EJECUTAMOS PARA DESACTIVAR LA CONFIRMACION O NEGACION DEL ÁREA
update rm_europiel.dbo.whatsapp_interfaz_altas set fecha_proceso=null,estatus=null,respuesta_cliente=null where id=3533

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
go
declare @IdPackage varchar(32)

select IdPackage = 'MTY1' + 'WEB' + right('00000000000' + convert(varchar(12), id_alta),12), *
from rm_europiel.dbo.whatsapp_interfaz_altas (nolock)
where emisor = '+14157022948'
and telefono = replace('+5218261065393','+521','+52')
and estatus='Review' and respuesta_cliente= 'NO ES CORRECTO'
and cast(fecha_interfaz as date)=cast(GETDATE()-1 as date)
and observaciones2 is null
order by id desc

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---PROCEDURES CREADOS
-- BD : rm_europiel_requerimientos
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
DROP PROC IF EXISTS valida_alta_pendiente_respuesta_cliente;
GO
CREATE PROCEDURE valida_alta_pendiente_respuesta_cliente -- valida_alta_pendiente_respuesta_cliente '+14157022948','+528261065393'
(
	@emisor nvarchar(50)
	,@telefono nvarchar(50)
)
AS
BEGIN
	-- select TOP 1 IdPackage = 'MTY1' + 'WEB' + right('00000000000' + convert(varchar(12), id_alta),12), id,telefono,emisor
	-- from rm_europiel.dbo.whatsapp_interfaz_altas (nolock)
	-- where emisor = @emisor
	-- and telefono = replace(@telefono,'+521','+52')
	-- and estatus='Review' and respuesta_cliente= 'NO ES CORRECTO'
	-- and cast(fecha_interfaz as date)=cast(GETDATE() as date)
	-- and observaciones2 is null
	-- order by id desc

	select *
	from v_alta_pendiente_response (nolock)
	where emisor = @emisor
	and telefono = replace(@telefono,'+521','+52')

END;