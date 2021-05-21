-- GUARDA EN LA TABLA TELEFONOS_EVALUAR LOS NUMEROS DE TELEFONOS EN LOS QUE OCURRE MAS DE UN COBRO POR SESION DE 24 HORAS
-- NOTA: PARA EJECUTAR ESTE PROCESO SE DEBE CAMBIAR EL MES Y LA TABLA DEL MES QUE SE VA EVALUAR


-- DROP TABLE IF EXISTS TELEFONOS_EVALUAR
-- CREATE TABLE TELEFONOS_EVALUAR
-- (
-- 	SESION INT
-- 	,PRICE DECIMAL(18,6)
-- 	,FROM_ NVARCHAR(50)
-- 	,TO_ NVARCHAR(50)
-- 	,MES INT
-- )

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #TABLA 
select  TO_,SESION,SUM(Price) Precio,COUNT(*) Mensajes INTO #TABLA
from 
MENSAJES_POR_SESIONES 
where Mes=3 --------------CAMBIAR ACA EL MES

group by TO_,SESION 
order by 1,2,3 desc

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @SESION  INT
DECLARE @TELEFONO VARCHAR(40)
declare @MES INT =3 -----------ESTABLECER EL MES
DECLARE @CONTADOR INT =0
DECLARE @NUM_EJEC INT =
	(
		SELECT COUNT(*) FROM #TABLA 
		WHERE Mensajes>1
		AND Precio!=0
	)
DECLARE CUR1 CURSOR
FOR 
	SELECT TO_,SESION FROM #TABLA 
	WHERE Mensajes>1
	AND Precio!=0

	OPEN CUR1
	FETCH NEXT FROM CUR1 INTO @TELEFONO,@SESION
	WHILE @@FETCH_STATUS=0
	BEGIN
/*****************************************************************************************************************************************************************/
		SET @CONTADOR= @CONTADOR+1
		PRINT '************************************************'
		PRINT CONCAT('EJECUCIÓN: ',@CONTADOR,'/',@NUM_EJEC)
		PRINT '************************************************'
		DROP TABLE IF EXISTS #TABLA1
		DROP TABLE IF EXISTS #TABLA2
		--DECLARE @SESION INT =2
		--DECLARE @TELEFONO VARCHAR(40)='whatsapp:+5212212673813'

		select 
		M.SESION,P.Price,P.From_,P.To_ INTO #TABLA1
/*###*/ from Paso2_marzo P ------------------------ESTABLECER LA TABLA DEL MES CORRESPONDIENTE
		inner join MENSAJES_POR_SESIONES m on p.id=m.ID

		where 
		P.to_=@TELEFONO
		AND M.SESION=@SESION
		and m.Mes=@MES
		order by p.DateSent asc


		select 
		P.From_ ,P.Price INTO #TABLA2
/*###*/	from Paso2_marzo P ------------------------ESTABLECER LA TABLA DEL MES CORRESPONDIENTE
		inner join MENSAJES_POR_SESIONES m on p.id=m.ID
		where 
		P.to_=@TELEFONO
		AND M.SESION=@SESION
		AND P.Price!=0
		and m.Mes=@MES
		order by p.DateSent asc
		--
		--UPDATE #TABLA1 SET Price=1 WHERE Price=0
		--

		DECLARE @NUM_COBROS INT=0

		--SELECT * FROM #TABLA1
		--SELECT * FROM #TABLA2



		DECLARE @TEL NVARCHAR(50)
		DECLARE CUR CURSOR FOR
		SELECT From_ FROM #TABLA2
		OPEN CUR
		FETCH NEXT FROM CUR INTO @TEL

		WHILE @@FETCH_STATUS=0
		BEGIN
	
			SET @NUM_COBROS=( SELECT COUNT(*) FROM #TABLA1 WHERE From_=@TEL AND Price!=0)
			PRINT @NUM_COBROS
			IF @NUM_COBROS>1
			BEGIN
				INSERT INTO TELEFONOS_EVALUAR
				SELECT TOP 1 *,@MES FROM #TABLA1 WHERE From_=@TEL
				BREAK
			END
			FETCH NEXT FROM CUR INTO @TEL
		END
		CLOSE CUR
		DEALLOCATE CUR

		
/*****************************************************************************************************************************************************************/
	FETCH NEXT FROM CUR1 INTO @TELEFONO,@SESION
	END
CLOSE CUR1
DEALLOCATE CUR1