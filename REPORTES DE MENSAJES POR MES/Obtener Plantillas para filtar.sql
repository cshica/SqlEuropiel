-- PASO 1
-- Guardamos en una tabla temporal, los vmensajes que fueron enviados por los numeros telefonicos
drop table if exists #tabla
select  *  into #tabla from Paso2_Mayo where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
--------------------------------------------------------------------------------------------------------------------------------------------
-- PASO 2
-- Obenemos todos los mensajes para elegir uno por uno los FILTROS a buscar
SELECT Body FROM #tabla ORDER BY Body ASC
--Tu OTP es 00184413
--------------------------------------------------------------------------------------------------------------------------------------------
-- Hola ABDE MALDONADOEUROPIEL TE DA LA *BIENVENIDA*Por favor descarga nuestra APP desde el siguiente enlace http://cita.europiel.com.mx/app/Download
--PASO 3
declare @id int =1
declare @filtro nvarchar(max)='Probando desde Node.js%'
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
	INSERT INTO PLANTILLA_DETALLE (IdPlantilla,EnviosPorMes,Mes,Costo) VALUES(@ID,@ENVIOS,5,@COSTO)-- el valor 4 indica que es el mes 4 (abril)
-- VOLVER AL PASO 2, hasta que la tabla temporal #tabla, quede vacial