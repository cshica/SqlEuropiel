	-- CREARMOS LAS TABLA HORAS POR PAIS
    -- PARA CONTROLAR LOAS HORAS EN OTROS PAISES CON RESPECTO A MEXÍCO
    -- SE USA EN LOS PROCEDURES : genera_notifier_mensajes_bienvenida_cliente

    DECLARE @hora_cri DATETIME--IGUAL QUE EN MEXICO
	DECLARE @hora_hon DATETIME--IGUAL QUE EN MEXICO
	DECLARE @hora_usa DATETIME--+01horas con respecto a mexico
	declare @hora_esp DATETIME--+8horas con respecto a mexico
	declare @hora_col DATETIME--+01 horas con respecto a mexico
	declare @hora_bra DATETIME--+03 horas con respecto a mexico
	DECLARE @hora_mex DATETIME=GETDATE()
	
	set @hora_cri=@hora_mex
	set @hora_hon=@hora_mex
	set @hora_usa= dateadd(HOUR,1,@hora_mex)
	set @hora_esp= dateadd(HOUR,8,@hora_mex)
	set @hora_col=dateadd(HOUR,1,@hora_mex)
	set @hora_bra=dateadd(HOUR,3,@hora_mex)
	
	--select @hora_mex MEX,@hora_esp ESP,@hora_col COL,@hora_cri CRI
    DROP TABLE IF EXISTS  HORAS_POR_PAIS
	CREATE TABLE  HORAS_POR_PAIS
	(
		bloque varchar(5)
		,pais NVARCHAR(50)
		,HORA datetime
	)
	insert into  HORAS_POR_PAIS
	SELECT B.abreviatura,P.nombre,
	(CASE 
	WHEN P.nombre='MEXICO' THEN @hora_mex 
	WHEN B.abreviatura='USA1' THEN @hora_usa 
	WHEN P.nombre='ESPAÑA' THEN @hora_esp
	WHEN P.nombre='COLOMBIA' THEN @hora_col 
	WHEN P.nombre='COSTA RICA' THEN @hora_cri 
	WHEN P.nombre='HONDURAS' THEN @hora_hon 
	WHEN P.nombre='BRASIL' THEN @hora_bra 
	END) HORA
	 FROM rm_europiel.DBO.bloque B 
	INNER JOIN rm_europiel.dbo.PAIS P ON B.id_pais=P.id_pais