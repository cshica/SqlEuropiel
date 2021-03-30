select * from v_sucursales where descripcion in ('Tampico','Tlaquepaque 2','Ciudadela Gdj','Plaza San Luis','Coatzacoalcos')
--ATENDIDOS POR CADA SUCURSAL: Son los que tubieron una cita y se genero su expediente
select year(ex.fecha_registro), mes=dbo.fn_nombre_mes(month(ex.fecha_registro),0), s.descripcion, atendidos=COUNT(*)
from expediente_servicio ex
join paciente p (nolock) on ex.id_paciente=p.id_paciente
join sucursal s (nolock) on s.id_sucursal=p.id_sucursal_2
where p.id_sucursal_2 in (4,12) --4 Coatzacoalcos 12 Plaza San Luis --3	Ciudadela Gdj --12	Tampico 3	Tlaquepaque 2
and year(ex.fecha_registro)>=2020
and exists(select 1 from paquete_servicio ps where ps.id_paciente=p.id_paciente)
--and exists(select 1 from expediente_servicio ps where ps.id_paciente=p.id_paciente)
group by year(ex.fecha_registro), month(ex.fecha_registro), s.descripcion
order by s.descripcion, year(ex.fecha_registro), month(ex.fecha_registro)

--------------------------------------------------------------------------------------------
select top 10 * from PAQUETE order by id_paquete desc
select top 10 * from PAQUETE_SERVICIO order by  id_paquete desc
--------------------------------------------------------------------------------------------
SELECT top 10 p.id_sucursal_2,* 
FROM expediente_servicio ES

INNER JOIN PACIENTE P ON ES.id_paciente=P.id_paciente
INNER JOIN SUCURSAL S ON p.id_sucursal_2= s.id_sucursal
where p.id_paciente=11886

SELECT * FROM expediente_servicio_detalle
WHERE id_expediente=170860


SELECT * FROM SERVICIO WHERE id_servicio=3006