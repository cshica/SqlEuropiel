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



/**************************************************************************************************************************
CREADO POR: CSHICA 18-05-2021
Invocado por el Metodo: CallCenterController/ResponsClient/ProcesaPaqueteRespuestaCliente
************************************************************************************************************************/
DROP PROCEDURE IF EXISTS genera_respuesta_cliente_paquete
GO
CREATE PROCEDURE [dbo].[genera_respuesta_cliente_paquete] 
	@IdPackage varchar(32), 
	@respuesta varchar(1024)
AS

BEGIN

	declare @id int,
			@bloque varchar(8)

	select @id=id,
			@bloque=bloque
	from v_paquete_pendiente_response
	where IdPackage=@IdPackage

	if @bloque = 'MTY1'
		update rm_europiel.dbo.whatsapp_interfaz set fecha_proceso = getdate(),respuesta_cliente=@respuesta where id=@id
	else if @bloque = 'MTY2'
		update rm_europiel_mty2.dbo.whatsapp_interfaz set fecha_proceso = getdate(),respuesta_cliente=@respuesta where id=@id
	else if @bloque = 'SIN1'
		update rm_europiel_guadalajara.dbo.whatsapp_interfaz set fecha_proceso = getdate(),respuesta_cliente=@respuesta where id=@id
	else if @bloque = 'SIN2'
		update rm_europiel_juarez.dbo.whatsapp_interfaz set fecha_proceso = getdate(),respuesta_cliente=@respuesta where id=@id
	else if @bloque = 'SIN3'
		update rm_europiel_sinergia3.dbo.whatsapp_interfaz set fecha_proceso = getdate(),respuesta_cliente=@respuesta where id=@id
	else if @bloque = 'ESP'
		update rm_europiel_espana.dbo.whatsapp_interfaz set fecha_proceso = getdate(),respuesta_cliente=@respuesta where id=@id
	else if @bloque = 'USA1'
		update rm_europiel_usa1.dbo.whatsapp_interfaz set fecha_proceso = getdate(),respuesta_cliente=@respuesta where id=@id
	else if @bloque = 'DRP'
	update rm_dermapro.dbo.whatsapp_interfaz set fecha_proceso = getdate(),respuesta_cliente=@respuesta where id=@id
END
GO
/**************************************************************************************************************************
CREADO POR: CSHICA 24-05-2021
Objetivo: Retornar los datos del Area dada de alta, para verificar si aun no ha tenido una respuesta Personalizada por el 
cliente. 
	La Columna Tipo tienes 2 valores:
	1=Area 
	2= Paquetes

Es utilizado para el proceso de Respuesta del CLiente Por WhatsApp cuando presiona el Boton "NO ES CORRECTO"
Invocado por el Metodo: 
	CallCenterController/CheckChatConversationType
	|	
	+----------------->callcenter/PermiteContestarClienteActivacionPaquete

************************************************************************************************************************/
DROP PROCEDURE IF EXISTS valida_paquete_pendiente_respuesta_cliente
GO
CREATE PROCEDURE [dbo].[valida_paquete_pendiente_respuesta_cliente] -- valida_paquete_pendiente_respuesta_cliente '+14159416424' ,'+528261065393'
(
	@emisor nvarchar(50)
	,@telefono nvarchar(50)
)
AS
BEGIN

	select top 1*,2 tipo from v_paquete_pendiente_response where emisor=@emisor and telefono= replace(@telefono,'+521','+52')

END;


