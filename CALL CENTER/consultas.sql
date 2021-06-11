--select * from CONFIGURACIONES_MENSAJES_TWILIO
DROP TABLE IF EXISTS CONFIG_TWILIO
CREATE TABLE CONFIG_TWILIO
(
	Id int
	,Codigo int
	,Descripcion NVARCHAR(max)
	,N1 INT
	,N2 INT
	,N3 INT
	,Str1 NVARCHAR(max)
	,Str2 NVARCHAR(max)
	,Str3 NVARCHAR(max)
)
GO
INSERT INTO CONFIG_TWILIO(Id,Codigo,Descripcion,N1)
VALUES (1,1,'1=Activa Call Center, 0= Desactiva Call Center, es invocado desde ',1)
INSERT INTO CONFIG_TWILIO(Id,Codigo,Descripcion,Str1)
values (2,2,'Rol que permite activar o desactivar Call Center','supervisor'),(3,2,'Rol que permite activar o desactivar Call Center','admin')
GO
SELECT * FROM CONFIG_TWILIO
go
DROP PROC IF EXISTS ActivarLlamadasCallCenter
GO
CREATE PROCEDURE ActivarLlamadasCallCenter -- ActivarLlamadasCallCenter 0
(
	@ACCION int
)
AS
BEGIN
	IF @ACCION=0 
	BEGIN
		UPDATE CONFIG_TWILIO SET N1=0 WHERE Id=1 
	END
	IF @ACCION=1
	BEGIN
		UPDATE CONFIG_TWILIO SET N1=1 WHERE Id=1
	END
END
GO
DROP PROC IF EXISTS GetStatusCallCenter
GO
CREATE PROCEDURE GetStatusCallCenter --GetStatusCallCenter
(
	@result bit=0 output
)
AS
BEGIN	

	SET @result=(SELECT N1 FROM CONFIG_TWILIO WHERE Id=1)
	print @result
	return @result
END
GO
DROP PROCEDURE IF EXISTS ValidarRolCallCenter
GO
CREATE PROCEDURE ValidarRolCallCenter -- ValidarRolCallCenter 'admin'
(
	@rol nvarchar(50)
	,@result bit =0 output
)
AS
BEGIN
	IF EXISTS(SELECT * FROM CONFIG_TWILIO where Codigo=2 and Str1=@rol )
		SET @result=1
	ELSE
		SET @result=0

	PRINT @result
	RETURN @result
END
