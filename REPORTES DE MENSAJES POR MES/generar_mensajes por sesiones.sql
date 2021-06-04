
DROP TABLE IF EXISTS #MES
select F.id,F.From_,F.To_,F.DateCreated INTO #MES from Paso2_marzo F where
F.From_ IN(SELECT NumeroWhatsapp FROM WhatsappEmisor)
AND  F.Status_ not in ('failed','undelivered')
	AND F.To_ LIKE 'whatsapp:+52%'


	--SELECT * FROM #MES
--------------------------------------------------------------------
DROP TABLE IF EXISTS #TELEFONOS_EVALUAR
SELECT DISTINCT To_ INTO #TELEFONOS_EVALUAR FROM #MES
---------------------------------------------------------------------

drop table if exists #SESIONES
CREATE TABLE #SESIONES (id int,From_ nvarchar(50),To_ nvarchar(50),DateCreated datetime)
DECLARE @TO NVARCHAR(50)--='whatsapp:+526642562773'
declare @cont1 int =0
DECLARE @NUM_EVALUACIONES INT=(SELECT COUNT(*) FROM #TELEFONOS_EVALUAR)
DECLARE CUR CURSOR FOR
	SELECT * FROM #TELEFONOS_EVALUAR
	OPEN CUR
	FETCH NEXT FROM CUR INTO @TO
	WHILE @@FETCH_STATUS=0
	BEGIN
--------------------------------------------------------------------------------------------------------
	PRINT CONCAT('Telefono:',@TO,' # ',@cont1,'/',@NUM_EVALUACIONES)
	PRINT '------------------------------------------------------------'
	DROP TABLE IF EXISTS #SESION_TEMP
	SELECT * INTO #SESION_TEMP FROM #MES
	WHERE To_=@TO
	AND From_ IN(SELECT NumeroWhatsapp FROM WhatsappEmisor)
	/***********************************************************/
	DECLARE @EMISOR NVARCHAR(50)
	DECLARE CUR1 CURSOR FOR 
		SELECT DISTINCT From_ FROM #SESION_TEMP
		OPEN CUR1
		FETCH NEXT FROM CUR1 INTO @EMISOR
		WHILE @@FETCH_STATUS=0
		BEGIN
		DROP TABLE IF EXISTS #SESION_TEMP_1
		SELECT * INTO #SESION_TEMP_1 FROM #SESION_TEMP WHERE From_=@EMISOR
	/***********************************************************/	
			WHILE (SELECT COUNT(*) FROM #SESION_TEMP_1)>0
			BEGIN
				DECLARE @FECHA_INI DATETIME
				DECLARE @FECHA_FIN DATETIME

				SET @FECHA_INI=(SELECT MIN(DateCreated) FROM #SESION_TEMP_1)
				SET @FECHA_FIN=DATEADD(HOUR,24,@FECHA_INI)
				--SELECT * FROM #SESION_TEMP ORDER BY  DateCreated ASC
				--SELECT @FECHA_INI,@FECHA_FIN


				--SELECT * FROM #SESION_TEMP WHERE DateCreated BETWEEN @FECHA_INI AND @FECHA_FIN
				--SELECT top 1 id FROM #SESION_TEMP WHERE DateCreated BETWEEN @FECHA_INI AND @FECHA_FIN 
				--order by DateCreated asc

				insert into #SESIONES
				select * FROM #SESION_TEMP_1 WHERE ID  =(SELECT top 1 id FROM #SESION_TEMP_1 WHERE DateCreated BETWEEN @FECHA_INI AND @FECHA_FIN 
				order by DateCreated asc)

				--select * from #SESIONES
				delete from #SESION_TEMP_1 WHERE DateCreated BETWEEN @FECHA_INI AND @FECHA_FIN 

			END
	/***********************************************************/
		FETCH NEXT FROM CUR1 INTO @EMISOR
		END
		CLOSE CUR1
		DEALLOCATE CUR1
	/***********************************************************/
---------------------------------------------------------------------------------------------------------
	SET @cont1=	@cont1+1
	FETCH NEXT FROM CUR INTO @TO
END
CLOSE CUR
DEALLOCATE CUR


INSERT INTO SESION_POR_MES
select *, 3 MES from #SESIONES 
