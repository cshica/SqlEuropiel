use rm_europiel;
SELECT top 10 * from whatsapp_interfaz where respuesta_cliente !='Si' order by id desc
--SELECT A TODAS LAS BASES DE DATOS
-- MENSAJES INSTANTANEOS WHATSAPP
select top 10 * from rm_europiel.dbo.whatsapp_interfaz union all--mty1
select top 10 * from rm_europiel_mty2.dbo.whatsapp_interfaz union all
select top 10 * from rm_europiel_guadalajara.dbo.whatsapp_interfaz union all--SIN1
select top 10 * from rm_europiel_juarez.dbo.whatsapp_interfaz union all--SIN2
select top 10 * from rm_europiel_sinergia3.dbo.whatsapp_interfaz union all--SIN3
select top 10 * from rm_europiel_espana.dbo.whatsapp_interfaz union all--ESP
select top 10 * from rm_europiel_usa1.dbo.whatsapp_interfaz union all--USA
select top 10 * from rm_dermapro.dbo.whatsapp_interfaz --DRP



SELECT top 10 * from whatsapp_interfaz where respuesta_cliente !='Si' order by id desc
-- MENSAJES PROGRAMADOS WHATSAPP
select top 100 * from notifier_mensajes where mobile_os='whatsapp' order by id_detalle desc
select * from webhook where data like '%SM24e4814b69cb4e23bca887430ffcfd7f%'