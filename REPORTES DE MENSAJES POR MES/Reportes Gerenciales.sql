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
--MAYO
select sum(isnull(EnviosPorMes,0)) envios ,sum(Costo) monto from PLANTILLA_DETALLE where Mes=5 union 
select count( *),sum(Price)   from Paso2_mAYO where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
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

DROP TABLE IF EXISTS #MAYO
select PD.*,G.IdGrupo,G.Descripcion INTO #MAYO from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=5
order by G.IdGrupo

SELECT SUM(EnviosPorMes) MENSAJES ,SUM(Costo) MONTO, Descripcion FROM #ENERO  /*WHERE Descripcion='Confirmación de citas'*/ GROUP BY Descripcion    
union select sum(M.EnviosPorMes),sum(M.Costo), 'Total'  from #ENERO M  order by Descripcion asc 
SELECT SUM(EnviosPorMes) MENSAJES ,SUM(Costo) MONTO, Descripcion FROM #FEBRERO  /*WHERE Descripcion='Confirmación de citas'*/ GROUP BY Descripcion  
union select sum(M.EnviosPorMes),sum(M.Costo), 'Total'  from #FEBRERO M  order by Descripcion asc
SELECT SUM(EnviosPorMes) MENSAJES ,SUM(Costo) MONTO, Descripcion FROM #MARZO    /*WHERE Descripcion='Confirmación de citas'*/ GROUP BY Descripcion  
union select sum(M.EnviosPorMes),sum(M.Costo), 'Total'  from #MARZO M  order by Descripcion asc
SELECT SUM(EnviosPorMes) MENSAJES ,SUM(Costo) MONTO, Descripcion FROM #ABRIL    /*WHERE Descripcion='Confirmación de citas'*/ GROUP BY Descripcion  
union select sum(M.EnviosPorMes),sum(M.Costo), 'Total'  from #ABRIL M order by Descripcion asc   
SELECT SUM(EnviosPorMes) MENSAJES ,SUM(Costo) MONTO, Descripcion FROM #MAYO    /*WHERE Descripcion='Confirmación de citas'*/ GROUP BY Descripcion  
union select sum(M.EnviosPorMes),sum(M.Costo), 'Total'  from #MAYO M order by Descripcion asc   

 -----------------------------------------------------------------------------------------------------------------------
-- MENSAJES POR PLANTILLAS
-----------------------------------------------------------------------------------------------------------------------
--ENERO
DROP TABLE IF EXISTS #ENERO
select PD.*,P.Body INTO #ENERO from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=1 AND G.IdGrupo=5
order by G.IdGrupo
--FEBRERO
DROP TABLE IF EXISTS #FEBRERO
select PD.*,P.Body INTO #FEBRERO from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=2 AND G.IdGrupo=5
order by G.IdGrupo
--MARZO
DROP TABLE IF EXISTS #MARZO
select PD.*,P.Body INTO #MARZO  from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=3 AND G.IdGrupo=5
order by G.IdGrupo
--ABRIL
DROP TABLE IF EXISTS #ABRIL
select PD.*,P.Body INTO #ABRIL from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=4 AND G.IdGrupo=5
order by G.IdGrupo
--MAYO
DROP TABLE IF EXISTS #MAYO
select PD.*,P.Body INTO #MAYO from PLANTILLA_DETALLE PD
INNER JOIN PLANTILLA P ON P.IdPlantilla= PD.IdPlantilla
INNER JOIN GRUPO G ON G.Idgrupo=P.IdGrupo
where Mes=5 AND G.IdGrupo=5
order by G.IdGrupo

SELECT * FROM #ENERO
SELECT * FROM #FEBRERO
SELECT * FROM #MARZO
SELECT * FROM #ABRIL
SELECT * FROM #MAYO
 -----------------------------------------------------------------------------------------------------------------------
-- MENSAJES DE CONFIRMACION DE CITA
-----------------------------------------------------------------------------------------------------------------------
--Hola!, tu cita para depilarte se aproxima , el 1/May a las 11:25am. Te recomendamos estar 10 minutos antes, para evitar contratiempos. *Recuerda* que no puedes traer desodorante maquillaje cremas loción ni ninguna sustancia ni químico en la piel. Así mismo debes venir rasurado(a) con rastrillo el mismo día de tu cita.
DROP TABLE IF EXISTS #TABLA
DROP TABLE IF EXISTS #TABLA_CONFIRMACION
DROP TABLE IF EXISTS #TABLA_RECORDATORIO

SELECT * INTO  #TABLA  FROM Paso2_abril WHERE Body LIKE 'Hola!, tu cita para depilarte se aproxima%'
-- SELECT * FROM #TABLA WHERE BODY LIKE '%escribe OK para activar el link' OR BODY LIKE '%Así mismo debes venir rasurado(a) con rastrillo el mismo día de tu cita.' ORDER BY BODY DESC

SELECT * INTO #TABLA_CONFIRMACION FROM #TABLA WHERE Body LIKE '%escribe OK para activar el link' OR BODY LIKE '%Así mismo debes venir rasurado(a) con rastrillo el mismo día de tu cita.' ORDER BY BODY DESC


SELECT * INTO #TABLA_RECORDATORIO FROM #TABLA WHERE id NOT IN(SELECT id FROM #TABLA_CONFIRMACION)
SELECT * FROM #TABLA
SELECT * FROM #TABLA_CONFIRMACION
SELECT * FROM #TABLA_RECORDATORIO