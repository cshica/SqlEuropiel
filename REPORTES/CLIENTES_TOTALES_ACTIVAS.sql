--CLIENTE TOTALES CON ÁREAS ACTIVAS, ES DECIR CLIENTES QUE COMPRARON ÁREAS y que no fueron dados de alta, por lo tanto no deben tener registros en la tabla paquete_servicio_alta
select s.descripcion, totales=COUNT(*)
from paciente p (nolock)
join sucursal s (nolock) on s.id_sucursal=p.id_sucursal_2
where p.id_sucursal_2 in (4,12) --4 Coatzacoalcos 12 Plaza San Luis --3	Ciudadela Gdj --12	Tampico 3	Tlaquepaque 2
and (select COUNT(*)
			from paquete_servicio ps
			where ps.id_paciente=p.id_paciente
			and not exists(select 1 from paquete_servicio_alta a (nolock)
						where a.id_paciente=ps.id_paciente
						and a.id_paquete=ps.id_paquete
						and a.id_servicio=ps.id_servicio))>0
group by s.descripcion

-------------------------------------------------------------
select * from PAQUETE where fecha_compra='2019-02-01'
declare @paciente int =20180

select * from PACIENTE where id_paciente=@paciente

--clentes con área activa: 
select top 100 * from PAQUETE_SERVICIO where id_paciente=@paciente
--pero que no esté en 
select top 10 * from paquete_servicio_alta where id_paciente=@paciente

select * from SERVICIO where id_servicio in(5980,3012,3017)
