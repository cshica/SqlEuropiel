SELECT * FROM v_clientes where telefono_2='8261065393'
select * from cita where id_paciente=58041

--se ejecuta para realizar pruebas
--despues de aceptar la cita por postma, o presionando los botones
-- resetea la cita par avolver a hacer preubas
update cita 
set 
fecha_confirmacion=NULL
,id_usuario_confirmacion=NULL
,tipo_confirmacion=NULL
,fecha_inicio=getdate()+1
,fecha_fin= getdate()+4
,estatus='N'
where id_cita=514


