	--FEBRERO
	select 
	F.From_,F.To_,F.DateCreated,S.SESION--,F.ID
	INTO #FEBRERO
	from MENSAJES_POR_SESIONES S
	INNER JOIN Paso2_Febrero F ON F.id=S.ID
	where S.Mes=2 
	
	GROUP BY F.From_,F.To_,F.DateCreated,S.SESION--,F.ID 
	
	ORDER BY F.To_,SESION ASC

	--MARZO
	select 
	F.From_,F.To_,F.DateCreated,S.SESION--,F.ID
	INTO #MARZO
	from MENSAJES_POR_SESIONES S
	INNER JOIN Paso2_marzo F ON F.id=S.ID
	where S.Mes=3
	
	GROUP BY F.From_,F.To_,F.DateCreated,S.SESION--,F.ID 
	
	ORDER BY F.To_,SESION ASC

	--ABRIL

	select 
	F.From_,F.To_,F.DateCreated,S.SESION--,F.ID
	INTO #ARBIL
	from MENSAJES_POR_SESIONES S
	INNER JOIN Paso2_abril F ON F.id=S.ID
	where S.Mes=4 
	
	GROUP BY F.From_,F.To_,F.DateCreated,S.SESION--,F.ID 
	
	ORDER BY F.To_,SESION ASC




	SELECT  From_,To_, SESION,MIN(DateCreated) DateCreated FROM #FEBRERO 
	GROUP BY From_,To_, SESION
	ORDER BY From_,To_ ASC

	SELECT  From_,To_, SESION,MIN(DateCreated) DateCreated FROM #MARZO 
	GROUP BY From_,To_, SESION
	ORDER BY From_,To_ ASC

	SELECT  From_,To_, SESION,MIN(DateCreated) DateCreated FROM #ARBIL 
	GROUP BY From_,To_, SESION
	ORDER BY From_,To_ ASC