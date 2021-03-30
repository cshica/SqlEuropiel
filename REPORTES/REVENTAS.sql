--REVENTAS:Es un cliente que ya fue vendido en alguna ocación, se le vuelve a vender

select year(p.fecha_compra), mes=dbo.fn_nombre_mes(month(p.fecha_compra),0), s.descripcion, COUNT(*) AREAS
from paquete p (nolock)
join sucursal s (nolock) on s.id_sucursal=p.id_sucursal_origen
join paquete_servicio ps (nolock) on ps.id_paquete=p.id_paquete --si comento esto me reporta el numero de paquetes
where year(p.fecha_compra)>=2020
and p.es_reventa=1
and s.id_sucursal in (4,12) --4 Coatzacoalcos 12 Plaza San Luis --3	Ciudadela Gdj --12	Tampico 3	Tlaquepaque 2
group by year(p.fecha_compra), month(p.fecha_compra), s.descripcion
order by s.descripcion, year(p.fecha_compra), month(p.fecha_compra)