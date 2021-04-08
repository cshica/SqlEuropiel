USE [msdb]
GO

/****** Object:  Job [job_procesa_whatsapp_confirmacion_alta]    Script Date: 08/04/2021 12:07:17 p. m. ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 08/04/2021 12:07:17 p. m. ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'job_procesa_whatsapp_confirmacion_alta', 
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
/****** Object:  Step [Paso 1]    Script Date: 08/04/2021 12:07:17 p. m. ******/
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
		@command=N'USE rm_europiel;
GO
EXECUTE dbo.procesa_whatsapp_confirmacion_alta;
GO
USE rm_europiel_mty2;
GO
EXECUTE dbo.procesa_whatsapp_confirmacion_alta;
GO
USE rm_europiel_guadalajara;
GO
EXECUTE dbo.procesa_whatsapp_confirmacion_alta;
GO
USE rm_europiel_juarez;
GO
EXECUTE dbo.procesa_whatsapp_confirmacion_alta;
GO
--USE rm_europiel_usa1;
--GO
--EXECUTE dbo.procesa_whatsapp_confirmacion_alta;
--GO
USE rm_europiel_sinergia3;
GO
EXECUTE dbo.procesa_whatsapp_confirmacion_alta;
GO
--USE rm_dermapro;
--GO
--EXECUTE dbo.procesa_whatsapp_confirmacion_alta;
--GO
USE rm_europiel_espana;
GO
EXECUTE dbo.procesa_whatsapp_confirmacion_alta;
GO
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Cada 5 minutos, minutos 4 y 9', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=127, 
		@freq_subday_type=4, 
		@freq_subday_interval=5, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20200612, 
		@active_end_date=99991231, 
		@active_start_time=100400, 
		@active_end_time=205959, 
		@schedule_uid=N'1b0c203b-d210-476b-8146-05f852ebc5a9'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO

