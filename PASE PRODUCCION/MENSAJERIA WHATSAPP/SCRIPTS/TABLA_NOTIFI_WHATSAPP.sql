	DROP TABLE IF EXISTS TABLA_NOTIFI_WHATSAPP
	CREATE TABLE TABLA_NOTIFI_WHATSAPP
	(	id INT
		,id_cita int
		,id_paciente int
		,fecha_inicio datetime
		,id_sucursal int
		,sucursal varchar(100)
		,confirmada int
		,fecha_confirmacion datetime
		,tipo_confirmacion varchar(20)
		,paciente varchar(50)
		,telefono nvarchar(30)
		,envio_confirmar datetime --48 HORAS ANTES
		,envio_recordatorio1 datetime--24 HORAS ANTES
		,envio_recordatorio2 datetime--3 HORAS ANTES
		,enviado bit
		,recordado1 bit
		,recordado2 bit
	 ,HORA_EJECUCION DATETIME
	)
GO
DROP TABLE IF EXISTS TEMPORAL_TABLE_ENVIOS
CREATE TABLE TEMPORAL_TABLE_ENVIOS
	(
		ID INT
		,ID_PACIENTE INT
		,MENSAJE VARCHAR(MAX)
		,FECHA_ENVIO DATETIME
	)
GO