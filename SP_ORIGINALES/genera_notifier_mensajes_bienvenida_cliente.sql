SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[genera_notifier_mensajes_bienvenida_cliente]
as
 begin
 
	create table #tblNotifierWhatsApp(
		id int identity(1,1) primary key,
		id_notifier int,
		id_usuario int,
		id_bloque int,
		bloque varchar(10),
		nombre varchar(128),
		clave_acceso varchar(16),
		telefono varchar(32),
		emmiter varchar(32),
		payload varchar(1024),
		en_lista_negra int default 0,
		nuevo_emmiter bit default (1),
		otp varchar(32),
		sexo varchar(8)
	);
	
	 /*
	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono, sexo)				
	   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
			   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
			   rm_europiel.dbo.fn_clave_acceso(p.id_paciente),
			'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_1,
			sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
		 from rm_europiel.dbo.paciente p (NOLOCK)
		 join rm_europiel.dbo.v_sucursales s (NOLOCK)on s.id_sucursal=p.id_sucursal and s.bloque='MTY1'
		 join rm_europiel.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
	    where p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_1,'') <> ''
		and p.fecha_envio_wp is null
		and len(left(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),pa.longitud_celulares)) = pa.longitud_celulares
		and pa.id_pais in (1,3,4,5,6)
		--and not exists (select 1 from notifier_mensajes nm (NOLOCK)
		--				where nm.id_notifier=5
		--				and nm.id_usuario=p.id_paciente
		--				and nm.id_bloque=s.id_bloque
		--				and nm.telefono='+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares))


	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
	   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
			   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
			   rm_europiel_mty2.dbo.fn_clave_acceso(p.id_paciente),
			'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_1,
			sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
		 from rm_europiel_mty2.dbo.paciente p (NOLOCK)
		 join rm_europiel_mty2.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='MTY2'
		 join rm_europiel_mty2.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
	    where p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_1,'') <> ''
		and p.fecha_envio_wp is null
		and len(left(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),pa.longitud_celulares)) = pa.longitud_celulares
		and pa.id_pais in (1,3,4,5,6)
		--and not exists (select 1 from notifier_mensajes nm (NOLOCK)
		--				where nm.id_notifier=5
		--				and nm.id_usuario=p.id_paciente
		--				and nm.id_bloque=s.id_bloque
		--				and nm.telefono='+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares))


	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
	   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
			   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
			   rm_europiel_guadalajara.dbo.fn_clave_acceso(p.id_paciente),
			'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_1,
			sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
		 from rm_europiel_guadalajara.dbo.paciente p (NOLOCK) 
		 join rm_europiel_guadalajara.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='SIN1'
		 join rm_europiel_guadalajara.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
	    where p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_1,'') <> ''
		and p.fecha_envio_wp is null
		and len(left(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),pa.longitud_celulares)) = pa.longitud_celulares
		and pa.id_pais in (1,3,4,5,6)
		--and not exists (select 1 from notifier_mensajes nm (NOLOCK)
		--				where nm.id_notifier=5
		--				and nm.id_usuario=p.id_paciente
		--				and nm.id_bloque=s.id_bloque
		--				and nm.telefono='+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares))


	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
	   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
			   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
			   rm_europiel_juarez.dbo.fn_clave_acceso(p.id_paciente),
			'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_1,
			sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
		 from rm_europiel_juarez.dbo.paciente p (NOLOCK) 
		 join rm_europiel_juarez.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='SIN2'
		 join rm_europiel_juarez.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais							 
	    where p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_1,'') <> ''
		and p.fecha_envio_wp is null
		and len(left(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),pa.longitud_celulares)) = pa.longitud_celulares
		and pa.id_pais in (1,3,4,5,6)
		--and not exists (select 1 from notifier_mensajes nm (NOLOCK)
		--				where nm.id_notifier=5
		--				and nm.id_usuario=p.id_paciente
		--				and nm.id_bloque=s.id_bloque
		--				and nm.telefono='+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares))



	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
	   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
			   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
			   rm_europiel_sinergia3.dbo.fn_clave_acceso(p.id_paciente),
			'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_1,
			sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
		 from rm_europiel_sinergia3.dbo.paciente p (NOLOCK)
		 join rm_europiel_sinergia3.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='SIN3'
		 join rm_europiel_sinergia3.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
	    where p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_1,'') <> ''
		and p.fecha_envio_wp is null
		and len(left(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),pa.longitud_celulares)) = pa.longitud_celulares
		and pa.id_pais in (1,3,4,5,6)
		--and not exists (select 1 from notifier_mensajes nm (NOLOCK)
		--				where nm.id_notifier=5
		--				and nm.id_usuario=p.id_paciente
		--				and nm.id_bloque=s.id_bloque
		--				and nm.telefono='+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares))



	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
	   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
			   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
			   rm_europiel_espana.dbo.fn_clave_acceso(p.id_paciente),
			'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_1,
			sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
		 from rm_europiel_espana.dbo.paciente p (NOLOCK) 
		 join rm_europiel_espana.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='ESP'
		 join rm_europiel_espana.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
	    where p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_1,'') <> ''
		and p.fecha_envio_wp is null
		and len(left(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),pa.longitud_celulares)) = pa.longitud_celulares
		and pa.id_pais in (1,3,4,5,6)		
		and getdate()>='2019-09-24 01:00:00'
		--and not exists (select 1 from notifier_mensajes nm (NOLOCK)
		--				where nm.id_notifier=5
		--				and nm.id_usuario=p.id_paciente
		--				and nm.id_bloque=s.id_bloque
		--				and nm.telefono='+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares))
	--union all
	--   select 5, p.id_paciente, s.id_bloque, s.bloque2, p.nombre, rm_dermapro.dbo.fn_clave_acceso(p.id_paciente),
	--		'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_1
	--	 from rm_dermapro.dbo.paciente p (NOLOCK) 
	--	 join rm_dermapro.dbo.v_sucursales s on s.id_sucursal=p.id_sucursal and s.bloque='DRP' 
	--	 join rm_dermapro.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
	--    where (p.fecha_alta > '20190918' and exists (select 1 from rm_dermapro.dbo.paquete paq (NOLOCK)
	--													where paq.fecha_compra > dateadd(yy,-1,getdate())
	--													and (paq.id_paciente=p.id_paciente or paq.id_paciente_2=p.id_paciente or
	--															paq.id_paciente_3=p.id_paciente or paq.id_paciente_4=p.id_paciente or paq.id_paciente_5=p.id_paciente)))
	--	and isNull(p.telefono_1,'') <> ''
	--	and p.fecha_envio_wp is null
	--	and len(left(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),pa.longitud_celulares)) = pa.longitud_celulares
	--	and pa.id_pais in (1,3,4,5,6)
	----	and not exists (select 1 from notifier_mensajes nm (NOLOCK)
	----					where nm.id_notifier=5
	----					and nm.id_usuario=p.id_paciente
	----					and nm.id_bloque=s.id_bloque
	----					and nm.telefono='+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares))
	--union all
	--   select 5, p.id_paciente, s.id_bloque, s.bloque2, p.nombre, rm_europiel_usa1.dbo.fn_clave_acceso(p.id_paciente),
	--		'+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares) as telefono_1
	--	 from rm_europiel_usa1.dbo.paciente p (NOLOCK)
	--	 join rm_europiel_usa1.dbo.v_sucursales s on s.id_sucursal=p.id_sucursal and s.bloque='USA1'
	--	 join rm_europiel_usa1.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
	--    where (p.fecha_alta > '20190918' and exists (select 1 from rm_europiel_usa1.dbo.paquete paq (NOLOCK)
	--													where paq.fecha_compra > dateadd(yy,-1,getdate())
	--													and (paq.id_paciente=p.id_paciente or paq.id_paciente_2=p.id_paciente or
	--														paq.id_paciente_3=p.id_paciente or paq.id_paciente_4=p.id_paciente or paq.id_paciente_5=p.id_paciente)))
	--	and isNull(p.telefono_1,'') <> ''
	--	and p.fecha_envio_wp is null
	--	and len(left(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),pa.longitud_celulares)) = pa.longitud_celulares
	--	and pa.id_pais in (1,3,4,5,6)
	----	and not exists (select 1 from notifier_mensajes nm (NOLOCK)
	----					where nm.id_notifier=5
	----					and nm.id_usuario=p.id_paciente
	----					and nm.id_bloque=s.id_bloque
	----					and nm.telefono='+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(replace(replace(p.telefono_1,' ',''),'-',''),'+',''),'044',''),'045',''),'(',''),')',''),pa.longitud_celulares))
	*/


    -- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	WITH ctePaso AS (
		SELECT
			s.id_bloque, p.id_paciente AS id_usuario
		FROM
			rm_europiel.dbo.PACIENTE p (nolock)
			INNER JOIN rm_europiel.dbo.SUCURSAL s (nolock) ON p.id_sucursal = s.id_sucursal
		WHERE
			p.fecha_alta > dateadd(day,-1,getdate())
			and isNull(p.telefono_2,'') <> ''
			and p.fecha_envio_wp is null
		GROUP BY
			s.id_bloque, p.id_paciente
	)
	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
					   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
						   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
						   rm_europiel.dbo.fn_clave_acceso(p.id_paciente),								
							telefono_2 = (case 
											when left(p.telefono_2,1) = '+' then p.telefono_2 
											else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
										   end),
							sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
						 from rm_europiel.dbo.paciente p (NOLOCK)
						 join rm_europiel.dbo.v_sucursales s (NOLOCK)on s.id_sucursal=p.id_sucursal and s.bloque='MTY1'
						 join rm_europiel.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
						 -- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
						 join ctePaso c ON c.id_bloque = s.id_bloque AND c.id_usuario = p.id_paciente
						where len(p.telefono_2)>6
						and pa.id_pais in (1,3,4,5,6)
						-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
						and not exists (select 1 from notifier_mensajes nm (NOLOCK)
										where nm.id_notifier=5
										and nm.id_usuario=p.id_paciente
										and nm.id_bloque=s.id_bloque
										and nm.payload like '%favor de no compartirlo con NADIE. Puedes solicitar uno nuevo desde tu App de Europiel.%');



	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	WITH ctePaso AS (
	SELECT
		s.id_bloque, p.id_paciente AS id_usuario
	FROM
		rm_europiel_mty2.dbo.PACIENTE p (nolock)
		INNER JOIN rm_europiel_mty2.dbo.SUCURSAL s (nolock) ON p.id_sucursal = s.id_sucursal
	WHERE
		p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_2,'') <> ''
		and p.fecha_envio_wp is null
	GROUP BY
		s.id_bloque, p.id_paciente
	)
	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
			   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
				   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
				   rm_europiel_mty2.dbo.fn_clave_acceso(p.id_paciente),
					telefono_2 = (case 
									when left(p.telefono_2,1) = '+' then p.telefono_2 
									else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
								   end),								
					sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
				 from rm_europiel_mty2.dbo.paciente p (NOLOCK)
				 join rm_europiel_mty2.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='MTY2'
				 join rm_europiel_mty2.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
				 -- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
				 join ctePaso c ON c.id_bloque = s.id_bloque AND c.id_usuario = p.id_paciente
				where len(p.telefono_2)>6
				and pa.id_pais in (1,3,4,5,6)
				-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
				and not exists (select 1 from notifier_mensajes nm (NOLOCK)
										where nm.id_notifier=5
										and nm.id_usuario=p.id_paciente
										and nm.id_bloque=s.id_bloque
										and nm.payload like '%favor de no compartirlo con NADIE. Puedes solicitar uno nuevo desde tu App de Europiel.%');



	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	WITH ctePaso AS (
	SELECT
		s.id_bloque, p.id_paciente AS id_usuario
	FROM
		rm_europiel_guadalajara.dbo.PACIENTE p (nolock)
		INNER JOIN rm_europiel_guadalajara.dbo.SUCURSAL s (nolock) ON p.id_sucursal = s.id_sucursal
	WHERE
		p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_2,'') <> ''
		and p.fecha_envio_wp is null
	GROUP BY
		s.id_bloque, p.id_paciente
	)
	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
			   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
				   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
				   rm_europiel_guadalajara.dbo.fn_clave_acceso(p.id_paciente),
					telefono_2 = (case 
									when left(p.telefono_2,1) = '+' then p.telefono_2 
									else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
								   end),
					sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
				 from rm_europiel_guadalajara.dbo.paciente p (NOLOCK)
				 join rm_europiel_guadalajara.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='SIN1'
				 join rm_europiel_guadalajara.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
				 -- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
				 join ctePaso c ON c.id_bloque = s.id_bloque AND c.id_usuario = p.id_paciente
				where len(p.telefono_2)>6
				and pa.id_pais in (1,3,4,5,6)
				-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
				and not exists (select 1 from notifier_mensajes nm (NOLOCK)
										where nm.id_notifier=5
										and nm.id_usuario=p.id_paciente
										and nm.id_bloque=s.id_bloque
										and nm.payload like '%favor de no compartirlo con NADIE. Puedes solicitar uno nuevo desde tu App de Europiel.%');


	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	WITH ctePaso AS (
	SELECT
		s.id_bloque, p.id_paciente AS id_usuario
	FROM
		rm_europiel_juarez.dbo.PACIENTE p (nolock)
		INNER JOIN rm_europiel_juarez.dbo.SUCURSAL s (nolock) ON p.id_sucursal = s.id_sucursal
	WHERE
		p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_2,'') <> ''
		and p.fecha_envio_wp is null
	GROUP BY
		s.id_bloque, p.id_paciente
	)
	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
			   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
				   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
				   rm_europiel_juarez.dbo.fn_clave_acceso(p.id_paciente),
					telefono_2 = (case 
									when left(p.telefono_2,1) = '+' then p.telefono_2 
									else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
								   end),
					sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
				 from rm_europiel_juarez.dbo.paciente p (NOLOCK)
				 join rm_europiel_juarez.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='SIN2'
				 join rm_europiel_juarez.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
				 -- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
				 join ctePaso c ON c.id_bloque = s.id_bloque AND c.id_usuario = p.id_paciente
				where len(p.telefono_2)>6
				and pa.id_pais in (1,3,4,5,6)
				-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
				and not exists (select 1 from notifier_mensajes nm (NOLOCK)
										where nm.id_notifier=5
										and nm.id_usuario=p.id_paciente
										and nm.id_bloque=s.id_bloque
										and nm.payload like '%favor de no compartirlo con NADIE. Puedes solicitar uno nuevo desde tu App de Europiel.%');



	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	WITH ctePaso AS (
	SELECT
		s.id_bloque, p.id_paciente AS id_usuario
	FROM
		rm_europiel_sinergia3.dbo.PACIENTE p (nolock)
		INNER JOIN rm_europiel_sinergia3.dbo.SUCURSAL s (nolock) ON p.id_sucursal = s.id_sucursal
	WHERE
		p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_2,'') <> ''
		and p.fecha_envio_wp is null
	GROUP BY
		s.id_bloque, p.id_paciente
	)
	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
			   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
				   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
				   rm_europiel_sinergia3.dbo.fn_clave_acceso(p.id_paciente),
					telefono_2 = (case 
									when left(p.telefono_2,1) = '+' then p.telefono_2 
									else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
								   end),
					sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
				 from rm_europiel_sinergia3.dbo.paciente p (NOLOCK)
				 join rm_europiel_sinergia3.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='SIN3'
				 join rm_europiel_sinergia3.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
				 -- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
				 join ctePaso c ON c.id_bloque = s.id_bloque AND c.id_usuario = p.id_paciente
				where len(p.telefono_2)>6
				and pa.id_pais in (1,3,4,5,6)
				-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
				and not exists (select 1 from notifier_mensajes nm (NOLOCK)
										where nm.id_notifier=5
										and nm.id_usuario=p.id_paciente
										and nm.id_bloque=s.id_bloque
										and nm.payload like '%favor de no compartirlo con NADIE. Puedes solicitar uno nuevo desde tu App de Europiel.%');



	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	WITH ctePaso AS (
	SELECT
		s.id_bloque, p.id_paciente AS id_usuario
	FROM
		rm_europiel_espana.dbo.PACIENTE p (nolock)
		INNER JOIN rm_europiel_espana.dbo.SUCURSAL s (nolock) ON p.id_sucursal = s.id_sucursal
	WHERE
		p.fecha_alta > dateadd(day,-1,getdate())
		and isNull(p.telefono_2,'') <> ''
		and p.fecha_envio_wp is null
	GROUP BY
		s.id_bloque, p.id_paciente
	)
	-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
	insert into #tblNotifierWhatsApp(id_notifier, id_usuario, id_bloque, bloque, nombre, clave_acceso, telefono,sexo)				
			   select 5, p.id_paciente, s.id_bloque, s.bloque2, 
				   nombre = SUBSTRING(p.nombre,1,(CHARINDEX(' ',p.nombre + ' ')-1)) + ' ' + p.ap_paterno, 
				   rm_europiel_espana.dbo.fn_clave_acceso(p.id_paciente),
					telefono_2 = (case 
									when left(p.telefono_2,1) = '+' then p.telefono_2 
									else '+' + pa.codigo_pais + left(replace(replace(replace(replace(replace(p.telefono_2,' ',''),'-',''),'+',''),'(',''),')',''),pa.longitud_celulares)
								   end),
					sexo = (case when isNull(p.sexo,'')='' then 'F' else p.sexo end)
				 from rm_europiel_espana.dbo.paciente p (NOLOCK) 
				 join rm_europiel_espana.dbo.v_sucursales s (NOLOCK) on s.id_sucursal=p.id_sucursal and s.bloque='ESP'
				 join rm_europiel_espana.dbo.pais pa (NOLOCK) on pa.id_pais = s.id_pais
				 -- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso
				 join ctePaso c ON c.id_bloque = s.id_bloque AND c.id_usuario = p.id_paciente
				where len(p.telefono_2)>6
				and pa.id_pais in (1,3,4,5,6)	
				-- HGU 2020-11-27 Se agregó validación para que no se manden mensajes en exceso                            
				and getdate()>='2019-09-24 01:00:00'
				and not exists (select 1 from notifier_mensajes nm (NOLOCK)
										where nm.id_notifier=5
										and nm.id_usuario=p.id_paciente
										and nm.id_bloque=s.id_bloque
										and nm.payload like '%favor de no compartirlo con NADIE. Puedes solicitar uno nuevo desde tu App de Europiel.%');


	update t
	   set t.en_lista_negra = x.en_lista_negra,
		   t.emmiter = x.emmiter
	  from #tblNotifierWhatsApp t
	  join whatsapp_estatus_telefono x (nolock) on x.telefono=t.telefono
			 
	update #tblNotifierWhatsApp
	set nuevo_emmiter=0
	where emmiter is not null
				 
	update #tblNotifierWhatsApp set
		emmiter=(select top 1 emiter from whatsapp_emiter (NOLOCK) order by cantidad_mensajes_enviados_hoy)
	 where emmiter is null 
	 and en_lista_negra = 0	  
		
	--insert into whatsapp_estatus_telefono (telefono,bloque_original,id_usuario_original,emmiter,en_lista_negra,fecha_registro)
	--select telefono, bloque, min(id_usuario), emmiter, 0, GETDATE()
	--from #tblNotifierWhatsApp t
	--where nuevo_emmiter=1
	--group by telefono, bloque, emmiter
	
	--LB20200113: se actualizo el mensaje
