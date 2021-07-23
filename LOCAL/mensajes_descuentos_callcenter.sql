DROP TABLE IF EXISTS #TABLA
select Body,replace(To_,'whatsapp:+52','') telefono,Status_,DateCreated INTO #TABLA  from Paso1 where Body like '%*DESCUENTO GRATIS*%' 
and to_ in(
select To_ from Paso1 where Body like '%*DESCUENTO GRATIS*%' group by To_ having COUNT(*)>1-- and To_ like '%5529194437%'
)
and Status_!='failed'
order by To_,DateCreated


--REPETIDOS
DROP TABLE IF EXISTS #T_REPETIDOS
SELECT Body,telefono,COUNT(*) N INTO #T_REPETIDOS FROM #TABLA GROUP BY Body,telefono

SELECT * FROM #TABLA WHERE telefono IN 
(

SELECT telefono FROM #T_REPETIDOS WHERE N>1
)
union
SELECT * FROM #TABLA WHERE telefono IN 
(

SELECT telefono FROM #T_REPETIDOS WHERE N=1
)
