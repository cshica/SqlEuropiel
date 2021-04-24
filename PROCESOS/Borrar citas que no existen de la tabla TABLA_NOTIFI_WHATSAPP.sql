/*
drop table if exists #citas_duplicadas
go
WITH    paso1 as
(
	--obtenenmos todas los pacientes con citas duplicadas
		SELECT id_paciente,count(*) num  from TABLA_NOTIFI_WHATSAPP group by id_paciente having count(*)>1-- order by id_paciente desc
	
)
--OBTENGO TODAS LAS CITAS DUPLICADAS DE LOS PACIENTES Y LAS GUARDO EN UNA TABLA TEMPORAL #citas_duplicadas
SELECT m.* into #citas_duplicadas FROM TABLA_NOTIFI_WHATSAPP m
right join paso1 p on p.id_paciente=m.id_paciente
go
select * from #citas_duplicadas


--borramos de las citas que existen en la tabla cita
--para dejar solo las que no existen y luego borrarlas de la tabla TABLA_NOTIFI_WHATSAPP
delete from #citas_duplicadas where id_cita   in
(
	--estas son las sitas que si existen en la tabla cita
	select c.id_cita from CITA C
	inner join #citas_duplicadas cd on c.id_cita=cd.id_cita
	and c.estatus <> 'B'
)
--FINALMENTE BORRO DE LA TABLA TABLA_NOTIFI_WHATSAPP , LAS CITAS QUE NO EXISTEN EN LA TABLA CITA
delete from TABLA_NOTIFI_WHATSAPP where id_cita in
(
select id_cita from #citas_duplicadas
)

*/
SELECT id_paciente, COUNT(*) from TABLA_NOTIFI_WHATSAPP group by id_paciente having count(*)>1 order by id_paciente desc
drop table if exists #citas_duplicadas
drop table if exists #TABLA_PACIENTES_CON_CITA_DUPLCIADA


	--obtenenmos todas los pacientes con citas duplicadas
SELECT id_paciente,count(*) num  INTO #TABLA_PACIENTES_CON_CITA_DUPLCIADA from TABLA_NOTIFI_WHATSAPP group by id_paciente having count(*)>1-- order by id_paciente desc
	
--select * from #TABLA_PACIENTES_CON_CITA_DUPLCIADA
--OBTENGO TODAS LAS CITAS DUPLICADAS DE LOS PACIENTES Y LAS GUARDO EN UNA TABLA TEMPORAL #citas_duplicadas
SELECT m.* into #citas_duplicadas FROM TABLA_NOTIFI_WHATSAPP m
right join #TABLA_PACIENTES_CON_CITA_DUPLCIADA p on p.id_paciente=m.id_paciente

select * from #citas_duplicadas order by id_paciente
--borramos de las citas que existen en la tabla cita
--para dejar solo las que no existen y luego borrarlas de la tabla TABLA_NOTIFI_WHATSAPP
delete from #citas_duplicadas where id_cita   in
(
	--estas son las sitas que si existen en la tabla cita
	select c.id_cita from CITA C
	inner join #citas_duplicadas cd on c.id_cita=cd.id_cita
	and c.estatus <> 'B'
)
--FINALMENTE BORRO DE LA TABLA TABLA_NOTIFI_WHATSAPP , LAS CITAS QUE NO EXISTEN EN LA TABLA CITA
delete from TABLA_NOTIFI_WHATSAPP where id_cita in
(
select id_cita from #citas_duplicadas
)

