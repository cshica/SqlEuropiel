drop table if exists #tabla
select  *  into #tabla from Paso2_Enero where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
SELECT Body FROM #tabla where Body like '%fue cancelada por error, por favor haz caso omiso a dicha cancelación y acude a tu cita como estaba originalmente programado, te esperamos para atenderte lo mejor posible!.' ORDER BY Body ASC
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
    if not exists(select * from PLANTILLA_DETALLE where IdPlantilla=@i)
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
        INSERT INTO PLANTILLA_DETALLE (IdPlantilla,EnviosPorMes,Mes,Costo) VALUES(@ID,isnull(@ENVIOS,0),1,isnull(@COSTO,0))
    end
	set @i=@i+1
end
