USE [rm_europiel_requerimientos]
GO
/****** Object:  StoredProcedure [dbo].[recupera_monitoreo_callcenter_solo_resumen]    Script Date: 24/06/2021 06:54:51 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[recupera_monitoreo_callcenter_solo_resumen]
AS
BEGIN
	DECLARE
		@fechahoy				        DATETIME,
		@dia_siguiente			        DATETIME,
		@lunes					        DATETIME,
		@domingo				        DATETIME,
		@lunesproximo			        DATETIME,
		@primer_dia_mes			        DATETIME,
		@ultimo_dia_mes			        DATETIME,
		@promedio_mes_espera	        TIME,
		@llamadas_5om_minutos	        INT,
        @llamadas_espera_3om_limite     INT = 120,
        @llamadas_espera_3om_semana     INT,
        @llamadas_espera_3om_limite_hoy INT = 20,
        @llamadas_espera_3om_hoy        INT
	;

	SET @fechahoy = CAST( FLOOR( CONVERT( FLOAT, GETDATE() ) ) AS DATETIME );

	IF DATEPART( WEEKDAY, @fechahoy ) = 1
		SELECT @fechahoy = DATEADD( DAY, -1, @fechahoy );

	SELECT
		@lunes				= DATEADD( wk,  DATEDIFF( wk, 0, @fechahoy ), 0 ),
		@domingo			= DATEADD( dd,  6, @lunes ),
		@lunesproximo		= DATEADD( dd, 1, @domingo ),
		@dia_siguiente		= DATEADD( dd, 1, @fechahoy ),
		@primer_dia_mes		= DATEADD( s, 0, DATEADD( mm, DATEDIFF( m, 0, @fechahoy ), 0 ) ),
		@ultimo_dia_mes		= DATEADD( s, 0, DATEADD( mm, DATEDIFF( m, 0, @fechahoy ) + 1, 0 ) )
	;

	-- SELECT
	-- 	@fechahoy			AS '@fechahoy',
	-- 	@lunes				AS '@lunes',
	-- 	@domingo			AS '@domingo',
	-- 	@lunesproximo		AS '@lunesproximo',
	-- 	@dia_siguiente		AS '@dia_siguiente',
	-- 	@primer_dia_mes		AS '@primer_dia_mes',
	-- 	@ultimo_dia_mes		AS '@ultimo_dia_mes'
	-- ;

    DECLARE @InfoCC TABLE (
        idInfoCC            INT NOT NULL IDENTITY PRIMARY KEY CLUSTERED,
        sucursal            VARCHAR(64) NULL,
        fecha               DATE NULL,
        inicio              TIME NULL,
        fin_espera          TIME NULL,
        duracion_espera     TIME NULL,
        fin_llamada         TIME NULL,
        duracion_llamada    TIME NULL,
        estatus             VARCHAR(8) NULL,
        agente              VARCHAR(64) NULL,
        cliente             VARCHAR(128) NULL,
        tipo_reporte        VARCHAR(64) NULL,
        observaciones       VARCHAR(4096) NULL,
        id_llamada          VARCHAR(64) NULL,
		semana				TINYINT NULL,
		hoy					TINYINT NULL,
        id_agente           VARCHAR(64) NULL,
		id_sucursal         INT NULL,
		bloque              VARCHAR(10) NULL,
        id_tipo_reporte     INT NULL
    );

    DECLARE @Transferencia TABLE (
        idInfoCC            INT NOT NULL,
        id_llamada          VARCHAR(64) NULL,
        fin_espera          TIME NULL,
        fin_llamada         TIME NULL,
        borrar              BIT NULL DEFAULT(0)
    );

    CREATE TABLE #EsperaInicio (
        id_llamada          VARCHAR(64)     NULL,
        bloque              VARCHAR(10)     NULL,
        id_sucursal         INT             NULL,
        agente              VARCHAR(150)    NULL,
        fecha_registro      DATETIME        NULL
    )
    CREATE NONCLUSTERED INDEX IX_EsperaInicio_id_llamada ON #EsperaInicio (id_llamada)

    CREATE TABLE #EsperaFin (
        id_llamada          VARCHAR(64)     NULL,
        fecha_registro      DATETIME        NULL
    )
    CREATE NONCLUSTERED INDEX IX_EsperaFin_id_llamada ON #EsperaFin (id_llamada)

    CREATE TABLE #LlamadaInicio (
        id_llamada          VARCHAR(64)     NULL,
        bloque              VARCHAR(10)     NULL,
        id_sucursal         INT             NULL,
        agente              VARCHAR(150)    NULL,
        fecha_registro      DATETIME        NULL,
        id_agente           VARCHAR(64)     NULL
    )

    CREATE NONCLUSTERED INDEX IX_LlamadaInicio_id_llamada ON #LlamadaInicio (id_llamada)

    CREATE TABLE #LlamadaFin (
        id_llamada          VARCHAR(64)     NULL,
        fecha_registro      DATETIME        NULL,
        id_monitoreo        INT             NULL
    )
    CREATE NONCLUSTERED INDEX IX_LlamadaFin_id_llamada ON #LlamadaFin (id_llamada)
	/********************************************************************************************************************************/
	--	CSHICA 16-06-2021
	-- TABLAS TEMPORALES PARA ELIMINAR DUPLICADOS DE REGISTROS EN LLAMADAS CON ESTADO "F" FINALIZADO
	    CREATE TABLE #LlamadaFin1 (
        id_llamada          VARCHAR(64)     NULL,
        fecha_registro      DATETIME        NULL,
        id_monitoreo        INT             NULL
    )
	 CREATE TABLE #EsperaFin1 (
        id_llamada          VARCHAR(64)     NULL,
        fecha_registro      DATETIME        NULL
    )
	/********************************************************************************************************************************/
    INSERT INTO #EsperaInicio
        SELECT
            id_llamada, bloque, id_sucursal, agente, fecha_registro
        FROM
            dbo.monitoreo_callcenter mc WITH (NOLOCK)
        WHERE
			tipo_evento = 'I'AND mc.es_llamada_espera = 1 AND
            mc.fecha_registro >= @primer_dia_mes AND mc.fecha_registro < @dia_siguiente
    INSERT INTO #EsperaFin1--CSHICA 16-06-2021-> VALOR ORIGINAL #EsperaFin
        SELECT
            id_llamada, fecha_registro
        FROM
            dbo.monitoreo_callcenter mc WITH (NOLOCK)
        WHERE
			tipo_evento = 'F' AND mc.es_llamada_espera = 1 AND
            mc.fecha_registro >= @primer_dia_mes AND mc.fecha_registro < @dia_siguiente
	/********************************************************************************************************************************/
	-- QUITAMOS DUPLICADOS
	--CSHICA 15-06-2021
	DECLARE @ID_LLAMADA NVARCHAR(200)

	 DECLARE CUR CURSOR 
	 FOR  
		select DISTINCT id_llamada  from #EsperaFin1
	OPEN CUR
		FETCH NEXT FROM CUR INTO @ID_LLAMADA 

		WHILE @@FETCH_STATUS=0
		BEGIN
		INSERT INTO #EsperaFin
		SELECT TOP 1 * FROM #EsperaFin1 WHERE id_llamada=@ID_LLAMADA ORDER BY fecha_registro ASC-- OBTENEMOS EL PRIMER REGISTRO
		FETCH NEXT FROM CUR INTO @ID_LLAMADA 
		END
	CLOSE CUR
	DEALLOCATE CUR;
	/********************************************************************************************************************************/
    INSERT INTO #LlamadaInicio
        SELECT
            id_llamada, bloque, id_sucursal, agente, fecha_registro, id_agente
        FROM
            dbo.monitoreo_callcenter mc WITH (NOLOCK)
        WHERE
			tipo_evento = 'I' AND mc.es_llamada_espera = 0 AND
            mc.fecha_registro >= @primer_dia_mes AND mc.fecha_registro < @dia_siguiente
    INSERT INTO #LlamadaFin1-- CSHICA 16-06-2021-> VALOR ORIGINAL #LlamadaFin
        SELECT
            mc.id_llamada, mc.fecha_registro, mc.id_monitoreo
        FROM
            dbo.monitoreo_callcenter mc WITH (NOLOCK)
			inner join dbo.bitacora_monitoreo_callcenter bmc (NOLOCK) on bmc.id_monitoreo=mc.id_monitoreo--cshica 15-06-2021
        WHERE
			tipo_evento = 'F' AND mc.es_llamada_espera = 0 AND
            mc.fecha_registro >= @primer_dia_mes AND mc.fecha_registro < @dia_siguiente;
