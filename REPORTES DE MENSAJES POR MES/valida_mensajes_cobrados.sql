select  TO_,SESION,SUM(Price) Precio,COUNT(*) Mensajes INTO #TABLA
from 
MENSAJES_POR_SESIONES 
where Mes=4 
--AND Price!=0
group by TO_,SESION 
order by 1,2,3 desc

SELECT * FROM #TABLA 
WHERE Mensajes>1
AND Precio!=0
order by 1,2,3 desc

--select * from MENSAJES_POR_SESIONES where TO_='whatsapp:+529997494694'


select DISTINCT TO_
from 
MENSAJES_POR_SESIONES 
where Mes=4 

order by 1 desc

-----------------------------------------------------------------------------------------------------------
--PARA VERIFICAR EL NUMERO DE TELEFONO CONSULTADO
select 
M.SESION,P.DateSent,P.Body,P.Price,P.To_,P.From_,P.Status_  
from Paso2_abril P
inner join MENSAJES_POR_SESIONES m on p.id=m.ID

where 
P.to_='whatsapp:+529212298501' 
--or p.From_='whatsapp:+529997494694' 
and m.Mes=4
order by p.DateSent asc


-----------------------------------------------------------------------------------------------------------










select  TO_,SESION,SUM(Price) Precio,COUNT(*) Mensajes INTO #TABLA
from 
MENSAJES_POR_SESIONES 
where Mes=4 
--AND Price!=0
group by TO_,SESION 
order by 1,2,3 desc

SELECT * FROM #TABLA 
WHERE Mensajes>1
AND Precio!=0
--order by 1,2,3 desc

----------------------------------------------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
DECLARE @SESION INT =2
DECLARE @TELEFONO VARCHAR(40)
DECLARE CUR1 CURSOR
FOR 
	SELECT TO_,SESION FROM #TABLA 
	WHERE Mensajes>1
	AND Precio!=0

	OPEN CUR1
	FETCH NEXT FROM CUR1 INTO @TELFONO,@SESION
	WHILE @@FETCH_STATUS=0
	BEGIN
/*****************************************************************************************************************************************************************/
		DROP TABLE IF EXISTS #TABLA1
		DROP TABLE IF EXISTS #TABLA2
		--DECLARE @SESION INT =2
		--DECLARE @TELEFONO VARCHAR(40)='whatsapp:+5212212673813'

		select 
		M.SESION,P.Price,P.From_,P.To_,0 ERROR INTO #TABLA1
		from Paso2_abril P
		inner join MENSAJES_POR_SESIONES m on p.id=m.ID

		where 
		P.to_=@TELEFONO
		AND M.SESION=@SESION
		and m.Mes=4
		order by p.DateSent asc


		select 
		P.From_ ,P.Price INTO #TABLA2
		from Paso2_abril P
		inner join MENSAJES_POR_SESIONES m on p.id=m.ID
		where 
		P.to_=@TELEFONO
		AND M.SESION=@SESION
		AND P.Price!=0
		and m.Mes=4
		order by p.DateSent asc
		--
		--UPDATE #TABLA1 SET Price=1 WHERE Price=0
		--

		DECLARE @NUM_COBROS INT=0

		SELECT * FROM #TABLA1
		SELECT * FROM #TABLA2



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
				UPDATE #TABLA1 SET ERROR=1
				BREAK
			END
			FETCH NEXT FROM CUR INTO @TEL
		END
		CLOSE CUR
		DEALLOCATE CUR

		
/*****************************************************************************************************************************************************************/
	FETCH NEXT FROM CUR1 INTO @TELFONO,@SESION
	END
CLOSE CUR1
DEALLOCATE CUR1