--	update #tblNotifierWhatsApp set
--payload =
--'{
--		"type":"whatsapp",
--		"device":"' + telefono + '",
--		"emitter":"' + emmiter + '",
--		"environment":"PROD",
--		"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",
--		"payload":"' + nombre + ', qué gusto tenerle de cliente, será un placer brindarle el mejor servicio en esta 
--experiencia con su nueva piel. Somos la única empresa del país que cuenta con una App para su mayor comodidad para 
--agendar citas, le pedimos la baje de las siguientes ligas: https://apple.co/2SutiI2 para iOS y http://bit.ly/2Z5bWUp 
--para la plataforma de android. Su número de usuario es ' + clave_acceso + '. Bienvenido !!! Recuerda que todos los pagos 
--deben estar registrados en su app. Cualquier pago que no esté registrado favor de reportarlo. No puede estar nada escrito 
--a mano por la vendedora, todo debe ser por contrato impreso."}'
--	  from #tblNotifierWhatsApp

/*
	update #tblNotifierWhatsApp set
payload =
'{		"type":"whatsapp",
		"device":"' + telefono + '",
		"emitter":"' + emmiter + '",
		"environment":"PROD",
		"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",
		"payload":"Hola ' + nombre + '! Bienvenida a Europiel. Tu codigo de cliente es ' + clave_acceso + '"}'					
	  from #tblNotifierWhatsApp
*/



	  declare @currId int = 1,
				@maxId int

	  select @maxId = max(id) from #tblNotifierWhatsApp

	  while @currId<=@maxId
	    begin
			
				declare @id_otp int, @otp varchar(32), @id_paciente int, @bloque varchar(8)

				select @id_paciente = id_usuario,
						@bloque = bloque
				from #tblNotifierWhatsApp
				where id = @currId		
				
				select @otp=LEFT(CAST(RAND()*1000000000+99999999 AS INT),4)
				
				if exists(select 1 from otp_clientes (nolock) where otp=@otp and fecha_eliminacion is null)
				begin
					select @otp=LEFT(CAST(RAND()*1000000000+99999999 AS INT),5)
						
					if exists(select 1 from otp_clientes (nolock) where otp=@otp and fecha_eliminacion is null)
					begin
						select @otp=LEFT(CAST(RAND()*1000000000+99999999 AS INT),6)
					end					
				end
				
				insert into otp_clientes (otp, asignado, ip_solicitante, id_paciente, bloque, fecha_asignacion)
				select @otp, 1, '', @id_paciente, @bloque, GETDATE()

				select @id_otp=@@IDENTITY

				--Inhabilitar otros OTP asignados al cliente
				update otp_clientes set
					fecha_eliminacion=GETDATE()
				where id_paciente=@id_paciente
				and bloque=@bloque
				and id<>@id_otp
				and fecha_eliminacion is null

				update #tblNotifierWhatsApp
				set otp=@otp
				where id = @currId

				select @currId = @currId + 1
		end