/********************************************************************************************************************************/
	-- QUITAMOS DUPLICADOS
	--CSHICA 15-06-2021
	DECLARE @ID_LLAMADA_FIN NVARCHAR(200)

	 DECLARE CUR1 CURSOR 
	 FOR  
		select DISTINCT id_llamada  from #LlamadaFin1
	OPEN CUR1
		FETCH NEXT FROM CUR1 INTO @ID_LLAMADA_FIN 

		WHILE @@FETCH_STATUS=0
		BEGIN
		INSERT INTO #LlamadaFin
		SELECT TOP 1 * FROM #LlamadaFin1 WHERE id_llamada=@ID_LLAMADA_FIN ORDER BY fecha_registro ASC-- OBTENEMOS EL PRIMER REGISTRO
		FETCH NEXT FROM CUR1 INTO @ID_LLAMADA_FIN 
		END
	CLOSE CUR1
	DEALLOCATE CUR1;
	/********************************************************************************************************************************/

    WITH cteEspera ( id_llamada, bloque, id_sucursal, agente, inicio, fin ) AS (
        SELECT
            i.id_llamada, i.bloque, i.id_sucursal, i.agente, i.fecha_registro, f.fecha_registro
        FROM
            #EsperaInicio i
            LEFT OUTER JOIN #EsperaFin f ON i.id_llamada = f.id_llamada
    )
    , cteLlamada ( id_llamada, bloque, id_sucursal, agente, inicio, fin, id_monitoreo, id_agente ) AS (
        SELECT
            i.id_llamada, i.bloque, i.id_sucursal, i.agente, i.fecha_registro, f.fecha_registro, f.id_monitoreo, i.id_agente
        FROM
            #LlamadaInicio i
            LEFT OUTER JOIN #LlamadaFin f ON i.id_llamada = f.id_llamada
        WHERE
            f.fecha_registro IS NOT NULL
    )
    , ctePac AS (
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_dermapro.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_dermapro.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_dermapro.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_dermapro.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_espana.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), /*b.abreviatura*/ 'ESP1' AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_espana.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_espana.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_espana.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_guadalajara.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_guadalajara.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_guadalajara.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_guadalajara.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_juarez.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_juarez.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_juarez.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_juarez.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_mty2.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_mty2.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_mty2.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_mty2.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_sinergia3.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_sinergia3.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_sinergia3.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_sinergia3.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_usa1.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_usa1.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_usa1.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_usa1.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque
    )
    INSERT INTO @InfoCC (
        sucursal, fecha, inicio, fin_espera, duracion_espera, fin_llamada, duracion_llamada, estatus, agente, cliente, tipo_reporte, observaciones, id_llamada, semana, hoy, id_agente, bloque, id_sucursal,
        id_tipo_reporte
    )
    SELECT
        DISTINCT
        sucursal            = s.descripcion, 
        fecha               = CAST( e.inicio AS DATE),
        inicio              = CAST(e.inicio AS TIME),
        fin_espera          = CAST(ISNULL(e.fin, l.inicio) AS TIME),
        duracion_espera     = CAST( ISNULL(e.fin, l.inicio) - e.inicio AS TIME ),
        fin_llamada         = CAST(l.fin AS TIME),
        duracion_llamada    = CAST( l.fin - ISNULL(e.fin, l.inicio) AS TIME ),
        estatus             = CASE WHEN l.agente IS NULL THEN 'Colgó' ELSE 'Entró' END,
        agente              = ISNULL(l.agente, ''),
        cliente             = ISNULL(p.cliente, p2.cliente),
        tipo_reporte        = t.descripcion,
        observaciones       = b.observaciones
        , e.id_llamada,
		semana				= CASE WHEN e.inicio >= @lunes AND e.inicio < @lunesproximo THEN 1 ELSE 0 END,
		hoy					= CASE WHEN e.inicio >= @fechahoy AND e.inicio < @dia_siguiente THEN 1 ELSE 0 END,
        id_agente           = l.id_agente,
        bloque              = e.bloque,
        id_sucursal         = e.id_sucursal,
        id_tipo_reporte     = b.id_tipo_reporte
    FROM
        cteEspera e
        LEFT OUTER JOIN dbo.v_sucursales s ON CASE WHEN e.bloque IN ('ESP1', 'ESP2') THEN 'ESP' ELSE e.bloque END = s.bloque AND e.id_sucursal = s.id_sucursal
        LEFT OUTER JOIN cteLlamada l ON e.id_llamada = l.id_llamada
        LEFT OUTER JOIN dbo.bitacora_monitoreo_callcenter bm WITH (NOLOCK) ON l.id_monitoreo = bm.id_monitoreo
        LEFT OUTER JOIN dbo.bitacora_callcenter b WITH (NOLOCK) ON bm.id_bitacora = b.id_bitacora
        LEFT OUTER JOIN ctePac p ON b.bloque = p.bloque AND b.id_paciente = p.id_paciente
        LEFT OUTER JOIN ctePac p2 ON b.bloque = p2.bloque2 AND b.id_paciente = p2.id_paciente
        LEFT OUTER JOIN dbo.bitacora_callcenter_tipo_reporte t WITH (NOLOCK) ON b.id_tipo_reporte = t.id_tipo_reporte
    ;

	DELETE FROM @InfoCC where fin_espera IS NULL AND duracion_espera IS NULL AND DATEDIFF(MINUTE,CONVERT(DATETIME,inicio,109),CONVERT(DATETIME,CAST(GETDATE() AS TIME),109)) > 40;
    -- HGU 2020-12-10
    DELETE FROM @InfoCC WHERE duracion_espera > '23:00:00';

    -- Identifica y repara las llamadas transferidas.
    WITH ctePaso AS (
        SELECT id_llamada FROM @InfoCC GROUP BY id_llamada HAVING COUNT(*) > 1
    )
    INSERT INTO @Transferencia ( idInfoCC, id_llamada )
    SELECT
        i.idInfoCC, i.id_llamada
    FROM
        @InfoCC i
        INNER JOIN ctePaso p ON i.id_llamada = p.id_llamada
    WHERE
        fin_espera > fin_llamada
    ;
    UPDATE t SET
        t.fin_espera = i.fin_espera,
        t.fin_llamada = i.fin_llamada
    FROM
        @Transferencia t
        INNER JOIN @InfoCC i ON t.idInfoCC = i.idInfoCC
    UPDATE i SET
        i.fin_espera = t.fin_llamada,
        i.fin_llamada = t.fin_espera
    FROM
        @InfoCC i
        INNER JOIN @Transferencia t ON i.idInfoCC = t.idInfoCC

    UPDATE i SET
        i.duracion_llamada = CAST( DATEADD(MILLISECOND, DATEDIFF( MILLISECOND, i.fin_espera, i.fin_llamada ), '19000101' ) AS TIME )
    FROM
        @InfoCC i
        INNER JOIN @Transferencia t ON i.idInfoCC = t.idInfoCC;

    WITH ctePaso AS (
        SELECT
            i.idInfoCC,
            ROW_NUMBER() OVER(PARTITION BY i.id_llamada ORDER BY i.fecha, i.inicio, i.fin_espera, i.fin_llamada) AS Orden
        FROM
            @InfoCC i
            INNER JOIN @Transferencia t ON i.id_llamada = t.id_llamada
        WHERE
            t.borrar = 0
    )
    INSERT INTO @Transferencia ( idInfoCC, borrar )
        SELECT P.idInfoCC, 1 FROM ctePaso p WHERE p.Orden = 2;
    DELETE FROM @InfoCC WHERE idInfoCC IN (SELECT idInfoCC FROM @Transferencia WHERE borrar = 1)

    SELECT
        @llamadas_espera_3om_semana = COUNT(*)
    FROM
        @InfoCC
    WHERE
        DATEDIFF( SECOND, inicio, fin_espera ) > ( 60 * 3 )     -- +3 minutos
        AND semana = 1
    ;
    SELECT
        @llamadas_espera_3om_hoy = COUNT(*)
    FROM
        @InfoCC
    WHERE
        DATEDIFF( SECOND, inicio, fin_espera ) > ( 60 * 3 )     -- +3 minutos
        AND hoy = 1
    ;

    SELECT
        @llamadas_espera_3om_limite     = @llamadas_espera_3om_limite       - @llamadas_espera_3om_semana,
        @llamadas_espera_3om_limite_hoy = @llamadas_espera_3om_limite_hoy   - @llamadas_espera_3om_hoy
    ;

	SELECT
		total_global_hoy		= SUM(hoy),
		total_global_semana		= SUM(semana),
		total_global_mes		= COUNT(*),
		-- promedio_global_mes		= cast(cast(avg(cast(CAST( CASE WHEN total_minutos as datetime) as float)) as datetime) as time),
		promedio_global_mes		= 
        RIGHT(
            ISNULL((
                SELECT
                    CAST( CAST(CAST(AVG(CAST(CAST(duracion_llamada AS DATETIME) AS FLOAT)) AS DATETIME) AS TIME) AS VARCHAR(8) )
                FROM
                    @InfoCC
                where
                    DATEDIFF( SECOND, fin_espera, fin_llamada ) > 20
                    AND hoy = 1
            ), '00:00:00')
        ,5)
        ,
		promedio_mes_espera		=
        RIGHT(
            ISNULL((
                SELECT
                    CAST( CAST(CAST( AVG( ISNULL( CAST(CAST(ISNULL(duracion_espera, '00:00:00') AS DATETIME) AS FLOAT) , 0.00)   ) AS DATETIME ) AS TIME) AS VARCHAR(8) )
                FROM
                    @InfoCC
                where
                    -- DATEDIFF( SECOND, inicio, fin_espera ) > 20
                    -- AND
                    hoy = 1
            ), '00:00:00')
        ,5)
        ,
		llamadas_5om_minutos	=
		(
			SELECT
                COUNT(*)
            FROM
                @InfoCC
            WHERE
                DATEDIFF( SECOND, inicio, fin_espera ) > ( 60 * 3 )     -- +3 minutos
                AND hoy = 1
        )
        , llamadas_espera_3om_semana = @llamadas_espera_3om_semana
        , llamadas_espera_3om_limite = @llamadas_espera_3om_limite
        , llamadas_espera_3om_limite_hoy = @llamadas_espera_3om_limite_hoy
	FROM
		@InfoCC i
	WHERE
		DATEDIFF( SECOND, fin_espera, fin_llamada ) > 20
	;

END

