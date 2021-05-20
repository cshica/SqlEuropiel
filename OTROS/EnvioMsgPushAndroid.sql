DECLARE @MSG_ANDROID NVARCHAR(MAX)='"data":{"messageId":"1","title": "Actualiza tu APP", "posterUrl":"https://europiel-system-files.s3.amazonaws.com/AppEuropielAndroid/POP_UP_ActualizaApp.jpg", "url":"https://europiel.com.mx","linkUrl":"https://play.google.com/store/apps/details?id=com.virtekinnovations.europiel", "Category":"POPUP_INAPP"}}'
DECLARE @VERSION NVARCHAR(10)='4.1.4'
DROP TABLE IF EXISTS #TABLA_MSG
create table #TABLA_MSG(
 id int identity(1,1),
 id_notifier int,
 id_usuario INT,
 id_bloque INT,
 bloque varchar(32),
 device_token varchar(1024),
 mobile_os varchar(64),
 payload varchar(4096),
 fecha_alta_paciente datetime
)

/*
COL2,COL1,MTY1,MTY3
--====================
*/
INSERT INTO #TABLA_MSG (id_notifier,id_usuario,id_bloque,bloque,device_token,mobile_os,fecha_alta_paciente,payload)
select distinct 5, c.id_usuario, s.id_bloque, b.abreviatura, d.id_device, d.os, p.fecha_alta,
		payload=  CONCAT('{"registration_ids":["' + d.id_device + '"],',@MSG_ANDROID)
