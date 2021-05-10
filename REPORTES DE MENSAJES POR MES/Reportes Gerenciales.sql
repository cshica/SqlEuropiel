-----------------------------------------------------------------------------------------------------------------------
-- ENVIOS DE MENSAJES POR MES
-----------------------------------------------------------------------------------------------------------------------

--FEBRERO
select sum(isnull(EnviosPorMes,0)) envios ,sum(Costo) monto from PLANTILLA_DETALLE where Mes=2 union 
select count( *),sum(Price)   from Paso2_febrero where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
--MARZO
select sum(isnull(EnviosPorMes,0)) envios ,sum(Costo) monto from PLANTILLA_DETALLE where Mes=3 union 
select count( *),sum(Price)   from Paso2_marzo where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
--ABRIL
select sum(isnull(EnviosPorMes,0)) envios ,sum(Costo) monto from PLANTILLA_DETALLE where Mes=4 union 
select count( *),sum(Price)   from Paso2_abril where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)

-----------------------------------------------------------------------------------------------------------------------
-- MENSAJES POR GRUPOS
-----------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #FEBRERO
select PD.*,G.IdGrupo,G.Descripcion INTO #FEBRERO from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=2
order by G.IdGrupo

SELECT SUM(EnviosPorMes),SUM(Costo) FROM #FEBRERO