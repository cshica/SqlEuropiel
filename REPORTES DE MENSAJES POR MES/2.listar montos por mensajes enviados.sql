---------------ESTE SCRIP CLASIFICA LOS MENSAJES SGUN LAS PLANTILLAS, SOLO NECECITAMOS PONER EL NOMBRE DE LA TABLA Y EL NUMERO DEL MES
-- ESTE SE USA DESPUES DE OBTENER LOS DATOS DE TWILIO.
-- DESPÙES DE ESTO SE PEUDEN SACAR LOS REPORTES ESTADISTICOS
-- LUEGO DE CORRER LA PRIMERA PARTE DEL SCRIP, VERIFICAR EN NO HAY DATOS EN LA TABLA #tabla.
-- EN CASO DE QUE QUEDEN DATOS EN ESTA TABLA, SE DEBE PROCEDER CON EL SCRIP DE ABAJO, PARA CALSIFICAR LOS MENSAJES EN GRUPOS

drop table if exists #tabla
select  *  into #tabla from Paso2_Diciembre2020 where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
--SELECT Body FROM #tabla where Body like 'Hola!, tu cita para depilarte se aproxima%' ORDER BY Body ASC
--Tu OTP es 00184413
--------------------------------------------------------------------------------------------------------------------------------------------
declare @i int=1
declare @id int =1
DECLARE @MES INT=-12

	declare @filtro nvarchar(max)
	
	DECLARE @ENVIOS INT
	DECLARE @COSTO DECIMAL (18,6)
	declare @limite int =( select max(IdPlantilla)+1 from PLANTILLA)
while (@i<@limite)
begin
    print @i
    if not exists(select * from PLANTILLA_DETALLE where IdPlantilla=@i AND MES=@MES)
    begin
        set @filtro =(select Body from PLANTILLA where IdPlantilla=@i)

        drop table if exists #tabla_total
        select  body, count(*) cantidad ,abs(sum(Price)) precio into #tabla_total from #tabla  
        where    
        Body like @filtro
        group by Body
        order by body asc

        --select * from #tabla_total
        select @ENVIOS= sum(cantidad),@COSTO= sum(precio) from #tabla_total


        delete from #tabla where Body like @filtro
        --INSERT INTO PLANTILLA (Body) VALUES (@filtro)
        SET @id=@i
        if exists(select * from PLANTILLA_DETALLE where IdPlantilla=@id AND Mes=@MES)
        BEGIN   
            UPDATE PLANTILLA_DETALLE SET EnviosPorMes=isnull(@ENVIOS,0), Costo=isnull(@COSTO,0) WHERE Mes=@MES
        END
        ELSE
        BEGIN
            INSERT INTO PLANTILLA_DETALLE (IdPlantilla,EnviosPorMes,Mes,Costo) VALUES(@ID,isnull(@ENVIOS,0),@MES,isnull(@COSTO,0))
        END
    end
	set @i=@i+1
end

SELECT * FROM PLANTILLA_DETALLE WHERE Mes=-12
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GO
--update #tabla set body =concat('[REESTRUCTURACION]',Body)--esto es para concatenar todos los mensajes que no estan identificados, le ponemos un identificador[REESTRUCTURACION] para luego agruparlos
SELECT Body FROM #tabla ORDER BY Body ASC
-- SELECT Body,direction FROM #tabla WHERE BODY LIKE '%[REESTRUCTURACION]%'
declare @id int =1
declare @filtro nvarchar(max)='%[REESTRUCTURACION]%'
DECLARE @ENVIOS INT
DECLARE @COSTO DECIMAL (18,6)
--Obtenemos la cantidad de veces que se repite el filtro y lo guardamos en una tabla temporal
	drop table if exists #tabla_total
	select  body, count(*) cantidad ,abs(sum(Price)) precio into #tabla_total from #tabla  
	where    
	Body like @filtro
	group by Body
	order by body asc

	--select * from #tabla_total

    select @ENVIOS= sum(cantidad),@COSTO= sum(precio) from #tabla_total
select @ENVIOS
-- borramos de la tabla global, todos los mensajes que tenian el filtro buscado
	delete from #tabla where Body like @filtro

-- Insertamos en la tabla PLANTILLA, el filtro que hemos utilizado
	INSERT INTO PLANTILLA (Body) VALUES (@filtro)
-- Insertamos en la tabla PLANTILLA_DETALLE, la cantidad de envios y la suma de costo que hemos obtenido 
-- anteriormente
	SET @id=(SELECT MAX(IdPlantilla) FROM PLANTILLA)
	INSERT INTO PLANTILLA_DETALLE (IdPlantilla,EnviosPorMes,Mes,Costo) VALUES(@ID,@ENVIOS,6,@COSTO)-- el valor 4 indica que es el mes 4 (abril)
-- VOLVER AL REALIZAR EL FILTRO, hasta que la tabla temporal #tabla, quede vacial