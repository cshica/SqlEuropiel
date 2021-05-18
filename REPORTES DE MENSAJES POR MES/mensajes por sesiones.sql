--FEBERERO
drop table if exists #tabla
select  *  into #tabla from Paso2_Mayo where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
DECLARE @MES INT =5
--------------------------------------------------------------------------------------------------------------------------------
-- MENSAJES ENVIADOS A NUMEROS DE MEXICO
--------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #NUMEROS_MEXICANOS
DROP TABLE IF EXISTS #NUMEROS_MEXICANOS
SELECT TO_,COUNT(*) NumMsj INTO #NUMEROS_MEXICANOS FROM #tabla WHERE To_ LIKE '%+52%'--  AND TO_ IN('whatsapp:+5214421796730','whatsapp:+525611094794','whatsapp:+524445328089','whatsapp:+5219851149243','whatsapp:+5218712401192','whatsapp:+5216674799717')
GROUP BY TO_
--order by 2 desc
--SELECT * FROM #NUMEROS_MEXICANOS ORDER BY 2 DESC
--------------------------------------------------------------------------------------------------------------------------------
-- MENSAJES ENVIADOS A NUMEROS DE MEXICO
--------------------------------------------------------------------------------------------------------------------------------
--SELECT * FROM #tabla WHERE To_='whatsapp:+525611094794'

--create table #id_teporales (id int)

DECLARE @CONST INT = (SELECT COUNT(*) FROM #NUMEROS_MEXICANOS)
print @CONST
print '-----------------------------------'
WHILE  ((SELECT COUNT(*) FROM #NUMEROS_MEXICANOS)>0 )
BEGIN
	SET @CONST= (SELECT COUNT(*) FROM #NUMEROS_MEXICANOS)
	print  @CONST
	print '**************************************'
    ---------------------------------------------------------------------------------------------------------------------------------
    DECLARE @TELEFONO NVARCHAR(50)=(SELECT TOP 1 TO_ FROM #NUMEROS_MEXICANOS ORDER BY NumMsj DESC)
    ---------------------------------------------------------------------------------------------------------------------------------
    DROP TABLE if exists #TABLA_TEMP
    SELECT ID,TO_ ,DateSent,Price,Status_ INTO #TABLA_TEMP FROM #tabla WHERE TO_=@TELEFONO ORDER BY DateSent ASC

    DROP table if exists  #SESIONES
    SELECT ID,TO_ ,DateSent,Price,Status_,0 SESION INTO #SESIONES FROM #tabla WHERE TO_=@TELEFONO ORDER BY DateSent ASC

    declare @id_sesion int=1
    DECLARE @LIMITE INT =(SELECT COUNT(*) FROM #TABLA_TEMP)
    WHILE (@LIMITE>0)
    BEGIN
		
        DECLARE @FECHA_INI DATETIME=(select min(DateSent) from  #TABLA_TEMP )
        DECLARE @FECHA_FIN DATETIME=DATEADD(HOUR,24,@FECHA_INI) 

		drop table if exists #id_teporales
		select id into #id_teporales from #TABLA_TEMP where ( DateSent BETWEEN @FECHA_INI AND @FECHA_FIN)

		print '-----------------------------------'
		print concat('LIMITE: ',@FECHA_INI,'-',@FECHA_FIN)
		print '-----------------------------------'
		IF(@FECHA_INI IS NULL)SET @LIMITE=0
        IF (@FECHA_INI   IS NOT NULL)
		BEGIN
		   -- UPDATE #SESIONES SET SESION=@id_sesion WHERE ID IN(SELECT ID FROM #TABLA_TEMP WHERE DateSent BETWEEN @FECHA_INI AND @FECHA_FIN)

			--DELETE FROM #TABLA_TEMP WHERE ID IN(SELECT ID FROM #TABLA_TEMP WHERE DateSent BETWEEN @FECHA_INI AND @FECHA_FIN)
			--INSERT INTO MENSAJES_POR_SESIONES
			--SELECT *,@id_sesion FROM #TABLA_TEMP WHERE  ( DateSent BETWEEN @FECHA_INI AND @FECHA_FIN)

			INSERT INTO MENSAJES_POR_SESIONES
			SELECT T.*,@id_sesion,@MES FROM #TABLA_TEMP T WHERE  T.id IN (select id FROM #id_teporales)
		
			DELETE FROM #TABLA_TEMP WHERE ID IN(select id FROM #id_teporales)
			SET @id_sesion=@id_sesion+1
			SET @LIMITE = @LIMITE-1
		END
    END
    --INSERT INTO MENSAJES_POR_SESIONES
    --SELECT * FROM #SESIONES order by DateSent asc

    ---------------------------------------------------------------------------------------------------------------------------------
    -- PRINT CONCAT('ELIMINADO: ', @TELEFONO)
    DELETE FROM #NUMEROS_MEXICANOS WHERE To_=@TELEFONO
   -- SET @CONST   = @CONST -1
    ---------------------------------------------------------------------------------------------------------------------------------
END

select * from MENSAJES_POR_SESIONES

