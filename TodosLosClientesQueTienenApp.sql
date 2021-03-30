/*=====================================================================
SE DEBE CAMBIAR EL ID_NOTIFGIER=1 POR EL VALOR QUE CORRESPONDA
=====================================================================*/

select   s.id_bloque,b.abreviatura
from v_clientes_con_callcenter_activo c
join rm_europiel_espana.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel_espana.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_espana.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_espana.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='ESP'
and s.id_pais not in (2,4) --COLOMBIA
and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
	)
GROUP BY  s.id_bloque,b.abreviatura
union all
select   s.id_bloque,b.abreviatura
from v_clientes_con_callcenter_activo c
join rm_europiel_sinergia3.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario
join rm_europiel_sinergia3.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_sinergia3.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_sinergia3.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='SIN3'
and s.callcenter_activo=1
and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
	)
GROUP BY   s.id_bloque,s.id_bloque,b.abreviatura
UNION ALL
select   s.id_bloque,b.abreviatura
from v_clientes_con_callcenter_activo c
join rm_europiel_juarez.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario
join rm_europiel_juarez.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_juarez.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_juarez.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='SIN2'
and s.callcenter_activo=1
and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=1 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
	)

GROUP BY   s.id_bloque,b.abreviatura
UNION ALL
select   s.id_bloque,b.abreviatura
from v_clientes_con_callcenter_activo c
join rm_europiel_guadalajara.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario
join rm_europiel_guadalajara.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_guadalajara.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_guadalajara.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='SIN1'
and s.callcenter_activo=1
and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
	)
GROUP BY    s.id_bloque,b.abreviatura
UNION ALL
select   s.id_bloque,b.abreviatura
from v_clientes_con_callcenter_activo c
join rm_europiel_mty2.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario
join rm_europiel_mty2.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_mty2.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_mty2.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='MTY2'
and s.callcenter_activo=1
and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
	)
GROUP BY   s.id_bloque,b.abreviatura
UNION ALL
select   s.id_bloque,b.abreviatura
from v_clientes_con_callcenter_activo c
join rm_europiel.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario
join rm_europiel.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='MTY1'
and s.callcenter_activo=1
and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
	)
GROUP BY   s.id_bloque,b.abreviatura


union all
select   s.id_bloque, s.bloque2
from v_clientes_con_callcenter_activo c
join rm_europiel_usa1.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario and d.os='Android'
join rm_europiel_usa1.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join v_sucursales s (nolock) on s.id_sucursal=p.id_sucursal --and s.bloque='USA'
where s.bloque='USA1'
and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
	)
GROUP BY   s.id_bloque,s.bloque2
--=================================================================================================
--agrupacion de empresas por bloques
SELECT bloque,bloque2,PAIS  FROM v_sucursales GROUP BY bloque,bloque2,PAIS 

