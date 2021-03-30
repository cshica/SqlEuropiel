DECLARE @MSG_ANDROID NVARCHAR(MAX)='"data":{"messageId":"1", "posterUrl":"https://europiel-system-files.s3.amazonaws.com/AppEuropielAndroid/POP_UP_ActualizaApp.jpg", "url":"https://europiel.com.mx","linkUrl":"https://europiel-system-files.s3.amazonaws.com/AppEuropielAndroid/POP_UP_ActualizaApp.jpg", "Category":"POPUP_INAPP"}}'
DECLARE @VERSION NVARCHAR(10)
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

from v_clientes_con_callcenter_activo c
join rm_europiel.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='MTY1'
and s.callcenter_activo=1

--and (not exists (select 1 from notifier_mensajes n (nolock) where id_notifier=5 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
--	or exists (select 1 from notifier_mensajes n (nolock) where id_notifier=5 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
--				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
--	)
--AND d.id_device='c8_AdwuUc88:APA91bEmIkmrrA09VuoRzssV_h0hYKntsJiMHvjFBbCScjJW39KRhy2k200Voh9OcIFVdMNNWxpE70Cw9dzLrKS7H3BlLKtDlf5Roc0-nok8AyGxgilBCsQJ1btqsFHo7hS0_EW0RMKc'
--select * from #TABLA_MSG

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
select distinct 5, c.id_usuario, s.id_bloque, b.abreviatura, d.id_device, d.os,
		payload=CONCAT('{"registration_ids":["' + d.id_device + '"],',@MSG_ANDROID)
from v_clientes_con_callcenter_activo c
join rm_europiel_espana.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel_espana.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_espana.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_espana.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='ESP'
and s.id_pais not in (2,4) --COLOMBIA
--and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
--	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
--				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
--	) 

--==============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================

insert into notifier_mensajes (id_notifier,id_usuario,id_bloque,bloque,device_token,mobile_os,payload)
select id_notifier,id_usuario,id_bloque,bloque,device_token,mobile_os,payload
from #TABLA_MSG
order by fecha_alta_paciente desc



--==========================*************FIN************=========================================================================================================================================================================================================================================================================================================================================================================================================================================================================================
			
----and d.id_device='c8_AdwuUc88:APA91bEmIkmrrA09VuoRzssV_h0hYKntsJiMHvjFBbCScjJW39KRhy2k200Voh9OcIFVdMNNWxpE70Cw9dzLrKS7H3BlLKtDlf5Roc0-nok8AyGxgilBCsQJ1btqsFHo7hS0_EW0RMKc'



select * from notifier_mensajes where 
id_usuario=58041  
and cast(fecha_envio as date)=cast(getdate() as date)
and mobile_os='Android'

SELECT TOP 1 * FROM rm_europiel.dbo.mobile_user_login r where  r.device_type ='android' and r.id_usuario=58041 and r.device_model like '%plus%' 
and cast((select value from string_split('3.9','.')) as integer)<8
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