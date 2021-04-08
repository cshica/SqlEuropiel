USE [msdb]
GO

/****** Object:  Job [job_procesa_reporte_diario_AMERICA]    Script Date: 08/04/2021 12:06:50 p. m. ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 08/04/2021 12:06:50 p. m. ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'job_procesa_reporte_diario_AMERICA', 
		@enabled=0, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Procesa el reporte diario de las sucursales de América', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'rm_europiel_master', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Paso 1]    Script Date: 08/04/2021 12:06:50 p. m. ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Paso 1', 
		@step_id=1, 
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
DECLARE @fecha DATE = GETDATE();
EXECUTE dbo.procesa_reporte_diario @fecha, @fecha, 0;
GO

USE rm_europiel;
GO
DECLARE @fecha DATE = GETDATE();
EXECUTE dbo.procesa_reporte_diario @fecha, @fecha, 0;
GO

USE rm_europiel_guadalajara;
GO
DECLARE @fecha DATE = GETDATE();
EXECUTE dbo.procesa_reporte_diario @fecha, @fecha, 0;
GO

USE rm_europiel_juarez;
GO
DECLARE @fecha DATE = GETDATE();
EXECUTE dbo.procesa_reporte_diario @fecha, @fecha, 0;
GO

USE rm_europiel_mty2;
GO
DECLARE @fecha DATE = GETDATE();
EXECUTE dbo.procesa_reporte_diario @fecha, @fecha, 0;
GO

USE rm_europiel_sinergia3;
GO
DECLARE @fecha DATE = GETDATE();
EXECUTE dbo.procesa_reporte_diario @fecha, @fecha, 0;
GO

USE rm_europiel_usa1;
GO
DECLARE @fecha DATE = GETDATE();
EXECUTE dbo.procesa_reporte_diario @fecha, @fecha, 0;
GO
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Una vez al día a las 10am', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20200930, 
		@active_end_date=99991231, 
		@active_start_time=100000, 
		@active_end_time=235959, 
		@schedule_uid=N'1e3b95ff-a02a-4640-9d8d-16065142232f'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

