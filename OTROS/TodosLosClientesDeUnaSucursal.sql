select * from rm_europiel_guadalajara.dbo.SUCURSAL where id_sucursal=14

select * from rm_europiel_guadalajara.dbo.bloque where abreviatura ='SIN1'



select  distinct 5, c.id_usuario,s.id_bloque,b.abreviatura,d.id_device,d.os,p.fecha_alta, s.descripcion
from v_clientes_con_callcenter_activo c
join rm_europiel_guadalajara.dbo.mobile_device_info d (nolock) on d.id_paciente=c.id_usuario
join rm_europiel_guadalajara.dbo.paciente p (nolock) on p.id_paciente=c.id_usuario
join rm_europiel_guadalajara.dbo.sucursal s (nolock) on s.id_sucursal=p.id_sucursal
join rm_europiel_guadalajara.dbo.bloque b (nolock) on b.id_bloque=s.id_bloque
where c.bloque='SIN1'
and s.callcenter_activo=1
and s.id_sucursal=14
and (not exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque)
	or exists (select 1 from notifier_mensajes n (nolock) where n.id_notifier=2 and n.id_usuario=c.id_usuario and n.id_bloque=s.id_bloque
				and (n.ultimo_estatus like '%Exception message%' or n.ultimo_estatus like '%Error en el servidor remoto%'))
	)
--GROUP BY    s.id_bloque,b.abreviatura