drop table if exists #tabla
select  *  into #tabla from Paso2_abril where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
SELECT Body FROM #tabla ORDER BY Body ASC
--Tu OTP es 00184413
--------------------------------------------------------------------------------------------------------------------------------------------
declare @i int=1
declare @id int =1

	declare @filtro nvarchar(max)
	
	DECLARE @ENVIOS INT
	DECLARE @COSTO DECIMAL (18,6)
	declare @limite int =( select max(IdPlantilla)+1 from PLANTILLA)
while (@i<@limite)
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
	INSERT INTO PLANTILLA_DETALLE (IdPlantilla,EnviosPorMes,Mes,Costo) VALUES(@ID,@ENVIOS,4,@COSTO)

	set @i=@i+1
end
