--NUMERO DE ATLAS POR SUCURSAL

--Número de altas 105	De Ventas del 2021:0
select year(ex.fecha_alta), mes=dbo.fn_nombre_mes(month(ex.fecha_alta),0), s.descripcion, COUNT(*) No_ALTAS
from paquete_servicio_alta ex (nolock)
join paciente p (nolock) on ex.id_paciente=p.id_paciente
join sucursal s (nolock) on s.id_sucursal=p.id_sucursal_2
where p.id_sucursal_2 in (4,12) --4 Coatzacoalcos 12 Plaza San Luis --3	Ciudadela Gdj --12	Tampico 3	Tlaquepaque 2
--and year(p.fecha_alta)=2021
and year(ex.fecha_alta)>=2020
group by year(ex.fecha_alta), month(ex.fecha_alta), s.descripcion
order by s.descripcion, year(ex.fecha_alta), month(ex.fecha_alta)