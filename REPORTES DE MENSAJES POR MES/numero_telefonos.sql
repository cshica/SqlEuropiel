drop table if exists #telefonos
create table #telefonos(numero varchar(50))
insert into #telefonos
select 'whatsapp:+14156045784' 	t union
select 'whatsapp:+14156045985'	t union
select 'whatsapp:+14157022948'	t union
select 'whatsapp:+14157024072'	t union
select 'whatsapp:+14159149730'	t union
select 'whatsapp:+14159158429'	t union
select 'whatsapp:+14159416424'	t union
select 'whatsapp:+14159934412'	t union
select 'whatsapp:+14159938354'	t union
select 'whatsapp:+19794645556'	t  union
select 'whatsapp:+5218120858069' t ; 
select * from #telefonos

drop table if exists #tabla_total
select  body, count(*) cantidad ,abs(sum(Price)) precio into #tabla_total from Paso2_abril  
where   From_ in( select numero from #telefonos) and
--and Body like '%¡Bienvenid@ a Europiel%'
-- and cast(DateCreated as date)=cast('2021-04-08' as date)
 body  like  '%¡Bienvenid@ a Europiel%' --1
--  and body not LIKE '%Subdirector:%'--2
--  and Body not like '%¡Hola! Te invitamos a agendar tu cita en nuestra App. Te recordamos que ya estamos abiertos en tu sucursal%'--3
--  and Body not like '%Por favor activa  tus sesiones mediante la App respondiendo SI a este mensaje%'--4
--  and body not like '%Por favor activa tus sesiones mediante la App respondiendo SI a este mensaje%'--5
--  and Body not like '%hemos terminado tu tratamiento en área de%'--6
--  and Body not like '%Es la segunda vez que agendas una cita en Europiel y no te presentas.%'--7
--  and Body not like '%! Tu número de acceso de un solo uso es%'--8
--  and Body not like '%! Bienvenida a Europiel. Tu número de acceso de un solo uso es%'--9
--  and Body not like '%Para confirmar su cita pulse aquí http://citas.europiel.com.mx/ConfirmarCita.aspx%'--10
--  and Body not like '%*Recuerda* que no puedes traer desodorante maquillaje cremas loción ni ninguna sustancia ni químico en la piel. Así mismo debes venir rasurado(a) con rastrillo el mismo día de tu cita.%'--11
--  and body not like '%Recuerda que no puedes traer desodorante maquillaje cremas loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita%'--12
--  and Body not like '%Gracias por tu preferencia. Hemos recibido  un pago por%'--13
--  and Body not like '%ha tenido que cancelarse por causas de fuerza mayor. Te invitamos a reagendar en otra fecha.%'--14
--  and Body not like 'Tu OTP es%'--15
--  and Body not like '%! Bienvenido a Europiel. Tu número de acceso de un solo uso es%'--16
--  and Body not like '%Mensaje automático, favor de no responder.%'--17
--  and Body not like '%Gracias por tu confirmación, tu paquete se ha activado correctamente.%'--18
--  and Body not like '%Gracias por tu confirmación, tu área ha sido activada correctamente.%'--19
--  and Body not like '%Gracias por tu reporte, revisaremos tu caso lo antes posible.%'--20
--  and Body not like '%Su cita ha sido confirmada!!%' --21
--  and Body not like '%Su cita fue cancelada%' --22
--  and Body not like '%El usuario *Octon* ha realizado *4* cambio(s) en los potenciales, quieres ver el detalle?%'--23
--  and Body not like '%El usuario *Octon* ha realizado *8* cambio(s) en los potenciales, quieres ver el detalle?%'--24
--  and Body not like '%ha cambiado el potencial de%'--25
--  and Body not like '%Hey ya! Great to see you here. Btw, nothing is configured for this request path. Create a rule and start building a mock API.%'--26
group by Body
order by body asc
select sum(cantidad),sum(precio) from #tabla_total
--select sum(precio) from #tabla_total

select len('¡Hola! Te invitamos a agendar tu cita en nuestra App. Te recordamos que ya estamos abiertos en tu sucursal')
truncate table PLANTILLA
truncate TABLE PLANTILLA_DETALLE
insert into PLANTILLA(Body) VALUES
('¡Bienvenid@ a Europiel'),('Subdirector:'),('¡Hola! Te invitamos a agendar tu cita en nuestra App. Te recordamos que ya estamos abiertos en tu sucursal'),
('Por favor activa  tus sesiones mediante la App respondiendo SI a este mensaje'),('hemos terminado tu tratamiento en área de'),
('Por favor activa tus sesiones mediante la App respondiendo SI a este mensaje'),('Es la segunda vez que agendas una cita en Europiel y no te presentas.'),
('! Tu número de acceso de un solo uso es'),('! Bienvenida a Europiel. Tu número de acceso de un solo uso es'),('Para confirmar su cita pulse aquí http://citas.europiel.com.mx/ConfirmarCita.aspx'),
('*Recuerda* que no puedes traer desodorante maquillaje cremas loción ni ninguna sustancia ni químico en la piel. Así mismo debes venir rasurado(a) con rastrillo el mismo día de tu cita.'),
('Recuerda que no puedes traer desodorante maquillaje cremas loción ni ninguna sustancia ni químico en la piel , así mismo debes venir rasurada con rastrillo el mismo día de tu cita'),
('Gracias por tu preferencia. Hemos recibido  un pago por'),('ha tenido que cancelarse por causas de fuerza mayor. Te invitamos a reagendar en otra fecha.'),('Tu OTP es'),
('! Bienvenido a Europiel. Tu número de acceso de un solo uso es'),('Mensaje automático, favor de no responder.'),('Gracias por tu confirmación, tu paquete se ha activado correctamente.'),
('Gracias por tu confirmación, tu área ha sido activada correctamente.'),('Gracias por tu reporte, revisaremos tu caso lo antes posible.'),('Su cita ha sido confirmada!!'),('Su cita fue cancelada'),
('El usuario *Octon* ha realizado *4* cambio(s) en los potenciales, quieres ver el detalle?'),('El usuario *Octon* ha realizado *8* cambio(s) en los potenciales, quieres ver el detalle'),('ha cambiado el potencial de'),
('Hey ya! Great to see you here. Btw, nothing is configured for this request path. Create a rule and start building a mock API.')

insert into PLANTILLA_DETALLE(IdPlantilla,EnviosPorMes,Mes,Costo)
 VALUES
 (1,2016,4,42.2271)
 ,(2,2,4,0)
 ,(3,3362,4,79.4850)
 ,(4,633,4,8.9335)

 ,(5,3687,4,68.5553),(6,4269,4,72.79)
 ,(7,11262,4,3.8616),(8,29520,4,583.8645)
 ,(9,4020,4,85.0751),(10,93762,4,1895.6688)
 ,(11,237,4,2.164),(12,175566,4,3480.4836)
 ,(13,4678,4,93.7876),(14,5928,4,124.516)
 ,(15,1120,4,16.7404),(16,34,4,0.725)
 ,(17,16968,4,64.162),(18,2785,4,6.412)
 ,(19,1494,4,3.78),(20,813,4,1.764)
 ,(21,62,4,0),(22,5,4,0),(23,1,4,0.014)
 ,(24,1,4,0.014),(25,2,4,0),(26,1,4,0)


