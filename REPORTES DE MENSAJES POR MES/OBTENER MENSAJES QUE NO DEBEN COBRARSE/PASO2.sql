DECLARE @MES INT=4
DROP TABLE IF EXISTS #TABLA_TELEFONOS_EVALUAR
SELECT distinct TO_ INTO #TABLA_TELEFONOS_EVALUAR FROM TELEFONOS_EVALUAR where MES=@MES

DECLARE @TELEFONO NVARCHAR(50)
DECLARE @NUM_REG INT =0
DECLARE @NUM_EJEC INT=(SELECT COUNT(*) FROM #TABLA_TELEFONOS_EVALUAR)

DECLARE CUR1 CURSOR FOR SELECT  * FROM #TABLA_TELEFONOS_EVALUAR -- PODEMOS HACER UN TOP 10 PARA REALIZAR PRUEBAS
OPEN CUR1
    FETCH NEXT FROM CUR1 INTO @TELEFONO
    WHILE @@FETCH_STATUS=0
    BEGIN
    SET @NUM_REG= @NUM_REG+1
    PRINT '************************************************'
	PRINT CONCAT('EJECUCIÓN: ',@NUM_REG,'/',@NUM_EJEC,'  Telefono: ',@TELEFONO,' MES: ',@MES)
	PRINT '************************************************'
    -----------------------------------------------------------------------------------------------------------------------------------------------------------
        DROP TABLE IF EXISTS #TABLA
        select 
        M.SESION,P.DateSent,P.Body,P.Price,P.To_,P.From_,P.Status_,p.Sid_  INTO #TABLA
        from Paso2_abril P --------------------------------->ESTABLECER LA TABLA DEL MES CORRESPONDIENTE
        inner join MENSAJES_POR_SESIONES m on p.id=m.ID

        where 
        P.to_=@TELEFONO
        and m.Mes=@MES
        order by p.DateSent asc

        DROP TABLE IF EXISTS #TABLA_TELEFONOS
        SELECT DISTINCT From_ INTO #TABLA_TELEFONOS FROM #TABLA
        -- SELECT  * FROM #TABLA ORDER BY DateSent
        -- SELECT * FROM #TABLA_TELEFONOS
        /**********************************************************************************************************************/

        DECLARE @NUM_SESIONES INT = (SELECT MAX(SESION) FROM #TABLA)

        DECLARE @CONT_SESION INT =1
        DECLARE @TELEFONO_EVALUAR NVARCHAR(50)
        DECLARE @SID_MENSAJE NVARCHAR(200)

        DECLARE CUR CURSOR FOR  SELECT * FROM #TABLA_TELEFONOS
            OPEN CUR
                FETCH NEXT FROM CUR INTO @TELEFONO_EVALUAR
                WHILE @@FETCH_STATUS=0
                BEGIN
                    SET @CONT_SESION=0
                    WHILE @CONT_SESION<=@NUM_SESIONES
                    BEGIN
                        
                        PRINT @CONT_SESION
                            -- IF(SELECT COUNT(*) FROM #TABLA WHERE From_=@TELEFONO_EVALUAR AND SESION=@CONT_SESION)>1
                            -- BEGIN
                            
                            --     SET @SID_MENSAJE=(SELECT TOP 1 Sid_ FROM #TABLA WHERE  From_=@TELEFONO_EVALUAR AND SESION=@CONT_SESION ORDER BY DateSent ASC)--OBTENEMOS EL SID_ DEL MENSAJE MAS ANTIGUO
                            --     UPDATE Paso2_abril ------------------------------------------------>ESTABLECER LA TABLA DEL MES CORRESPONDIENTE
                            --     SET Price=Price*(-1) WHERE Sid_=@SID_MENSAJE
                            -- END

                            IF(SELECT COUNT(*) FROM #TABLA WHERE From_=@TELEFONO_EVALUAR AND SESION=@CONT_SESION)=1
                            BEGIN
                            
                                SET @SID_MENSAJE=(SELECT TOP 1 Sid_ FROM #TABLA WHERE  From_=@TELEFONO_EVALUAR AND SESION=@CONT_SESION ORDER BY DateSent ASC)--OBTENEMOS EL SID_ DEL MENSAJE MAS ANTIGUO
                                UPDATE Paso2_abril ------------------------------------------------>ESTABLECER LA TABLA DEL MES CORRESPONDIENTE
                                SET Price=Price*(-1) WHERE Sid_=@SID_MENSAJE
                            END
                            SET @CONT_SESION=@CONT_SESION+1
                    END
                    
                    FETCH NEXT FROM CUR INTO @TELEFONO_EVALUAR
                END
            CLOSE CUR
        DEALLOCATE CUR
    -----------------------------------------------------------------------------------------------------------------------------------------------------------
        FETCH NEXT FROM CUR1 INTO @TELEFONO 
    END
CLOSE CUR1
DEALLOCATE CUR1
SELECT PRICE,* FROM Paso2_abril WHERE TO_='whatsapp:+523312683007' order by DateSent asc