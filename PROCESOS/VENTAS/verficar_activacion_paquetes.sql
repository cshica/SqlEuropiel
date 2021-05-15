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
select * from rm_europiel_requerimientos.dbo.alta_activacion where id_referencia=@IdPackage  order by fecha_registro desc
select * from rm_europiel.dbo.whatsapp_interfaz_altas where telefono=@to and id_alta = right(@IdPackage,5)
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EJECUTAMOS PARA DESACTIVAR LA CONFIRMACION O NEGACION DEL ÁREA
update rm_europiel.dbo.whatsapp_interfaz_altas set fecha_proceso=null,estatus=null,respuesta_cliente=null where id=3533
