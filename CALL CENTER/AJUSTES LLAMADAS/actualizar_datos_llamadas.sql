--actualiza los datos una llamada segun el ID del CLIENTE QUE REALIZO la llamada

update LLAMADAS_TWILIO   set 
LLAMADAS_TWILIO.IdBloque=c.id_bloque 
,LLAMADAS_TWILIO.Bloque=c.bloque
,LLAMADAS_TWILIO.IdSucursal=c.id_sucursal
,LLAMADAS_TWILIO.Sucursal=c.sucursal
,LLAMADAS_TWILIO.IdPais=c.id_pais
--,LLAMADAS_TWILIO.Pais=c.pai 
--,LLAMADAS_TWILIO.CodPais=c.cod 
,LLAMADAS_TWILIO.UrlSistema=c.url_sistema
,LLAMADAS_TWILIO.BloqueHijo=c.bloque2 
from  clientes_global c where   c.claveAcceso=LLAMADAS_TWILIO.ClienteId and LLAMADAS_TWILIO.IdLlamada IN('CA63599b3ee6c899d1183ef977a0127444')

--para actualizar el pais
update LLAMADAS_TWILIO
set 
LLAMADAS_TWILIO.Pais=p.nombre
,LLAMADAS_TWILIO.CodPais=p.country_code
FROM rm_europiel.dbo.PAIS  p where LLAMADAS_TWILIO.IdPais=p.id_pais and LLAMADAS_TWILIO.IdLlamada IN('CA63599b3ee6c899d1183ef977a0127444')


--------------------------------------------

declare @id nvarchar(200)
declare @finllamada datetime
DECLARE CUR_S CURSOR
		FOR 
			SELECT IdLlamada,HoraFinLlamada FROM LLAMADAS_TWILIO
			WHERE UltimoEstado='verificar'
		OPEN CUR_S
			FETCH NEXT FROM CUR_S INTO @id,@finllamada
		WHILE @@FETCH_STATUS=0
		BEGIN
		
			exec ActualizarLLamadasTwilio @id,@finllamada


		FETCH NEXT FROM CUR_S INTO @id,@finllamada
		END
	CLOSE CUR_S
DEALLOCATE CUR_S




update LLAMADAS_TWILIO
set 
IdBloque=18
,bloque='MTY1'
,IdSucursal=39
,Sucursal='COSMOPOL 1'
,IdPais=1
,Pais='MEXICO'
,CodPais='MX'
,UrlSistema='http://mty4.europiel.com.mx/'
,BloqueHijo='MTY4'
where IdLlamada in('CA1f83cb5706a74c6917bbafcb8a774711','CAb5ad0d15c3cde6bb9723810a768f08c8')
