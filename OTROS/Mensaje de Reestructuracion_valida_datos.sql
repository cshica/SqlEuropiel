DROP TABLE IF EXISTS #TABLA
SELECT 
P.id_paciente, s.id_bloque, b.abreviatura, P.nombre, P.ap_paterno + ' ' + P.ap_materno apellidos,
		'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(P.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_1, 
		'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(P.telefono_2,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_2,
		clave_acceso = dbo.fn_clave_acceso(P.id_paciente)
		,dbo.fn_obtener_ultimo_pago_paquete(PQ.id_paquete) ULT_FECHA_PAGO
		, DATEDIFF(DAY, dbo.fn_obtener_ultimo_pago_paquete(PQ.id_paquete), GETDATE()) DIAS_RETRASO
		,PQ.saldo_total
		,PQ.contrato 
		,PQ.costo_total-PQ.anticipo total
INTO #TABLA 
FROM 
PACIENTE P (NOLOCK)
INNER JOIN SUCURSAL S (NOLOCK) ON S.id_sucursal=P.id_sucursal
INNER JOIN bloque B (NOLOCK) ON B.id_bloque=S.id_bloque
INNER JOIN PAIS PA (NOLOCK) ON PA.id_pais=S.id_pais
INNER JOIN PAQUETE (NOLOCK) PQ ON PQ.id_paciente=P.id_paciente
WHERE 
 
  PQ.fecha_compra>='2020-10-01'
  and (len(P.telefono_2) >= 10 or len(P.telefono_1) >= 10)
  and PQ.proviene_de_migracion = 0
  and PQ.no_disponible_por_migracion = 0
  and PQ.borrado_en_migracion = 0
  and PQ.saldo_total>6000
  and s.id_pais = 1
  AND DATEDIFF(DAY, dbo.fn_obtener_ultimo_pago_paquete(PQ.id_paquete), GETDATE())>60
  and not exists (select 1 
				 from rm_europiel_requerimientos.dbo.notifier_mensajes nm (nolock)
				 where nm.id_usuario = P.id_paciente
				 and nm.id_notifier = 13)


SELECT id_paciente, COUNT(*) FROM #TABLA	group by id_paciente having COUNT(*)>1
SELECT * FROM #TABLA
where 
apellidos='CARRILLO OBREGON'

--SELECT 
--rm_europiel.dbo.fn_obtener_ultimo_pago_paquete(74967)
--, DATEDIFF(DAY, rm_europiel.dbo.fn_obtener_ultimo_pago_paquete(74967), GETDATE())