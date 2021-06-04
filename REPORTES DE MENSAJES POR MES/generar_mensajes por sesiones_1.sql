--select * from MENSAJES_POR_SESIONES
drop table if exists #MES
select id,From_,To_,DateCreated,Status_,Price,Direction,Sid_ INTO #MES from Paso2_Febrero 
where From_ in (select NumeroWhatsapp from WhatsappEmisor)
and To_ like 'whatsapp:+52%'
and Status_ not in ('failed','undelivered')


SELECT * FROM #MES --MENSAJES A EVALUAR
--------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TELEFONOS
SELECT DISTINCT To_ INTO #TELEFONOS FROM #MES

SELECT * FROM #TELEFONOS -- TELEFONOS QUE SE EVALUAR
--------------------------------------------------------------------------------------------




--DROP TABLE IF EXISTS SESION_MES
--CREATE TABLE SESION_MES (id int,From_ nvarchar(50),To_ nvarchar(50),DateCreated datetime,Status_ nvarchar(50),Price decimal(18,6),Direction nvarchar(50),Sid_ nvarchar(100))

DECLARE @TEL NVARCHAR(50)
DECLARE @CONT INT =1
DECLARE @TOTAL_EVALUAR INT=(SELECT COUNT(*) FROM #TELEFONOS)
DECLARE @FLAG BIT=0

DECLARE CUR CURSOR
FOR SELECT TOP 10 * FROM #TELEFONOS 
OPEN CUR
FETCH NEXT FROM CUR INTO @TEL
WHILE @@FETCH_STATUS=0
BEGIN
---------------------------------------------------------------------------------------------------
	PRINT CONCAT('Telefono: ',@TEL,' ',@CONT,'/',@TOTAL_EVALUAR)
	PRINT '-------------------------------------------------------------'
	IF @FLAG=0
	BEGIN
		DROP TABLE IF EXISTS #MENSAJES
		SELECT * INTO #MENSAJES  FROM #MES WHERE To_=@TEL
		SET @FLAG=1
	END
	PRINT @FLAG
	PRINT '-------------------------------------------------------------'

	DECLARE @FECHA_INI DATETIME
	DECLARE @FECHA_FIN DATETIME

	SET @FECHA_INI=(SELECT MIN(DateCreated) FROM #MENSAJES )
	SET @FECHA_FIN=DATEADD(HOUR,24,@FECHA_INI)

	INSERT INTO SESION_MES
	SELECT TOP 1 *   FROM #MENSAJES WHERE DateCreated BETWEEN @FECHA_INI AND @FECHA_FIN ORDER BY DateCreated ASC
	DELETE FROM #MENSAJES WHERE DateCreated BETWEEN @FECHA_INI AND @FECHA_FIN

	SET @CONT=@CONT+1
	IF(SELECT COUNT(*) FROM #MENSAJES)=0 
	BEGIN
		SET @FLAG=0
	END
	SELECT * FROM #MENSAJES

	SELECT * FROM SESION_MES ORDER BY DateCreated ASC
	SELECT @FECHA_INI,@FECHA_FIN
---------------------------------------------------------------------------------------------------
FETCH NEXT FROM CUR INTO @TEL
END
CLOSE CUR
DEALLOCATE CUR


--SELECT * FROM SESION_MES WHERE To_='whatsapp:+525544728469' ORDER BY DateCreated ASC