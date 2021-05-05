drop table if exists notifier_control_mensajes_repetidos
create table notifier_control_mensajes_repetidos
(
	id int
	,_from nvarchar(50)
	,_to nvarchar(50)
	,msg nvarchar(max)
	,fecha_hora datetime
	,Estado bit
)
go
drop procedure if exists BloquearMsgAutomaticos
go
CREATE PROCEDURE BloquearMsgAutomaticos
(
	@emisor nvarchar(50)
	,@receptor nvarchar(50)
	,@msg nvarchar(max)
	,@result int=0 output
)
AS
BEGIN
--	SELECT * FROM notifier_control_mensajes_repetidos
	IF EXISTS 
	(
		SELECT * FROM notifier_control_mensajes_repetidos 
		WHERE _from=@emisor 
		AND _to=@receptor
		AND CAST(fecha_hora AS DATE)= CAST(GETDATE() AS DATE) 
		--AND Estado=0
	)
	BEGIN
		UPDATE notifier_control_mensajes_repetidos
		SET Estado =1
		WHERE _from=@emisor 
		AND _to=@receptor
		AND CAST(fecha_hora AS DATE)= CAST(GETDATE() AS DATE) 

		set @result=1
	END
	ELSE
	BEGIN
		DECLARE @ID INT =(SELECT isnull(MAX(id),0)+1 FROM notifier_control_mensajes_repetidos)
		INSERT INTO notifier_control_mensajes_repetidos
		VALUES
		(
			@ID
			,@emisor
			,@receptor
			,@msg
			,GETDATE()
			,0
		)
		set @result=0
	END
	RETURN @result

END
truncate table notifier_control_mensajes_repetidos
select * from notifier_control_mensajes_repetidos order by id desc
