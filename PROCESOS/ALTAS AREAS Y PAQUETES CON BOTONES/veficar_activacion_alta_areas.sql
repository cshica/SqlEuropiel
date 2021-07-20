/**********************************************************************************************************************************************************************/
/***********************************************************************ÁREA*******************************************************************************************/
/**********************************************************************************************************************************************************************/
go
--Probar con este ID @IdPackage=MTY1WEB000000056831
--PARA PROBAR:
-- EJECUTAR HASTA LA LINEA 25, DEBE ARROJAR 3 REPORTES, EL PRIMERO CON EL IDPAGAGE, EL 2 VACIO Y EL TERCERO CON 3 VALORES(QUIERE DECIR QUE NO SE HA DADO DE ALTA Y SE DEBE MANDAR EL MENSAJE AL WHATSAPP PARA QUE INICE EL PROCESO)
-- SI NO ESTA EN ESTE ORDEN EL REPORTE, ENTONCES EJECUTAR LAS LINEAS 32  Y 33 PARA QUE SE ELIMINEN LAS ALTAS Y SE PEUDA COMENZAR LA PRUEBA, Y DEBE VER LOS 3 REPORTES COMO SE INDICA EN LA PARTE DE ARRIBA
-- EN EL POSTMAN SE UTILIZA LOS SERVICIOS EN EL SIGUIENTE ORDEN:
    -- http://localhost:4323/api/Callcenter/CheckChatConversationType
    -- http://localhost:4323/api/Callcenter/AltaAreaActivacion
declare	@from varchar(16)='+14159416424'
declare	@to varchar(16)='+5218261065393'
set @to=replace(@to,'+521','+52')

declare @IdPackage varchar(32)

select top 1 @IdPackage = IdPackage
	from rm_europiel_requerimientos.dbo.v_alta_pendiente_activacion (nolock)
	where emisor = @from
	and telefono = replace(@to,'+521','+52')
	order by id desc

select IdPackage=isNull(@IdPackage,'')
select top 100* from rm_europiel_requerimientos.dbo.alta_activacion where id_referencia='MTY1WEB000000056831'  order by fecha_registro asc
-- select top 1  * from rm_europiel_requerimientos.dbo.alta_activacion where id=11530
select * from rm_europiel.dbo.whatsapp_interfaz_altas where telefono like '%+528261065393%'


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- EJECUTAMOS PARA DESACTIVAR LA CONFIRMACION O NEGACION DEL ÁREA
delete from alta_activacion where id_referencia='MTY1WEB000000056831' 
update rm_europiel.dbo.whatsapp_interfaz_altas set fecha_proceso=null,estatus=null,respuesta_cliente=null where id=5169
-- update rm_europiel.dbo.whatsapp_interfaz_altas set fecha_interfaz=cast(GETDATE() as date)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
go
declare @IdPackage varchar(32)

select IdPackage = 'MTY1' + 'WEB' + right('00000000000' + convert(varchar(12), id_alta),12), *
from rm_europiel.dbo.whatsapp_interfaz_altas (nolock)
where emisor = '+14157022948'
and telefono = replace('+5218261065393','+521','+52')
and estatus='Review' --and respuesta_cliente= 'NO ES CORRECTO'
--and cast(fecha_interfaz as date)=cast(GETDATE() as date)
and observaciones2 is null
order by id desc

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---PROCEDURES CREADOS
-- BD : rm_europiel_requerimientos
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
DROP PROC IF EXISTS valida_alta_pendiente_respuesta_cliente;
GO
/**************************************************************************************************************************
CREADO POR: CSHICA 18-05-2021
Objetivo: Retornar los datos del Area dada de alta, para verificar si aun no ha tenido una respuesta Personalizada por el 
cliente. 
	La Columna Tipo tienes 2 valores:
	1=Area 
	2= Paquetes

Es utilizado para el proceso de Respuesta del CLiente Por WhatsApp cuando presiona el Boton "NO ES CORRECTO"
Invocado por el Metodo: 
	CallCenterController/CheckChatConversationType
	|	
	+----------------->callcenter/PermiteContestarClienteAltaArea

************************************************************************************************************************/
CREATE PROCEDURE [dbo].[valida_alta_pendiente_respuesta_cliente] -- valida_alta_pendiente_respuesta_cliente '+14159416424','+528261065393'
(
	@emisor nvarchar(50)
	,@telefono nvarchar(50)
)
AS
BEGIN

	select top 1*,1 tipo from v_alta_pendiente_response where emisor=@emisor and telefono= replace(@telefono,'+521','+52')

END;
/************************************************************************************************************************/
GO
DROP PROC IF EXISTS genera_respuesta_cliente_alta_area;
/**************************************************************************************************************************
CREADO POR: CSHICA 18-05-2021
ESTA VISTA MUESTRA MUESTRA LOS AREAS DE ALTA QUE AUN NO TIENEN COMO ESTATUS 'Review' y RespuestaCliente='NO ES CORRECTO'
Es utilizado para el proceso de Respuesta del CLiente Por WhatsApp cuando presiona el Boton "NO ES CORRECTO"
Invocado por el Metodo: CallCenterController/ResponsClient/ProcesaAltaAreaRespuestaCliente
************************************************************************************************************************/
GO
CREATE PROCEDURE [dbo].[genera_respuesta_cliente_alta_area] --genera_respuesta_cliente_alta_area 'MTY1WEB000000054726','Respuesta de prueba'
(

	@IdPackage NVARCHAR(50)
	,@respuesta nvarchar(1024)
)
AS
BEGIN
	declare @id int,
            @bloque varchar(8)

    select @id=id,
            @bloque=bloque
    from v_alta_pendiente_response
    where IdPackage=@IdPackage

    if @bloque = 'MTY1'
        update rm_europiel.dbo.whatsapp_interfaz_altas set fecha_proceso = getdate(),  respuesta_cliente=@respuesta where id=@id
    else if @bloque = 'MTY2'
        update rm_europiel_mty2.dbo.whatsapp_interfaz_altas set fecha_proceso = getdate(),   respuesta_cliente=@respuesta where id=@id
    else if @bloque = 'SIN1'
        update rm_europiel_guadalajara.dbo.whatsapp_interfaz_altas set fecha_proceso = getdate(),   respuesta_cliente=@respuesta where id=@id
    else if @bloque = 'SIN2'
        update rm_europiel_juarez.dbo.whatsapp_interfaz_altas set fecha_proceso = getdate(),   respuesta_cliente=@respuesta where id=@id
    else if @bloque = 'SIN3'
        update rm_europiel_sinergia3.dbo.whatsapp_interfaz_altas set fecha_proceso = getdate(),   respuesta_cliente=@respuesta where id=@id
    else if @bloque = 'ESP'
        update rm_europiel_espana.dbo.whatsapp_interfaz_altas set fecha_proceso = getdate(),   respuesta_cliente=@respuesta where id=@id
    else if @bloque = 'USA1'
        update rm_europiel_usa1.dbo.whatsapp_interfaz_altas set fecha_proceso = getdate(),   respuesta_cliente=@respuesta where id=@id
    else if @bloque = 'DRP'
        update rm_dermapro.dbo.whatsapp_interfaz_altas set fecha_proceso = getdate(),   respuesta_cliente=@respuesta where id=@id	
END;