--select * from #tblNotifierWhatsApp

	update #tblNotifierWhatsApp set
		payload = '{"type":"' + (case when id_bloque=6 then 'sms' else 'whatsapp' end) + '",
"device":"' + telefono + '",
"emitter":"' + emmiter + '",
"environment":"PROD",
"token": "kqvXKz5BW9axFTwpVetPNEnCmcy2fRMdg3HL7DhsAu64G8jUQJ",
"payload":"Hola ' + nombre + '! ' + (case when sexo='M' then 'Bienvenido' else 'Bienvenida' end) + ' a Europiel. Tu número de acceso de un solo uso es ' + otp + ', favor de no compartirlo con NADIE. Puedes solicitar uno nuevo desde tu App de Europiel."
}'
	  from #tblNotifierWhatsApp



	insert into notifier_mensajes(id_notifier, id_usuario, id_bloque, bloque, payload, telefono, mobile_os, fecha_alta_registro)
	select distinct id_notifier, id_usuario, id_bloque, bloque, payload, telefono, (case when id_bloque=6 then 'sms' else 'whatsapp' end), GETDATE()
		from #tblNotifierWhatsApp 
	where en_lista_negra = 0
	and len(isNull(telefono,''))>5
						 	
	select top 450 nm.id_detalle, 
			nm.id_notifier, 
			n.id_tipo_notifier,
			notifier_tipo = nt.descripcion,
			nt.ios_app_id,
			nm.id_usuario, 
			nm.id_bloque, 
			nm.bloque, 
			nm.telefono, 
			nm.device_token, 
			payload = REPLACE(nm.payload,'{id_detalle_mensaje}',nm.id_detalle), 
			IsNull(nm.mobile_os,'') as mobile_os
	from notifier_mensajes nm (NOLOCK)
	-- HGU
	--where nm.id_notifier IN(5)
	inner join dbo.notifier n (NOLOCK) on nm.id_notifier = n.id_notifier
	inner join notifier_tipo nt (NOLOCK) on nt.id_tipo_notifier = n.id_tipo_notifier
	where n.es_automatico = 1
	-- HGU
	and nm.fecha_envio is null
	order by nm.id_detalle
--	and len(isNull(nm.telefono,''))>5

	drop table #tblNotifierWhatsApp

 end

GO
