--NUMERO DE CANCELACIONES POR SUCURSAL

select year(pc.fecha_compra), mes=dbo.fn_nombre_mes(month(pc.fecha_compra),0), s.descripcion, COUNT(*)
from PAQUETE_CANCELADO pc (nolock)
join sucursal s (nolock) on s.id_sucursal=pc.id_sucursal_origen
where pc.id_sucursal_origen in (4,12) --4 Coatzacoalcos 12 Plaza San Luis --3	Ciudadela Gdj --12	Tampico 3	Tlaquepaque 2
and year(pc.fecha_compra)>=2020
group by year(pc.fecha_compra), month(pc.fecha_compra), s.descripcion
order by s.descripcion, year(pc.fecha_compra), month(pc.fecha_compra)