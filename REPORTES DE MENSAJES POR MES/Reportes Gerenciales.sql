-----------------------------------------------------------------------------------------------------------------------
-- ENVIOS DE MENSAJES POR MES
-----------------------------------------------------------------------------------------------------------------------
--ENERO
select sum(isnull(EnviosPorMes,0)) envios ,sum(Costo) monto from PLANTILLA_DETALLE where Mes=1 union 
select count( *),sum(Price)   from Paso2_Enero where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
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
DROP TABLE IF EXISTS #ENERO
select PD.*,G.IdGrupo,G.Descripcion INTO #ENERO from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=1
order by G.IdGrupo

DROP TABLE IF EXISTS #FEBRERO
select PD.*,G.IdGrupo,G.Descripcion INTO #FEBRERO from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=2
order by G.IdGrupo

DROP TABLE IF EXISTS #MARZO
select PD.*,G.IdGrupo,G.Descripcion INTO #MARZO from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=3
order by G.IdGrupo

DROP TABLE IF EXISTS #ABRIL
select PD.*,G.IdGrupo,G.Descripcion INTO #ABRIL from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=4
order by G.IdGrupo

SELECT SUM(EnviosPorMes) MENSAJES ,SUM(Costo) MONTO, Descripcion FROM #ENERO  /*WHERE Descripcion='Confirmación de citas'*/ GROUP BY Descripcion    
union select sum(M.EnviosPorMes),sum(M.Costo), 'Total'  from #ENERO M  order by Descripcion asc 
SELECT SUM(EnviosPorMes) MENSAJES ,SUM(Costo) MONTO, Descripcion FROM #FEBRERO  /*WHERE Descripcion='Confirmación de citas'*/ GROUP BY Descripcion  
union select sum(M.EnviosPorMes),sum(M.Costo), 'Total'  from #FEBRERO M  order by Descripcion asc
SELECT SUM(EnviosPorMes) MENSAJES ,SUM(Costo) MONTO, Descripcion FROM #MARZO    /*WHERE Descripcion='Confirmación de citas'*/ GROUP BY Descripcion  
union select sum(M.EnviosPorMes),sum(M.Costo), 'Total'  from #MARZO M  order by Descripcion asc
SELECT SUM(EnviosPorMes) MENSAJES ,SUM(Costo) MONTO, Descripcion FROM #ABRIL    /*WHERE Descripcion='Confirmación de citas'*/ GROUP BY Descripcion  
union select sum(M.EnviosPorMes),sum(M.Costo), 'Total'  from #ABRIL M order by Descripcion asc   

 