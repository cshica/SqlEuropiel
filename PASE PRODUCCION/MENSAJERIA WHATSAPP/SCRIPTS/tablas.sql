/******************************************************************************************************/
use rm_europiel_requerimientos
go
DROP TABLE IF EXISTS CONFIGURACIONES_MENSAJES_TWILIO
CREATE TABLE CONFIGURACIONES_MENSAJES_TWILIO
(
	Id int
	,Descripcion nvarchar(max)
	,HoraIncioEnvio time
	,HoraFinEnvio time
	,bloque varchar(10)
	,id_sucursal int
	,id_pais int
	,bd varchar(100)
	,plantilla_whatsapp nvarchar(max)
	,TOKEN NVARCHAR(300)
	,eviroment varchar(20)
	,tipomsg varchar(10)
	,dif_hora int
)
go

insert into CONFIGURACIONES_MENSAJES_TWILIO(id,Descripcion,HoraIncioEnvio,HoraFinEnvio)
values
(
	1
	,'Rango de horas que se enviarán los mensajes de Whastapp, se usa en rm_europiel_requerimientos.dbo.genera_notifier_mensajes_bienvenida_cliente'
	,'07:00:00' 
	,'21:00:00'
)
insert into CONFIGURACIONES_MENSAJES_TWILIO(id,Descripcion,bloque,dif_hora)
values
(2,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','MTY1',0)
,(3,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','MTY2',0)
,(4,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','MTY3',0)
,(5,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','MTY5',0)
,(6,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','SIN1',0)
,(7,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','SIN2',0)
,(8,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','SIN3',0)
,(9,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','SIN4',0)
,(10,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','USA1',1)
,(11,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','ESP1',8)
,(12,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','ESP2',8)
,(13,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','TEST',0)
,(14,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','DRP',0)
,(15,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','COL1',1)
,(16,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','COL2',1)
,(17,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','CRI1',0)
,(18,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','HON',0)
,(19,'Diferencia de horas por bloques, la comparación de horas es con respecto a México. Hora_Mexico+Dif_Hora=HoraActualDelPais ','BRA',3)
select * from CONFIGURACIONES_MENSAJES_TWILIO
GO
DROP TABLE IF EXISTS notifier_mensajes_whatsapp
GO
CREATE TABLE dbo.notifier_mensajes_whatsapp(
	[id_detalle] [int] IDENTITY(1,1) NOT NULL,
	[id_notifier] [int] NULL,
	[id_usuario] [int] NULL,
	[id_bloque] [int] NULL,
	[bloque] [varchar](8) NULL,
	[telefono] [varchar](32) NULL,
	[device_token] [varchar](512) NULL,
	[payload] [varchar](max) NULL,
	[fecha_envio] [datetime] NULL,
	[ultimo_estatus] [varchar](128) NULL,
	[fecha_ultimo_estatus] [datetime] NULL,
	[mobile_os] [varchar](8) NULL,
	[id_referencia] [varchar](64) NULL,
	[fecha_alta_registro] [datetime] NULL,
	[clave_acceso] [varchar](32) NULL,
	[emisor] [varchar](32) NULL,
	[nombre_cliente] [varchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[id_detalle] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


