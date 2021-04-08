USE [msdb]
GO

/****** Object:  Job [job_procesa_notifier_paciente]    Script Date: 08/04/2021 12:06:37 p. m. ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 08/04/2021 12:06:37 p. m. ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'job_procesa_notifier_paciente', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'No description available.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'rm_europiel_master', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ejecuta script]    Script Date: 08/04/2021 12:06:38 p. m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ejecuta script', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'TRUNCATE TABLE dbo.t_notifier_paciente;
GO

INSERT INTO dbo.t_notifier_paciente
	SELECT * FROM dbo.v_notifier_paciente
;
--SELECT * FROM dbo.t_notifier_paciente
GO

---------------------------------------------------------------------------------------------------

TRUNCATE TABLE dbo.t_notifier_paciente_app;
GO

INSERT INTO dbo.t_notifier_paciente_app
	SELECT * FROM dbo.v_notifier_paciente_app
;
--SELECT * FROM dbo.t_notifier_paciente_app
GO
', 
		@database_name=N'rm_europiel_requerimientos', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Agrega sucursales nuevas a potenciales antes COVID]    Script Date: 08/04/2021 12:06:38 p. m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Agrega sucursales nuevas a potenciales antes COVID', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=3, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE rm_europiel_requerimientos;
GO

INSERT INTO dbo.potencial_sucursales_antes_covid ( id_sucursal, bloque, potencial, reaperturada, sucursal)
SELECT
    s.id_sucursal, s.bloque, s.potencial_venta, 1, s.descripcion
FROM
    v_sucursales s
    LEFT OUTER JOIN dbo.potencial_sucursales_antes_covid p ON s.bloque = p.bloque AND s.id_sucursal = p.id_sucursal
WHERE
    p.id_sucursal IS NULL
    AND s.es_activa = 1 AND s.es_cerrada = 0 AND s.esta_aperturada = 1
;
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Ejecuta SP dbo.actualiza_PAGO_CAJA_DETALLE_id_paquete_anticipo en modo DIARIO]    Script Date: 08/04/2021 12:06:38 p. m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Ejecuta SP dbo.actualiza_PAGO_CAJA_DETALLE_id_paquete_anticipo en modo DIARIO', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'USE rm_dermapro;
GO

EXECUTE dbo.actualiza_PAGO_CAJA_DETALLE_id_paquete_anticipo ''DIARIO'';
GO

USE rm_europiel_sinergia3;
GO

EXECUTE dbo.actualiza_PAGO_CAJA_DETALLE_id_paquete_anticipo ''DIARIO'';
GO

USE rm_europiel_usa1;
GO

EXECUTE dbo.actualiza_PAGO_CAJA_DETALLE_id_paquete_anticipo ''DIARIO'';
GO
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Cada día a las 4am', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20200921, 
		@active_end_date=99991231, 
		@active_start_time=40000, 
		@active_end_time=235959, 
		@schedule_uid=N'28c45540-e9a8-4c68-8fc9-857909b62924'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

