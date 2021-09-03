DECLARE @FECHA_INI DATE='20210901'--CAST(GETDATE()-3 AS DATE)
DECLARE @FECHA_FIN DATE=CAST(GETDATE() AS DATE)

drop table if exists #tabla
select  
		b.id_paciente
		,T.IdLlamada
		,t.ClienteId
		,b.id_cliente_callcenter
		,b.observaciones
		,b.bloque
		,t.IdBloque
		,b.id_tipo_reporte
		,(select tp.descripcion from bitacora_callcenter_tipo_reporte tp where tp.id_tipo_reporte=b.id_tipo_reporte) tipo_reporte
		,b.fecha_registro
		,t.HoraInicioLlamada
		,t.IdSucursal
		,t.Sucursal
		,t.NombreCliente
		,dbo.fn_Obtener_Agente_Mail_Twilio(replace(replace(b.id_agente,'client:',''),'_40europiel_2Ecom_2Emx','@europiel.com.mx')) agente
		,Tipo = 'Mes'
		,b.Problema
		,b.Solucion
		,b.folio
		
		into #tabla
		from LLAMADAS_TWILIO (nolock)  t
		inner  join bitacora_callcenter (nolock)  b on t.ClienteId=b.id_cliente_callcenter --and b.bloque=t.Bloque 
		where 
		
		 
		REPLACE(REPLACE(B.id_agente,'client:',''),'_40europiel_2Ecom_2Emx','@europiel.com.mx')=T.Agente
		and (cast(b.fecha_registro as date) BETWEEN @FECHA_INI AND @FECHA_FIN)
		and (cast( t.HoraInicioLlamada as date) BETWEEN @FECHA_INI AND @FECHA_FIN)
		-- b.id_sucursal=t.IdSucursal
		--month(b.fecha_registro)=month(GETDATE()) 
		--and year(b.fecha_registro)=year(getdate()) 
		--and t.NombreCliente like '%trejo lomeli%'

		--and b.id_tipo_reporte=@ID_TIPO_REPORTE
		--AND B.id_sucursal=t.IdSucursal
		group by 
		b.id_paciente
		,T.IdLlamada
		,t.ClienteId
		,b.id_cliente_callcenter
		,b.observaciones
		,b.bloque
		,t.IdBloque
		,b.id_tipo_reporte
		,b.fecha_registro
		,t.HoraInicioLlamada
		,t.IdSucursal
		,t.Sucursal
		,t.NombreCliente
		,b.id_agente
		,b.Problema
		,b.Solucion
		,b.folio
		
		order by b.fecha_registro desc	



		select * from #tabla-- where NombreCliente like'%MARIELA TREJO LOMELI%' 
		order by Sucursal ASC

		select * from bitacora_callcenter WHERE folio IN ('TW113929','TW113922')



		SELECT * FROM bitacora_callcenter_tipo_reporte 