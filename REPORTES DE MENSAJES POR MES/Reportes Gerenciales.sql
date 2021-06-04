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
-- select sum(isnull(EnviosPorMes,0)) envios ,sum(Costo) monto from PLANTILLA_DETALLE where Mes=5 union 
-- select count( *),sum(Price)   from Paso2_mAYO where   From_ in( select t.NumeroWhatsapp from WhatsappEmisor t)
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
-----------------------------------------------------------------------------------------------------------------------
-- MENSAJES POR SESIONES CREADAS AL MES
-----------------------------------------------------------------------------------------------------------------------
GO
DROP TABLE  IF EXISTS #TABLA
select  TO_,SESION,SUM(Price) Precio,COUNT(*) Mensajes,Mes INTO #TABLA
from 
MENSAJES_POR_SESIONES 
--where Price!=0
group by TO_,SESION,MES
order by 1,2,3 desc

SELECT * FROM #TABLA where Mes=2 --and to_ like '%2284039384%'
order by 1,2,3 desc

DROP TABLE IF EXISTS #TABLA_SESIONES
SELECT TO_,Mes ,COUNT(TO_) SESIONES, 0.014 PRECIO INTO #TABLA_SESIONES FROM #TABLA where TO_ like 'whatsapp:+52%' GROUP BY TO_,MES

DROP TABLE IF EXISTS #ENERO
SELECT *,PRECIO*SESIONES TOTAL INTO #ENERO FROM #TABLA_SESIONES WHERE MES=1

DROP TABLE IF EXISTS #FEBRERO
SELECT *,PRECIO*SESIONES TOTAL INTO #FEBRERO FROM #TABLA_SESIONES WHERE MES=2

DROP TABLE IF EXISTS #MARZO
SELECT *,PRECIO*SESIONES TOTAL INTO #MARZO   FROM #TABLA_SESIONES WHERE MES=3

DROP TABLE IF EXISTS #ABRIL
SELECT *,PRECIO*SESIONES TOTAL INTO #ABRIL FROM #TABLA_SESIONES WHERE MES=4

DROP TABLE IF EXISTS #MAYO
SELECT *,PRECIO*SESIONES TOTAL INTO #MAYO FROM #TABLA_SESIONES WHERE MES=5

SELECT 'ENERO'      MES,SUM(SESIONES) SESIONES ,SUM(TOTAL) SALDO FROM #ENERO UNION
SELECT 'FEBRERO'    MES,SUM(SESIONES) SESIONES ,SUM(TOTAL) SALDO FROM #FEBRERO UNION
SELECT 'MARZO'      MES,SUM(SESIONES) SESIONES ,SUM(TOTAL) SALDO FROM #MARZO UNION
SELECT 'ABRIL'      MES,SUM(SESIONES) SESIONES ,SUM(TOTAL) SALDO FROM #ABRIL UNION
SELECT 'MAYO'      MES,SUM(SESIONES) SESIONES ,SUM(TOTAL) SALDO FROM #MAYO 
---------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #TABLA1
DROP TABLE IF EXISTS #TABLA2
--MENSAJES ENVIADOS POR NUMEROS DE WHASTAPP PROPIOS
SELECT 1 ID,'ENERO' MES ,count(*) MENSAJES INTO #TABLA1 FROM Paso2_Enero WHERE From_ IN (SELECT NumeroWhatsapp FROM WhatsappEmisor) UNION
SELECT 2 ID,'FEBRERO' MES ,count(*) MENSAJES FROM Paso2_Febrero WHERE From_ IN (SELECT NumeroWhatsapp FROM WhatsappEmisor) UNION
SELECT 3 ID,'MARZO' MES ,count(*) MENSAJES FROM Paso2_marzo WHERE From_ IN (SELECT NumeroWhatsapp FROM WhatsappEmisor) UNION
SELECT 4 ID,'ABRIL' MES ,count(*) MENSAJES FROM Paso2_abril WHERE From_ IN (SELECT NumeroWhatsapp FROM WhatsappEmisor) 
GO
--MENSAJES DESCARGADOS DE TWILIO
SELECT 1 ID,'ENERO' MES ,count(*)  MENSAJES INTO #TABLA2 FROM Paso2_Enero  UNION
SELECT 2 ID,'FEBRERO' MES ,count(*) MENSAJES FROM Paso2_Febrero  UNION
SELECT 3 ID,'MARZO' MES ,count(*) MENSAJES FROM Paso2_marzo  UNION
SELECT 4 ID,'ABRIL' MES ,count(*) MENSAJES FROM Paso2_abril 

SELECT * FROM #TABLA1 ORDER BY ID ASC
SELECT * FROM #TABLA2 ORDER BY ID ASC
