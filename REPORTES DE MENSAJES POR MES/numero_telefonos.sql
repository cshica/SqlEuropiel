drop table if exists #tabla;
drop table if exists #TelOrigen;
drop table if exists #TelDestino;

select  From_, count(*) cantidad into #TelOrigen from Paso1_Abril group by From_;
select  To_, count(*) cantidad into #TelDestino from Paso1_Abril group by to_;


create table #tabla
(
	to_ nvarchar(50)
	,from_ nvarchar(50)
	,Direction nvarchar(50)
	,mensajes int
);
insert into #tabla
select to_,from_, Direction,count(*) mensajes from Paso1_Abril where From_ in('whatsapp:+5218261065393','whatsapp:+528261065393')
group by To_,From_,Direction
union all
select to_,from_, Direction,count(*) mensajes from Paso1_Abril where To_ in('whatsapp:+5218261065393','whatsapp:+528261065393')
group by To_,From_,Direction

select * from #tabla

select * from #TelDestino
select * from #TelOrigen


