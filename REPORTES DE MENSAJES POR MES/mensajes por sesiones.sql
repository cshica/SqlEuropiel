--FEBERERO
drop table if exists #tabla
select  *  into #tabla from Paso2_Febrero where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
--------------------------------------------------------------------------------------------------------------------------------
-- MENSAJES ENVIADOS A NUMEROS DE MEXICO
--------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #NUMEROS_MEXICANOS
SELECT TO_,COUNT(*) NumMsj INTO #NUMEROS_MEXICANOS FROM #tabla WHERE To_ LIKE '%+52%'  
GROUP BY TO_
order by 2 desc
SELECT * FROM #NUMEROS_MEXICANOS ORDER BY 2 DESC
--------------------------------------------------------------------------------------------------------------------------------
-- MENSAJES ENVIADOS A NUMEROS DE MEXICO
--------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TABLA_TEMP
SELECT ID,TO_ ,DateSent,Price,Status_,0 SESION INTO #TABLA_TEMP FROM #tabla WHERE TO_='whatsapp:+5214421796730' ORDER BY DateSent ASC

drop table if exists #SESIONES
SELECT ID,TO_ ,DateSent,Price,Status_,0 SESION INTO #SESIONES FROM #tabla WHERE TO_='whatsapp:+5214421796730' ORDER BY DateSent ASC

declare @id_sesion int=1

WHILE ((SELECT COUNT(*) FROM #TABLA_TEMP)>0)
BEGIN
    DECLARE @FECHA_INI DATETIME=(select min(DateSent) from  #TABLA_TEMP where SESION=0 )
    DECLARE @FECHA_FIN DATETIME=DATEADD(HOUR,24,@FECHA_INI) 
    
    UPDATE #SESIONES SET SESION=@id_sesion WHERE ID IN(SELECT ID FROM #TABLA_TEMP WHERE DateSent BETWEEN @FECHA_INI AND @FECHA_FIN)

    DELETE FROM #TABLA_TEMP WHERE ID IN(SELECT ID FROM #TABLA_TEMP WHERE DateSent BETWEEN @FECHA_INI AND @FECHA_FIN)

    SET @id_sesion=@id_sesion+1
END

SELECT * FROM #SESIONES order by DateSent asc
---------------------------------------------------------------------------------------------------------------------------------

--FEBERERO
drop table if exists #tabla
select  *  into #tabla from Paso2_Febrero where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
--------------------------------------------------------------------------------------------------------------------------------
-- MENSAJES ENVIADOS A NUMEROS DE MEXICO
--------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #NUMEROS_MEXICANOS
SELECT TO_,COUNT(*) NumMsj INTO #NUMEROS_MEXICANOS FROM #tabla WHERE To_ LIKE '%+52%'  
GROUP BY TO_
order by 2 desc
SELECT * FROM #NUMEROS_MEXICANOS ORDER BY 2 DESC
--------------------------------------------------------------------------------------------------------------------------------
-- MENSAJES ENVIADOS A NUMEROS DE MEXICO
--------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TABLA_TEMP
SELECT  ID,TO_ ,DateSent,Price,Status_,0 SESION INTO #TABLA_TEMP FROM #tabla 

drop table if exists #SESIONES
SELECT ID,TO_ ,DateSent,Price,Status_,0 SESION INTO #SESIONES FROM #tabla  
declare @numeros int=(select count(*) from #NUMEROS_MEXICANOS)
WHILE (@numeros>0)
begin
    declare @telefono varchar(50)=(select to_ from #NUMEROS_MEXICANOS where NumMsj=(select max(NumMsj) from #NUMEROS_MEXICANOS))
    

        declare @id_sesion int=1

        WHILE (isnull((SELECT COUNT(*) FROM #TABLA_TEMP where To_=@telefono),0)!=0)
        BEGIN
            declare @imprime int= (SELECT COUNT(*) FROM #TABLA_TEMP where To_=@telefono)
            --print concat('---> ',@imprime)
            DECLARE @FECHA_INI DATETIME=(select min(DateSent) from  #TABLA_TEMP where SESION=0 and To_=@telefono )
            DECLARE @FECHA_FIN DATETIME=DATEADD(HOUR,24,@FECHA_INI) 
            print @FECHA_INI
            print @FECHA_FIN
            print @telefono
            print @id_sesion
            
            UPDATE #SESIONES SET SESION=@id_sesion WHERE 
            ID IN(
                    SELECT ID FROM #TABLA_TEMP
                    WHERE 
                    (DateSent BETWEEN @FECHA_INI AND @FECHA_FIN) 
                    and To_ =@telefono
                )

             DELETE FROM #TABLA_TEMP WHERE ID IN(SELECT ID FROM #TABLA_TEMP WHERE DateSent BETWEEN @FECHA_INI AND @FECHA_FIN) and To_=@telefono
            print concat('borrado ',@id_sesion)
            SET @id_sesion=@id_sesion+1
        END
    delete from #NUMEROS_MEXICANOS where NumMsj=@telefono
    set  @numeros= (select count(*) from #NUMEROS_MEXICANOS)
end

SELECT * FROM #SESIONES where SESION=3 order by SESION desc
select * from #TABLA_TEMP WHERE ID IN(SELECT ID FROM #SESIONES WHERE SESION>0)
select sesion,count(*) from #SESIONES where To_='whatsapp:+524445328089' group by SESION




