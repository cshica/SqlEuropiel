USE [rm_europiel_requerimientos]
GO
/****** Object:  StoredProcedure [dbo].[recupera_informacion_callcenter]    Script Date: 24/06/2021 06:56:30 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[recupera_informacion_callcenter] --recupera_informacion_callcenter 1,'20210401','20210621','LEIVY SUSANA SALAZAR BETTIN','0','0','0',null,0,null,null,1,0
(
    @tipo           INT,
    @fecha_ini      DATE,
    @fecha_fin      DATE,
    @cliente        VARCHAR(128),
	@sucursal       VARCHAR(64),
    @agente         VARCHAR(64),
    @tipo_reporte   VARCHAR(64),
    @espera_ini     INT,
    @espera_fin     INT,
    @llamada_ini    INT,
    @llamada_fin    INT,
    @id_usuario     INT,
    @EsExcel        BIT
)
AS
BEGIN
    DECLARE
        @var_agente         VARCHAR(150),
        @var_espera_ini     INT,
        @var_espera_fin     INT,
        @var_llamada_ini    INT,
        @var_llamada_fin    INT,
        @var_inicio_dia     BIT
    ;

    SELECT
        @var_espera_ini     = ISNULL(@espera_ini    , 0),
        @var_espera_fin     = ISNULL(@espera_fin    , 90000),
        @var_llamada_ini    = ISNULL(@llamada_ini   , 20),
        @var_llamada_fin    = ISNULL(@llamada_fin   , 90000),
        @var_inicio_dia     = CASE @espera_fin WHEN 1 THEN 1 WHEN 0 THEN 0 ELSE 0 END
        -- *** PDTE AJUSTAR CONSULTA CON ESTE PARÁMETRO
    ;
    SELECT
        @var_espera_ini     = CASE WHEN @var_espera_ini = 0 THEN 0 ELSE @var_espera_ini END,
        @var_espera_fin     = CASE WHEN @var_espera_fin = 0 THEN 90000 ELSE @var_espera_fin END,
        @var_llamada_ini    = CASE WHEN @var_llamada_ini = 0 THEN 20 ELSE @var_llamada_ini END,
        @var_llamada_fin    = CASE WHEN @var_llamada_fin = 0 THEN 90000 ELSE @var_llamada_fin END
    ;

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
        id_llamada          VARCHAR(64) NULL
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
        fecha_registro      DATETIME        NULL
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
	CREATE NONCLUSTERED INDEX IX_LlamadaFin1_id_llamada ON #LlamadaFin (id_llamada)

	 CREATE TABLE #EsperaFin1 (
        id_llamada          VARCHAR(64)     NULL,
        fecha_registro      DATETIME        NULL
    )
	CREATE NONCLUSTERED INDEX IX_LlamadaInicio1_id_llamada ON #LlamadaInicio (id_llamada)
	/********************************************************************************************************************************/



    SET @fecha_fin = DATEADD( DAY, 1, @fecha_fin );

    -- HGU 2020-11-26 Nery solicita que se libere funcionalidad para todos los demás
    -- IF ( @id_usuario IN (2, 71226, 71646, 725) )
    -- BEGIN
    --     SELECT @var_agente = '';
    -- END
    -- ELSE
    -- BEGIN
  -- /*
    --     Agente                  Login           id_usuario
    --     --------------------    -------------   ------------
    --     Elia Espino             agente2         71302
    --     Grecia Ordaz            agente5         71455
    --     Ljuvitza Borlinic       agente6         71509
    --     Mariana Zamora          agente1         71301
    --     Mónica Moreno           agente8         72404
    --     Sonia Cedillo           agente4         71454
    --     Vivíana Alvarez         agente9         72405
    -- */
    --     SELECT @var_agente =
    --         CASE @id_usuario
    --             WHEN 71302 THEN 'Elia Espino'
    --             WHEN 71455 THEN 'Grecia Ordaz'
    --             WHEN 71509 THEN 'Ljuvitza Borlinic'
    --             WHEN 71301 THEN 'Mariana Zamora'
    --             WHEN 72404 THEN 'Mónica Moreno'
    --             WHEN 71454 THEN 'Sonia Cedillo'
    --             WHEN 72405 THEN 'Vivíana Alvarez'
    --             ELSE '(DESCONOCIDO)'
    --         END
    -- END

    SELECT @var_agente =
        CASE @id_usuario
            WHEN 71302 THEN 'Elia Espino'
            WHEN 71455 THEN 'Grecia Ordaz'
            WHEN 71509 THEN 'Ljuvitza Borlinic'
            WHEN 71301 THEN 'Mariana Zamora'
            WHEN 72404 THEN 'Mónica Moreno'
            WHEN 71454 THEN 'Sonia Cedillo'
            WHEN 72405 THEN 'Vivíana Alvarez'

            WHEN 71303 THEN 'Frida Vargas'
            WHEN 72395 THEN 'Esmeralda Solis'

            ELSE ''
        END
    -- HGU 2020-11-26 Nery solicita que se libere funcionalidad para todos los demás

    -- SELECT GETDATE();
    INSERT INTO #EsperaInicio
        SELECT
            id_llamada, bloque, id_sucursal, agente, fecha_registro
        FROM
            dbo.monitoreo_callcenter mc WITH (NOLOCK)
        WHERE
			tipo_evento = 'I'AND mc.es_llamada_espera = 1 AND
            mc.fecha_registro >= @fecha_ini AND mc.fecha_registro < @fecha_fin
            -- AND ( @var_agente = '' OR mc.agente = @var_agente )


    INSERT INTO #EsperaFin1--CSHICA 16-06-2021-> VALOR ORIGINAL #EsperaFin
        SELECT
            mc.id_llamada, mc.fecha_registro
        FROM
            dbo.monitoreo_callcenter mc WITH (NOLOCK)
			--inner join dbo.bitacora_monitoreo_callcenter bmc (NOLOCK) on bmc.id_monitoreo=mc.id_monitoreo--CSHICA 15-06-2021
        WHERE
			tipo_evento = 'F' AND mc.es_llamada_espera = 1 AND
            mc.fecha_registro >= @fecha_ini AND mc.fecha_registro < @fecha_fin

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
            id_llamada, bloque, id_sucursal, agente, fecha_registro
        FROM
            dbo.monitoreo_callcenter mc WITH (NOLOCK)
        WHERE
			tipo_evento = 'I' AND mc.es_llamada_espera = 0 AND
            mc.fecha_registro >= @fecha_ini AND mc.fecha_registro < @fecha_fin;


    INSERT INTO #LlamadaFin1-- CSHICA 16-06-2021-> VALOR ORIGINAL #LlamadaFin
        SELECT
            mc.id_llamada, mc.fecha_registro, mc.id_monitoreo
        FROM
            dbo.monitoreo_callcenter mc WITH (NOLOCK)
			inner join dbo.bitacora_monitoreo_callcenter bmc (NOLOCK) on bmc.id_monitoreo=mc.id_monitoreo--CSHICA 15-06-2021
        WHERE
			mc.tipo_evento = 'F' AND mc.es_llamada_espera = 0 AND
            mc.fecha_registro >= @fecha_ini AND mc.fecha_registro < @fecha_fin;


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
    , cteLlamada ( id_llamada, bloque, id_sucursal, agente, inicio, fin, id_monitoreo ) AS (
        SELECT
            i.id_llamada, i.bloque, i.id_sucursal, i.agente, i.fecha_registro, f.fecha_registro, f.id_monitoreo
        FROM
            #LlamadaInicio i
            LEFT OUTER JOIN #LlamadaFin f ON i.id_llamada = f.id_llamada
        WHERE
            f.fecha_registro IS NOT NULL
    )
    , ctePac AS (
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_dermapro.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_dermapro.dbo.PACIENTE 
p WITH (NOLOCK) INNER JOIN rm_dermapro.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_dermapro.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel.dbo.PACIENTE 
p WITH (NOLOCK) INNER JOIN rm_europiel.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_espana.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), /*b.abreviatura*/ 'ESP1' AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_espana.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_espana.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_espana.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_guadalajara.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_guadalajara.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_guadalajara.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_guadalajara.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_juarez.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_juarez.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_juarez.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_juarez.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_mty2.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_mty2.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_mty2.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_mty2.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_sinergia3.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_sinergia3.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_sinergia3.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_sinergia3.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque UNION
        SELECT bloque = (SELECT TOP 1 bloque FROM rm_europiel_usa1.dbo.parametro WITH (NOLOCK) WHERE id > 0 ), b.abreviatura AS bloque2, p.id_paciente, cliente = CONCAT( p.nombre, CHAR(32) + p.ap_paterno, CHAR(32) + p.ap_materno) FROM rm_europiel_usa1.dbo.PACIENTE p WITH (NOLOCK) INNER JOIN rm_europiel_usa1.dbo.SUCURSAL s WITH (NOLOCK) ON p.id_sucursal = s.id_sucursal INNER JOIN rm_europiel_usa1.dbo.bloque b WITH (NOLOCK) ON s.id_bloque = b.id_bloque
    )
    INSERT INTO @InfoCC (sucursal, fecha, inicio, fin_espera, duracion_espera, fin_llamada, duracion_llamada, estatus, agente, cliente, tipo_reporte, observaciones, id_llamada)
    SELECT
        DISTINCT
        sucursal            = s.descripcion, 
        fecha               = CAST( e.inicio AS DATE),
        inicio              = CAST(e.inicio AS TIME),
        fin_espera          = CAST(ISNULL(e.fin, l.inicio) AS TIME),
        duracion_espera  = CAST( ISNULL(e.fin, l.inicio) - e.inicio AS TIME ),
        fin_llamada         = CAST(l.fin AS TIME),
        duracion_llamada    = CAST( l.fin - ISNULL(e.fin, l.inicio) AS TIME ),
        estatus             = CASE WHEN l.agente IS NULL THEN 'Colgó' ELSE 'Entró' END,
        agente              = ISNULL(l.agente, ''),
        cliente             = ISNULL(p.cliente, p2.cliente),
        tipo_reporte        = t.descripcion,
        observaciones       = b.observaciones
        , e.id_llamada
    FROM
        cteEspera e
        LEFT OUTER JOIN dbo.v_sucursales s ON CASE WHEN e.bloque IN ('ESP1', 'ESP2') THEN 'ESP' ELSE e.bloque END = s.bloque AND e.id_sucursal = s.id_sucursal
        LEFT OUTER JOIN cteLlamada l ON e.id_llamada = l.id_llamada
        LEFT OUTER JOIN dbo.bitacora_monitoreo_callcenter bm WITH (NOLOCK) ON l.id_monitoreo = bm.id_monitoreo
        LEFT OUTER JOIN dbo.bitacora_callcenter b WITH (NOLOCK) ON bm.id_bitacora = b.id_bitacora
        LEFT OUTER JOIN ctePac p ON b.bloque = p.bloque AND b.id_paciente = p.id_paciente
        LEFT OUTER JOIN ctePac p2 ON b.bloque = p2.bloque2 AND b.id_paciente = p2.id_paciente
        LEFT OUTER JOIN dbo.bitacora_callcenter_tipo_reporte t WITH (NOLOCK) ON b.id_tipo_reporte = t.id_tipo_reporte
    WHERE
        ( @var_agente = '' OR ISNULL(l.agente, '') = @var_agente )
    ;
    -- SELECT GETDATE();

	DELETE FROM @InfoCC where fin_espera IS NULL AND duracion_espera IS NULL AND DATEDIFF(MINUTE,CONVERT(DATETIME,inicio,109),CONVERT(DATETIME,CAST(GETDATE() AS TIME),109)) > 60;
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

    UPDATE @InfoCC SET tipo_reporte = '(SIN REPORTE)' WHERE tipo_reporte IS NULL AND estatus = 'Entró'

    IF (@tipo = 1)
    BEGIN
        SELECT
            sucursal,
            fecha = CASE WHEN @EsExcel = 1 THEN fecha ELSE CONVERT(VARCHAR(10), fecha, 121) END,
            inicio = CASE WHEN @EsExcel = 1 THEN inicio ELSE CONVERT(VARCHAR(8), inicio, 114) END,
            fin_espera = CASE WHEN @EsExcel = 1 THEN fin_espera ELSE CONVERT(VARCHAR(8), fin_espera, 114) END,
            duracion_espera = CASE WHEN @EsExcel = 1 THEN duracion_espera ELSE CONVERT(VARCHAR(8), duracion_espera, 114) END,
            fin_llamada = CASE WHEN @EsExcel = 1 THEN fin_llamada ELSE CONVERT(VARCHAR(8), fin_llamada, 114) END,
            duracion_llamada = CASE WHEN @EsExcel = 1 THEN duracion_llamada ELSE CONVERT(VARCHAR(8), duracion_llamada, 114) END,
            estatus,
            agente,
            cliente,
            tipo_reporte,
            observaciones
        FROM
            @InfoCC
        WHERE
            cliente = @cliente
        ;
    END;

    IF (@tipo = 2)
    BEGIN
        SELECT
            sucursal,
            fecha = CASE WHEN @EsExcel = 1 THEN fecha ELSE CONVERT(VARCHAR(10), fecha, 121) END,
            inicio = CASE WHEN @EsExcel = 1 THEN inicio ELSE CONVERT(VARCHAR(8), inicio, 114) END,
            fin_espera = CASE WHEN @EsExcel = 1 THEN fin_espera ELSE CONVERT(VARCHAR(8), fin_espera, 114) END,
            duracion_espera = CASE WHEN @EsExcel = 1 THEN duracion_espera ELSE CONVERT(VARCHAR(8), duracion_espera, 114) END,
            fin_llamada = CASE WHEN @EsExcel = 1 THEN fin_llamada ELSE CONVERT(VARCHAR(8), fin_llamada, 114) END,
            duracion_llamada = CASE WHEN @EsExcel = 1 THEN duracion_llamada ELSE CONVERT(VARCHAR(8), duracion_llamada, 114) END,
            estatus,
            agente,
            cliente,
            tipo_reporte,
            observaciones
        FROM
            @InfoCC
        WHERE
            agente = ''
            AND
            ( @sucursal = '0' OR sucursal = @sucursal )
            AND
            DATEDIFF( SECOND, inicio, fin_espera ) > @var_espera_ini AND DATEDIFF( SECOND, inicio, fin_espera ) <= @var_espera_fin
        ;
    END;

    IF (@tipo = 3)
    BEGIN
        SELECT
            sucursal,
            fecha = CASE WHEN @EsExcel = 1 THEN fecha ELSE CONVERT(VARCHAR(10), fecha, 121) END,
            inicio = CASE WHEN @EsExcel = 1 THEN inicio ELSE CONVERT(VARCHAR(8), inicio, 114) END,
            fin_espera = CASE WHEN @EsExcel = 1 THEN fin_espera ELSE CONVERT(VARCHAR(8), fin_espera, 114) END,
            duracion_espera = CASE WHEN @EsExcel = 1 THEN duracion_espera ELSE CONVERT(VARCHAR(8), duracion_espera, 114) END,
            fin_llamada = CASE WHEN @EsExcel = 1 THEN fin_llamada ELSE CONVERT(VARCHAR(8), fin_llamada, 114) END,
            duracion_llamada = CASE WHEN @EsExcel = 1 THEN duracion_llamada ELSE CONVERT(VARCHAR(8), duracion_llamada, 114) END,
            estatus,
            agente,
            cliente,
            tipo_reporte,
            observaciones
        FROM
            @InfoCC
        WHERE
            ( @sucursal = '0' OR sucursal = @sucursal )
            AND
            ( @agente = '0' OR agente = @agente )
            AND
            ( @tipo_reporte = '0' OR tipo_reporte = @tipo_reporte )
            AND
            DATEDIFF( SECOND, inicio, fin_espera ) > @var_espera_ini AND DATEDIFF( SECOND, inicio, fin_espera ) <= @var_espera_fin
            AND
            DATEDIFF( SECOND, fin_espera, fin_llamada ) > @var_llamada_ini AND DATEDIFF( SECOND, fin_espera, fin_llamada ) <= @var_llamada_fin
            -- AND
            -- agente IS NULL
        ;
    END;

    IF (@tipo = 4)
    BEGIN
        IF(@var_inicio_dia = 0)
        BEGIN
            SELECT
                sucursal,
                fecha = CASE WHEN @EsExcel = 1 THEN fecha ELSE CONVERT(VARCHAR(10), fecha, 121) END,
                inicio = CASE WHEN @EsExcel = 1 THEN inicio ELSE CONVERT(VARCHAR(8), inicio, 114) END,
                fin_espera = CASE WHEN @EsExcel = 1 THEN fin_espera ELSE CONVERT(VARCHAR(8), fin_espera, 114) END,
                duracion_espera = CASE WHEN @EsExcel = 1 THEN duracion_espera ELSE CONVERT(VARCHAR(8), duracion_espera, 114) END,
                fin_llamada = CASE WHEN @EsExcel = 1 THEN fin_llamada ELSE CONVERT(VARCHAR(8), fin_llamada, 114) END,
                duracion_llamada = CASE WHEN @EsExcel = 1 THEN duracion_llamada ELSE CONVERT(VARCHAR(8), duracion_llamada, 114) END,
                estatus,
                agente,
                cliente,
                tipo_reporte,
     observaciones
            FROM
                @InfoCC
            WHERE
                ( @sucursal = '0' OR sucursal = @sucursal )
                AND
                DATEDIFF( SECOND, inicio, fin_espera ) > @var_espera_ini AND DATEDIFF( SECOND, inicio, fin_espera ) <= @var_espera_fin
            ;
        END
        ELSE
        BEGIN
            SELECT
                sucursal,
                fecha = CASE WHEN @EsExcel = 1 THEN fecha ELSE CONVERT(VARCHAR(10), fecha, 121) END,
                inicio = CASE WHEN @EsExcel = 1 THEN inicio ELSE CONVERT(VARCHAR(8), inicio, 114) END,
                fin_espera = CASE WHEN @EsExcel = 1 THEN fin_espera ELSE CONVERT(VARCHAR(8), fin_espera, 114) END,
                duracion_espera = CASE WHEN @EsExcel = 1 THEN duracion_espera ELSE CONVERT(VARCHAR(8), duracion_espera, 114) END,
                fin_llamada = CASE WHEN @EsExcel = 1 THEN fin_llamada ELSE CONVERT(VARCHAR(8), fin_llamada, 114) END,
                duracion_llamada = CASE WHEN @EsExcel = 1 THEN duracion_llamada ELSE CONVERT(VARCHAR(8), duracion_llamada, 114) END,
                estatus,
                agente,
                cliente,
                tipo_reporte,
                observaciones
            FROM
                @InfoCC
            WHERE
                ( @sucursal = '0' OR sucursal = @sucursal )
                -- AND
                -- ( DATEDIFF( SECOND, inicio, fin_espera ) > @var_espera_ini AND DATEDIFF( SECOND, inicio, fin_espera ) <= @var_espera_fin )
                AND inicio < CAST( '12:00:00' AS TIME )
            ORDER BY
                inicio ASC
            ;
        END
    END;
    -- SELECT GETDATE();
END;