--,isnull((SELECT TOP 1 os_version FROM rm_europiel..mobile_user_login WITH(NOLOCK) WHERE id_usuario = p.id_paciente AND action = 'Login' ORDER BY id DESC),0)
from v_clientes_con_callcenter_activo c
join rm_europiel.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='MTY1'
and s.callcenter_activo=1
and isnull((SELECT TOP 1 os_version FROM rm_europiel..mobile_user_login WITH(NOLOCK) WHERE id_usuario = p.id_paciente AND action = 'Login' ORDER BY id DESC),0)  not in  (@VERSION)
--and version not is(4.0.7)
--and (not exists (select 1 from notifier_mensajes n (nolock) where id_notifier=5 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
--	or exists (select 1 from notifier_mensajes n (nolock) where id_notifier=5 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
--				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
--	)
--AND (d.id_device='cbutLFsHtXM:APA91bHS9rnRcOusAbyprlcUnxyUz5xJYtCHSLLrAGz_J0AS8wbjTMUqmgfeDXYzlIB64bcZyB75EmmXBzAkmAsWY7EGwLIjv8T9KyFK7q8hOpdLxfBNQOmyViUs6wWfyLqvleVJUpuZ'--shica
--or d.id_device='fvTQ_vmB5oo:APA91bHymHjbDwgJscptIfkIxLMiCy2-8ZWudBNlqTKz668yAfeBbys0U7pq3rMjphVNHTJM1Ok3hQoF_QCuCBcOQ4JCaeAXBKSABs2tJyiJMCh-TcjsUhpp9cxc0Mmgn5pglI4R3hrU')--leoncio)

--select * from #TABLA_MSG
--==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
-- select top 10 * from rm_europiel.dbo.mobile_device_info 
-- select top 5     c.id_usuario,   d.id_device, d.os,*
-- from v_clientes_con_callcenter_activo c
-- join rm_europiel.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
-- join rm_europiel.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
-- join rm_europiel.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
-- join rm_europiel.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
-- where c.bloque='MTY1'
-- and s.callcenter_activo=1
-- AND d.id_device='eC9R2NfOtAQ:APA91bEzzWh0Lb1S8WqXw4S3KWJYJCLcyLuTzpRC0SLoU--8DvnIM4Bu5LgSCXXAYKjAcY78XXP9K1nXZxyRHk3T27HMG-y7WGxHyBZlLsxD0Rgr3lNKsmaMO2x3uxn1XCeHA-cblQFI'--leoncio
-- select top 5 * from rm_europiel.dbo.usuario where telefono_personal like '%2281832312%'

--==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
/*
MTY2
--====================
*/
UNION ALL
select distinct 5, c.id_usuario, s.id_bloque,b.abreviatura, d.id_device, d.os, p.fecha_alta,
		payload=CONCAT('{"registration_ids":["' + d.id_device + '"],',@MSG_ANDROID)
from v_clientes_con_callcenter_activo c
join rm_europiel_mty2.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel_mty2.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_mty2.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_mty2.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='MTY2'
and s.callcenter_activo=1
and isnull((SELECT TOP 1 os_version FROM rm_europiel_mty2..mobile_user_login WITH(NOLOCK) WHERE id_usuario = p.id_paciente AND action = 'Login' ORDER BY id DESC),0)  not in  (@VERSION)
--and (not exists (select 1 from notifier_mensajes n (nolock) where id_notifier=5 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
--	or exists (select 1 from notifier_mensajes n (nolock) where id_notifier=5 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
--				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
--	)
--==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
/*
SIN1
--====================
*/
UNION ALL
select distinct 5, c.id_usuario, s.id_bloque, b.abreviatura, d.id_device, d.os, p.fecha_alta,
		payload=CONCAT('{"registration_ids":["' + d.id_device + '"],',@MSG_ANDROID)
from v_clientes_con_callcenter_activo c
join rm_europiel_guadalajara.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel_guadalajara.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_guadalajara.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_guadalajara.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='SIN1'
and s.callcenter_activo=1
and isnull((SELECT TOP 1 os_version FROM rm_europiel_guadalajara..mobile_user_login WITH(NOLOCK) WHERE id_usuario = p.id_paciente AND action = 'Login' ORDER BY id DESC),0)  not in  (@VERSION)
--and (not exists (select 1 from notifier_mensajes n (nolock) where id_notifier=5 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
--	or exists (select 1 from notifier_mensajes n (nolock) where id_notifier=5 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
--				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
--	)
--==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
/*
SIN2
--====================
*/
UNION ALL
select distinct 5, c.id_usuario, s.id_bloque, b.abreviatura, d.id_device, d.os, p.fecha_alta,
		payload=CONCAT('{"registration_ids":["' + d.id_device + '"],',@MSG_ANDROID)
from v_clientes_con_callcenter_activo c
join rm_europiel_juarez.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel_juarez.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_juarez.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_juarez.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='SIN2'
and s.callcenter_activo=1
and isnull((SELECT TOP 1 os_version FROM rm_europiel_juarez..mobile_user_login WITH(NOLOCK) WHERE id_usuario = p.id_paciente AND action = 'Login' ORDER BY id DESC),0)  not in  (@VERSION)
--and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
--	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
--				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
--	)
--==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
/*
HON,SIN3,CRI1
--====================
*/
UNION ALL
select distinct 5, c.id_usuario, s.id_bloque, b.abreviatura, d.id_device, d.os, p.fecha_alta,
		payload=CONCAT('{"registration_ids":["' + d.id_device + '"],',@MSG_ANDROID)
from v_clientes_con_callcenter_activo c
join rm_europiel_sinergia3.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel_sinergia3.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_sinergia3.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_sinergia3.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='SIN3'
and s.callcenter_activo=1
and isnull((SELECT TOP 1 os_version FROM rm_europiel_sinergia3..mobile_user_login WITH(NOLOCK) WHERE id_usuario = p.id_paciente AND action = 'Login' ORDER BY id DESC),0)  not in  (@VERSION)
--and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
--	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
--				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
--	)
--ESPA�A========================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
/*
ESP1,ESP2
--====================
*/
UNION ALL
select distinct 5, c.id_usuario, s.id_bloque, b.abreviatura, d.id_device, d.os,p.fecha_alta,
		payload=CONCAT('{"registration_ids":["' + d.id_device + '"],',@MSG_ANDROID)
from v_clientes_con_callcenter_activo c
join rm_europiel_espana.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel_espana.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_espana.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_espana.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='ESP'
and s.id_pais not in (2,4) --COLOMBIA
and isnull((SELECT TOP 1 os_version FROM rm_europiel_espana..mobile_user_login WITH(NOLOCK) WHERE id_usuario = p.id_paciente AND action = 'Login' ORDER BY id DESC),0)  not in  (@VERSION)
--and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
--	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
--				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
--	) 

--==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
--ANTES DE MANDAR LOS MENSAJES, VERIFICAR QUE NO HAYA DUPLICADOS, ES DECIR QUE SOLO SE ENVIE UN MENSAJE POR CLIENTE
--insert into notifier_mensajes (id_notifier,id_usuario,id_bloque,bloque,device_token,mobile_os,payload)
select *
from #TABLA_MSG
order by fecha_alta_paciente desc
------------------------------------------------------
DROP TABLE IF EXISTS #USERS_BORRAR
DROP TABLE IF EXISTS #MSG_BORRAR
DROP TABLE IF EXISTS #MSG_SALVAR
SELECT TOP 1 * INTO #MSG_SALVAR FROM #TABLA_MSG 
TRUNCATE TABLE #MSG_SALVAR
select  id_usuario,COUNT(*) Cantidad into #USERS_BORRAR from #TABLA_MSG GROUP BY  id_usuario HAVING COUNT(*)>1 ORDER BY 2 DESC

DECLARE @LIMITE INT=(SELECT COUNT(*) FROM #USERS_BORRAR)
DECLARE @CONT INT=1
DECLARE @ID_USER INT
WHILE @LIMITE>0
BEGIN
	SET @ID_USER =(SELECT TOP 1 id_usuario FROM #USERS_BORRAR)
	INSERT INTO #MSG_SALVAR (id_notifier,id_usuario,id_bloque,bloque,device_token,mobile_os,payload,fecha_alta_paciente)
	SELECT TOP 1 id_notifier,id_usuario,id_bloque,bloque,device_token,mobile_os,payload,fecha_alta_paciente FROM #TABLA_MSG WHERE id_usuario =@ID_USER --ORDER BY fecha_alta_paciente DESC
	DELETE FROM #USERS_BORRAR WHERE ID_USUARIO =@ID_USER

	set @LIMITE=(SELECT COUNT(*) FROM #USERS_BORRAR)
	SET @CONT=@CONT+1
	print concat('Contador: ',@CONT,' Limite: ',@LIMITE)
	-- if @CONT=10000
	-- 	BREAK;
END

select id_usuario,COUNT(*) Cantidad from #TABLA_MSG GROUP BY  id_usuario HAVING COUNT(*)>1 ORDER BY 2 DESC

drop table if exists #NUEVA_TABLA
SELECT * INTO #NUEVA_TABLA FROM #TABLA_MSG
delete from #NUEVA_TABLA WHERE id_usuario IN(SELECT id_usuario FROM #MSG_SALVAR)
 DROP TABLE IF EXISTS #TABLA_ENVIAR
 go
WITH TABLA_FINAL AS
(
	SELECT * FROM #NUEVA_TABLA
	UNION
	SELECT * FROM #MSG_SALVAR

)



SELECT id_notifier,id_usuario,id_bloque,bloque,device_token,mobile_os,payload into #TABLA_ENVIAR FROM  TABLA_FINAL
------------------------------------------------------------------------------------------
insert into rm_europiel_requerimientos.dbo.notifier_mensajes (id_notifier,id_usuario,id_bloque,bloque,device_token,mobile_os,payload)
SELECT * FROM #TABLA_ENVIAR


--SELECT id_usuario,bloque, count(*) FROM #TABLA_ENVIAR GROUP BY id_usuario,bloque having count(*)>1

--18299	--ROBERTO
--58043	--LEONCIO
--58041 ANTHONY
--15515 LARISSA NAYELI
--19484 KARLA ESTHER
--32747 MA GUADALUPE
/*
select * from #TABLA_MSG
SELECT TOP 10 * FROM rm_europiel..mobile_device_info 
WHERE id_paciente=59966 --order by id_detalle desc
 --and id_device='cbutLFsHtXM:APA91bHS9rnRcOusAbyprlcUnxyUz5xJYtCHSLLrAGz_J0AS8wbjTMUqmgfeDXYzlIB64bcZyB75EmmXBzAkmAsWY7EGwLIjv8T9KyFK7q8hOpdLxfBNQOmyViUs6wWfyLqvleVJUpuZ' 
 ORDER BY fecha_registro DESC--PARA OBTENER EL DEVICE DEL USUARIO

SELECT  * FROM rm_europiel..mobile_device_info WHERE id_device='c8_AdwuUc88:APA91bEmIkmrrA09VuoRzssV_h0hYKntsJiMHvjFBbCScjJW39KRhy2k200Voh9OcIFVdMNNWxpE70Cw9dzLrKS7H3BlLKtDlf5Roc0-nok8AyGxgilBCsQJ1btqsFHo7hS0_EW0RMKc'
SELECT * FROM rm_europiel_MTY2..PACIENTE WHERE id_paciente=32747
SELECT * FROM rm_europiel..PACIENTE WHERE ap_paterno like'%shica%'
--delete from  rm_europiel..mobile_device_info  WHERE id_paciente in(58042) and id_device='eC9R2NfOtAQ:APA91bEzzWh0Lb1S8WqXw4S3KWJYJCLcyLuTzpRC0SLoU--8DvnIM4Bu5LgSCXXAYKjAcY78XXP9K1nXZxyRHk3T27HMG-y7WGxHyBZlLsxD0Rgr3lNKsmaMO2x3uxn1XCeHA-cblQFI'

--==========================*************FIN************=========================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
			
----and d.id_device='c8_AdwuUc88:APA91bEmIkmrrA09VuoRzssV_h0hYKntsJiMHvjFBbCScjJW39KRhy2k200Voh9OcIFVdMNNWxpE70Cw9dzLrKS7H3BlLKtDlf5Roc0-nok8AyGxgilBCsQJ1btqsFHo7hS0_EW0RMKc'



select * from notifier_mensajes where 
id_usuario=58043  
--and cast(fecha_envio as date)=cast(getdate() as date)
and mobile_os='Android'
order by id_detalle desc
SELECT TOP 1 * FROM rm_europiel.dbo.mobile_user_login r where  r.device_type ='android' and r.id_usuario=58041 and r.device_model like '%plus%' 
--and cast((select value from string_split('3.9','.')) as integer)<8
order by id desc

--SELECT * FROM #TABLA_MSG

--update notifier_mensajes
--set payload=replace(replace(payload,'{id_device}',device_token),'{id_detalle_mensaje}',convert(varchar(32),id_detalle))
--where id_notifier = 2704

----where id_usuario='58041'
--SELECT TOP 10 * FROM rm_europiel.dbo.mobile_device_info where id_paciente='58041' 
--and cast(fecha_registro as date)=cast(getdate() as date)
--SELECT TOP 10 * FROM rm_europiel.dbo.PACIENTE

--SELECT TOP 10 * FROM v_clientes_con_callcenter_activo


--select top 10  * from notifier_mensajes WHERE id_detalle='14410169'

--UPDATE notifier_mensajes SET fecha_alta_registro = GETDATE()-2 , id_notifier=5 WHERE id_detalle='14410169' 

--SELECT GETDATE()-2

*/