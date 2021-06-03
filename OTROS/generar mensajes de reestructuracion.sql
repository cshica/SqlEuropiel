 /********************************************************PRUEBAS************************************************************/
  DECLARE @TEL_TEST NVARCHAR(50)='+528261065393'
  DECLARE @EMISOR_TEST NVARCHAR(50)='+14159416424'
  DECLARE @NOMBRE_TEST NVARCHAR(50)='CHRISTIAN'
  DECLARE @SALDO_CONVERTIDO_TEST  NVARCHAR(50)='30000.00'
  DECLARE @NUM_PAGOS_TEST INT=6
  DECLARE @PAGOS_CONVERTIDOS_TEST NVARCHAR(50)='500.00'
  DECLARE @PAYLOAD_TEST NVARCHAR(MAX)
  DECLARE @CLAVE_ACCESO_TEST NVARCHAR(50)='081119'
  --PLANTILLA: reestructuracion_botones 
	select @PAYLOAD_TEST = '{
		"type":"whatsapp",
		"device":"' + @TEL_TEST + '",
		"emitter":"' + @EMISOR_TEST + '",
		"environment":"PROD",
		"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",
		"payload":"*¡Felicidades '+@NOMBRE_TEST+'!*\n\nHas sido seleccionado para obtener un *DESCUENTO GRATIS* en el saldo de tu Cuenta con Europiel, actualmente tus pagos de '+@SALDO_CONVERTIDO_TEST+' pueden ser *REDUCIDOS a '+cast(@NUM_PAGOS_TEST as varchar(10))+' quincenas* de tan solo '+@PAGOS_CONVERTIDOS_TEST+'.\n\n¿Te gustaría aprovechar esta oportunidad ahora?"
}'



	print @PAYLOAD_TEST

	insert into rm_europiel_requerimientos.dbo.notifier_mensajes (id_notifier, id_usuario, id_bloque, bloque, telefono, device_token, payload, fecha_envio, ultimo_estatus, 
																	fecha_ultimo_estatus, mobile_os, id_referencia, fecha_alta_registro, clave_acceso, emisor, nombre_cliente)
	values (13,59966,1,'MTY1',@TEL_TEST,null,@PAYLOAD_TEST,null,null,null,'whatsapp',null,getdate(),@CLAVE_ACCESO_TEST, @EMISOR_TEST, @NOMBRE_TEST + ' TEST')


	SELECT * FROM rm_europiel_requerimientos.dbo.notifier_mensajes WHERE id_notifier=13 AND CAST(fecha_alta_registro AS DATE)= CAST(GETDATE()AS DATE) ORDER BY fecha_alta_registro DESC

	--delete from rm_europiel_requerimientos.dbo.notifier_mensajes where id_detalle=15796934

	