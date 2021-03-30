SELECT ID, From_, To_ ,SID_,Body,Direction,Price,DateSent,Status_ FROM dbo.Paso2 
WHERE 
--Price<>0

(To_ LIKE '%5217226504584%' OR From_ LIKE '%5217226504584%')
--AND Sid_='SM5a4d1f8c06e71584d90003a5b7660c2c'
 order by DateSent asc;

-- truncate table paso1
--  select * from Paso1 where (To_ LIKE '%whatsapp:+5217226504584%' OR From_ LIKE '%whatsapp:+5217226504584%') 
-------------------------------------------------------------------------------------
SELECT 
ID, From_, To_ ,SID_,Body,Direction,Price,DateSent,Status_ 
FROM dbo.Paso2 
WHERE CAST(DateSent AS DATE) ='2021-02-25'
AND (To_ LIKE '%whatsapp:+5217226504584%' OR From_ LIKE '%whatsapp:+5217226504584%') 
order by DateSent asc;
