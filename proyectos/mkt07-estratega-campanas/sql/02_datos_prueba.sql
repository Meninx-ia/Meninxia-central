-- MKT-07 · Migración aplicada en Supabase: mkt07_datos_prueba (2026-11-03)
-- Todos los datos son ficticios. Emails .test y teléfonos +34 000... no existen.

-- A. 7 inmuebles existentes pasan de borrador a publicado (autorizado). MX-004, MX-012 y MX-023 siguen en borrador.
update public.inmuebles set estado_publicacion = 'publicado', actualizado_en = now()
where es_ficticio and referencia in ('MX-001','MX-002','MX-003','MX-011','MX-013','MX-021','MX-022');

-- B. 10 inmuebles ficticios nuevos
insert into public.inmuebles (empresa_id, referencia, operacion, tipo, titulo, descripcion, precio, precio_periodo, municipio, zona, codigo_postal,
  superficie_construida_m2, superficie_parcela_m2, habitaciones, banos, planta, ascensor, anio_construccion, estado_conservacion,
  certificado_energetico, caracteristicas, estado_publicacion, es_ficticio) values
('demo-huerta-viva','MX-005','venta','chalet','Chalet con piscina en Churra','Chalet independiente con jardín y piscina privada.',420000,null,'Murcia','Churra','30110',240,600,4,3,null,false,2008,'buen_estado','C','{piscina_privada,jardin,garaje,aire_acondicionado,calefaccion,barbacoa}','publicado',true),
('demo-huerta-viva','MX-006','venta','piso','Piso de 3 dormitorios en Vistabella','Piso luminoso para actualizar, cerca del río.',155000,null,'Murcia','Vistabella','30003',90,null,3,1,'2',true,1985,'a_actualizar','E','{aire_acondicionado,balcon}','publicado',true),
('demo-huerta-viva','MX-007','venta','duplex','Dúplex con terraza en Molina de Segura','Dúplex amplio con terraza y plaza de garaje.',198000,null,'Molina de Segura','Centro','30500',130,null,3,2,'3',true,2005,'buen_estado','D','{terraza,garaje,aire_acondicionado,trastero}','reservado',true),
('demo-huerta-viva','MX-008','alquiler','piso','Piso amueblado en el centro de Murcia','Piso de 3 dormitorios amueblado con garaje.',1100,'mes','Murcia','Centro','30004',105,null,3,2,'4',true,2001,'reformado','C','{amueblado,aire_acondicionado,garaje}','publicado',true),
('demo-mar-menor','MX-014','venta','bungalow','Bungalow cerca de la playa en Santiago de la Ribera','Bungalow con terraza, piscina comunitaria y garaje.',175000,null,'San Javier','Santiago de la Ribera','30720',80,null,2,2,'baja',false,2010,'buen_estado','D','{terraza,piscina_comunitaria,aire_acondicionado,garaje,cerca_playa}','publicado',true),
('demo-mar-menor','MX-015','venta','chalet','Chalet con piscina en Los Alcázares','Chalet de 4 dormitorios a 500 m de la playa.',310000,null,'Los Alcázares','Centro','30710',200,450,4,3,null,false,2006,'buen_estado','C','{piscina_privada,jardin,garaje,aire_acondicionado,cerca_playa}','vendido',true),
('demo-mar-menor','MX-016','alquiler','apartamento','Apartamento con vistas en Cabo de Palos','Apartamento amueblado con terraza y vistas al mar.',750,'mes','Cartagena','Cabo de Palos','30370',60,null,2,1,'2',true,1998,'reformado','D','{amueblado,terraza,aire_acondicionado,vistas}','alquilado',true),
('demo-noroeste','MX-024','venta','casa_de_pueblo','Casa de pueblo para reformar en Caravaca','Casa tradicional con patio y chimenea, para reformar.',72000,null,'Caravaca de la Cruz','Centro histórico','30400',120,null,3,1,null,false,1950,'a_reformar','G','{patio,chimenea}','publicado',true),
('demo-noroeste','MX-025','venta','piso','Piso de 2 dormitorios en San Cristóbal','Piso práctico con balcón, listo para entrar.',89000,null,'Lorca','San Cristóbal','30800',75,null,2,1,'1',false,1990,'buen_estado','E','{aire_acondicionado,balcon}','publicado',true),
('demo-noroeste','MX-026','venta','chalet','Chalet con terreno en Cehegín','Chalet con piscina privada y 1.500 m² de terreno.',235000,null,'Cehegín','Afueras','30430',210,1500,4,2,null,false,2003,'buen_estado','D','{piscina_privada,terreno,garaje,chimenea}','reservado',true);

-- C. 30 compradores ficticios
insert into public.compradores (empresa_id, codigo, nombre, apellidos, email, telefono, perfil, idioma, presupuesto_min, presupuesto_max,
  financiacion, estado_comercial, origen, consentimiento_comercial, consentimiento_fecha, notas, es_ficticio) values
('demo-huerta-viva','CP-01','Lucía','Ortuño Vidal','comprador01@meninxia-pruebas.test','+34 000 000 001','familia','es',180000,230000,'hipoteca_preaprobada','cualificado','web',true,'2026-10-15','Dos hijos pequeños, quiere colegio cerca.',true),
('demo-huerta-viva','CP-02','Álvaro','Meseguer Pina','comprador02@meninxia-pruebas.test','+34 000 000 002','pareja','es',120000,160000,'hipoteca_pendiente','nuevo','portal',true,'2026-10-15','Primera vivienda.',true),
('demo-huerta-viva','CP-03','Ramón','Valcárcel Soto','comprador03@meninxia-pruebas.test','+34 000 000 003','inversor','es',200000,270000,'contado','contactado','referido',true,'2026-10-15','Busca rentabilidad por alquiler.',true),
('demo-huerta-viva','CP-04','Inés','Barnés Lozano','comprador04@meninxia-pruebas.test','+34 000 000 004','familia','es',330000,400000,'mixta','visita_programada','oficina',true,'2026-10-15','Familia numerosa con perro.',true),
('demo-huerta-viva','CP-05','Daniel','Ferrández Gil','comprador05@meninxia-pruebas.test','+34 000 000 005','teletrabajador','es',700,900,'no_aplica','nuevo','web',true,'2026-10-15','Busca alquiler; necesita buena conexión.',true),
('demo-huerta-viva','CP-06','Marta','Caballero Ruiz','comprador06@meninxia-pruebas.test','+34 000 000 006','familia','es',900,1050,'no_aplica','contactado','telefono',true,'2026-10-15','Busca alquiler de larga duración.',true),
('demo-huerta-viva','CP-07','Pablo','Sánchez Mula','comprador07@meninxia-pruebas.test','+34 000 000 007','estudiante','es',300,450,'no_aplica','nuevo','redes_sociales',true,'2026-10-15','Estudiante universitario, curso completo.',true),
('demo-huerta-viva','CP-08','Margaret','Whitfield','comprador08@meninxia-pruebas.test','+34 000 000 008','jubilado','en',250000,300000,'contado','negociando','web',true,'2026-10-15','Jubilada británica, quiere sol y terraza.',true),
('demo-huerta-viva','CP-09','Fernando','Albaladejo Riquelme','comprador09@meninxia-pruebas.test','+34 000 000 009','inversor','es',450000,600000,'contado','cualificado','referido',true,'2026-10-15','Busca vivienda de alto nivel.',true),
('demo-huerta-viva','CP-10','Nuria','Abellán Tomás','comprador10@meninxia-pruebas.test','+34 000 000 010','pareja','es',170000,210000,'hipoteca_preaprobada','contactado','portal',true,'2026-10-15','Trabajan en Molina de Segura.',true),
('demo-huerta-viva','CP-11','Javier','Navarro Esteve','comprador11@meninxia-pruebas.test','+34 000 000 011','familia','es',190000,220000,'hipoteca_preaprobada','cualificado','oficina',false,null,'No ha dado consentimiento para comunicaciones comerciales.',true),
('demo-huerta-viva','CP-12','Elena','Gómez Carrillo','comprador12@meninxia-pruebas.test','+34 000 000 012','persona_sola','es',120000,160000,'hipoteca_pendiente','cerrado_perdido','web',true,'2026-10-15','Ya compró con otra agencia.',true),
('demo-mar-menor','CP-13','Klaus','Brenner','comprador13@meninxia-pruebas.test','+34 000 000 013','inversor','de',150000,200000,'contado','cualificado','web',true,'2026-10-15','Inversor alemán: compra vacacional y además busca alquiler para él.',true),
('demo-mar-menor','CP-14','Rocío','Martínez Conesa','comprador14@meninxia-pruebas.test','+34 000 000 014','familia','es',140000,170000,'hipoteca_preaprobada','visita_programada','portal',true,'2026-10-15',null,true),
('demo-mar-menor','CP-15','Sergio','Pagán Hernández','comprador15@meninxia-pruebas.test','+34 000 000 015','pareja','es',120000,150000,'hipoteca_pendiente','nuevo','redes_sociales',true,'2026-10-15',null,true),
('demo-mar-menor','CP-16','Ingrid','Halvorsen','comprador16@meninxia-pruebas.test','+34 000 000 016','jubilado','en',150000,180000,'contado','contactado','web',true,'2026-10-15','Jubilada noruega, quiere estar cerca de la playa.',true),
('demo-mar-menor','CP-17','Antonio','Lorente Saura','comprador17@meninxia-pruebas.test','+34 000 000 017','familia','es',280000,320000,'mixta','contactado','referido',true,'2026-10-15',null,true),
('demo-mar-menor','CP-18','Beatriz','Moreno Aznar','comprador18@meninxia-pruebas.test','+34 000 000 018','pareja','es',190000,230000,'hipoteca_preaprobada','nuevo','web',true,'2026-10-15','Quiere vivir en Murcia capital.',true),
('demo-mar-menor','CP-19','Óscar','Celdrán Bernal','comprador19@meninxia-pruebas.test','+34 000 000 019','familia','es',150000,180000,'hipoteca_preaprobada','cualificado','oficina',true,'2026-10-15',null,true),
('demo-mar-menor','CP-20','Claire','Dubois-Martin','comprador20@meninxia-pruebas.test','+34 000 000 020','segunda_residencia','fr',130000,160000,'contado','nuevo','portal',true,'2026-10-15',null,true),
('demo-mar-menor','CP-21','Tomás','Ibáñez Roca','comprador21@meninxia-pruebas.test','+34 000 000 021','persona_sola','es',null,null,null,'nuevo','telefono',false,null,'Contacto reciente, todavía sin ficha de necesidades.',true),
('demo-noroeste','CP-22','Carmen','Ros Puche','comprador22@meninxia-pruebas.test','+34 000 000 022','familia','es',100000,120000,'hipoteca_preaprobada','cualificado','oficina',true,'2026-10-15',null,true),
('demo-noroeste','CP-23','Andrés','Mula Guirao','comprador23@meninxia-pruebas.test','+34 000 000 023','segunda_residencia','es',120000,150000,'contado','visita_programada','web',true,'2026-10-15','Quiere casa de campo para fines de semana.',true),
('demo-noroeste','CP-24','Pilar','Sánchez Jiménez','comprador24@meninxia-pruebas.test','+34 000 000 024','jubilado','es',50000,70000,'contado','contactado','referido',true,'2026-10-15','Volver a su pueblo de origen.',true),
('demo-noroeste','CP-25','Raúl','García Reverte','comprador25@meninxia-pruebas.test','+34 000 000 025','pareja','es',70000,85000,'hipoteca_pendiente','nuevo','portal',true,'2026-10-15',null,true),
('demo-noroeste','CP-26','Sofía','López Marín','comprador26@meninxia-pruebas.test','+34 000 000 026','familia','es',80000,95000,'hipoteca_preaprobada','contactado','web',true,'2026-10-15',null,true),
('demo-noroeste','CP-27','Miguel Ángel','Ruiz Ponce','comprador27@meninxia-pruebas.test','+34 000 000 027','familia','es',200000,240000,'mixta','nuevo','redes_sociales',true,'2026-10-15',null,true),
('demo-noroeste','CP-28','Gloria','Martínez Cayuela','comprador28@meninxia-pruebas.test','+34 000 000 028','segunda_residencia','es',130000,160000,'contado','cualificado','web',true,'2026-10-15',null,true),
('demo-noroeste','CP-29','Hugo','Andreu Lario','comprador29@meninxia-pruebas.test','+34 000 000 029','inversor','es',60000,100000,'contado','nuevo','correo',true,'2026-10-15','Busca un local comercial.',true),
('demo-noroeste','CP-30','Lorena','Díaz Peñalver','comprador30@meninxia-pruebas.test','+34 000 000 030','persona_sola','es',40000,50000,'hipoteca_pendiente','nuevo','web',true,'2026-10-15',null,true);

-- D. 30 necesidades (CP-13 tiene dos; CP-21 ninguna)
insert into public.necesidades_inmobiliarias (empresa_id, comprador_id, codigo, operacion, tipos, municipios, zonas, precio_min, precio_max,
  habitaciones_min, banos_min, superficie_min_m2, caracteristicas_imprescindibles, caracteristicas_deseables, urgencia, estado, notas, es_ficticio)
select c.empresa_id, c.id, v.codigo, v.operacion, v.tipos::text[], v.municipios::text[], v.zonas::text[], v.pmin, v.pmax,
       v.hab, v.ban, v.sup, v.impr::text[], v.des::text[], v.urg, v.estado, v.notas, true
from (values
 ('demo-huerta-viva','CP-01','NC-01','venta','{piso,atico,duplex}','{Murcia}','{Santa Eulalia,Centro}',180000,230000,3,2,100,'{aire_acondicionado}','{trastero,balcon}','alta','activa',null),
 ('demo-huerta-viva','CP-02','NC-02','venta','{piso}','{Murcia}','{}',120000,160000,2,1,80,'{aire_acondicionado}','{balcon}','media','activa',null),
 ('demo-huerta-viva','CP-03','NC-03','venta','{piso,atico}','{Murcia}','{}',200000,270000,2,2,90,'{garaje}','{piscina_comunitaria,vistas}','media','activa',null),
 ('demo-huerta-viva','CP-04','NC-04','venta','{chalet,adosado}','{Murcia}','{Churra,El Puntal}',330000,400000,4,2,200,'{jardin,garaje}','{piscina_privada}','media','activa',null),
 ('demo-huerta-viva','CP-05','NC-05','alquiler','{piso,apartamento,estudio}','{Murcia}','{}',700,900,2,1,70,'{amueblado}','{aire_acondicionado}','alta','activa',null),
 ('demo-huerta-viva','CP-06','NC-06','alquiler','{piso}','{Murcia}','{}',900,1050,3,2,100,'{garaje}','{amueblado}','media','activa',null),
 ('demo-huerta-viva','CP-07','NC-07','alquiler','{estudio,piso}','{Murcia}','{Espinardo}',300,450,1,1,30,'{amueblado}','{}','alta','activa',null),
 ('demo-huerta-viva','CP-08','NC-08','venta','{atico,piso}','{Murcia}','{}',250000,300000,2,2,90,'{terraza}','{vistas,piscina_comunitaria}','media','activa',null),
 ('demo-huerta-viva','CP-09','NC-09','venta','{chalet}','{Murcia}','{}',450000,600000,5,3,300,'{piscina_privada}','{}','baja','activa',null),
 ('demo-huerta-viva','CP-10','NC-10','venta','{duplex,piso}','{Molina de Segura}','{}',170000,210000,3,2,null,'{terraza}','{garaje}','alta','activa',null),
 ('demo-huerta-viva','CP-11','NC-11','venta','{piso}','{Murcia}','{}',190000,220000,3,2,100,'{balcon}','{}','media','activa',null),
 ('demo-huerta-viva','CP-12','NC-12','venta','{piso}','{Murcia}','{}',120000,160000,2,1,null,'{}','{}','baja','cancelada','Cancelada: ya compró con otra agencia.'),
 ('demo-mar-menor','CP-13','NC-13','venta','{apartamento,bungalow}','{Cartagena,San Javier}','{La Manga del Mar Menor}',150000,200000,2,1,60,'{piscina_comunitaria,terraza}','{primera_linea,vistas}','media','activa',null),
 ('demo-mar-menor','CP-13','NC-14','alquiler','{apartamento}','{Cartagena}','{}',null,800,2,1,null,'{}','{}','baja','activa','Alquiler para él mientras compra.'),
 ('demo-mar-menor','CP-14','NC-15','venta','{piso}','{Cartagena}','{}',140000,170000,3,2,95,'{garaje}','{balcon}','alta','activa',null),
 ('demo-mar-menor','CP-15','NC-16','venta','{piso,apartamento}','{Cartagena}','{}',120000,150000,2,1,65,'{aire_acondicionado}','{}','media','activa',null),
 ('demo-mar-menor','CP-16','NC-17','venta','{bungalow,apartamento}','{San Javier,Los Alcázares}','{}',150000,180000,2,2,75,'{cerca_playa}','{piscina_comunitaria,garaje}','media','activa',null),
 ('demo-mar-menor','CP-17','NC-18','venta','{chalet}','{Los Alcázares,San Javier}','{}',280000,320000,4,2,null,'{piscina_privada}','{jardin}','alta','activa',null),
 ('demo-mar-menor','CP-18','NC-19','venta','{piso}','{Murcia}','{Santa Eulalia}',190000,230000,3,2,100,'{aire_acondicionado}','{trastero}','media','activa',null),
 ('demo-mar-menor','CP-19','NC-20','venta','{piso,apartamento}','{Cartagena}','{}',150000,180000,3,2,100,'{vistas}','{garaje}','media','activa',null),
 ('demo-mar-menor','CP-20','NC-21','venta','{bungalow,apartamento}','{San Javier,Cartagena}','{}',130000,160000,2,1,60,'{piscina_comunitaria}','{cerca_playa}','baja','activa',null),
 ('demo-noroeste','CP-22','NC-22','venta','{piso}','{Lorca}','{Centro}',100000,120000,3,2,100,'{garaje}','{calefaccion}','alta','activa',null),
 ('demo-noroeste','CP-23','NC-23','venta','{casa_de_campo,chalet}','{Lorca,Totana,Cehegín}','{}',120000,150000,3,2,150,'{terreno}','{pozo,arboles_frutales}','media','activa',null),
 ('demo-noroeste','CP-24','NC-24','venta','{casa_de_pueblo,adosado}','{Caravaca de la Cruz,Cehegín,Totana}','{}',50000,70000,3,1,null,'{patio}','{chimenea}','baja','activa',null),
 ('demo-noroeste','CP-25','NC-25','venta','{piso}','{Lorca}','{}',70000,85000,2,1,70,'{aire_acondicionado}','{balcon}','media','activa',null),
 ('demo-noroeste','CP-26','NC-26','venta','{piso}','{Lorca}','{}',80000,95000,3,1,70,'{balcon}','{}','media','activa',null),
 ('demo-noroeste','CP-27','NC-27','venta','{chalet}','{Cehegín}','{}',200000,240000,4,null,null,'{piscina_privada}','{terreno}','alta','activa',null),
 ('demo-noroeste','CP-28','NC-28','venta','{casa_de_campo}','{Lorca}','{}',130000,160000,4,2,150,'{terreno,pozo}','{chimenea}','media','activa',null),
 ('demo-noroeste','CP-29','NC-29','venta','{local}','{Lorca}','{}',60000,100000,null,null,null,'{}','{}','baja','activa',null),
 ('demo-noroeste','CP-30','NC-30','venta','{piso}','{Lorca,Totana}','{}',40000,50000,2,1,null,'{}','{}','media','activa',null)
) as v(empresa_id, comprador, codigo, operacion, tipos, municipios, zonas, pmin, pmax, hab, ban, sup, impr, des, urg, estado, notas)
join public.compradores c on c.empresa_id = v.empresa_id and c.codigo = v.comprador;

-- E. Resultados esperados (las "respuestas" del examen)
insert into evaluacion.mkt07_esperado (empresa_id, necesidad_codigo, inmueble_referencia, encaje_esperado, apto_campana, grupo_prueba, motivo) values
('demo-huerta-viva','NC-01','MX-001','total',true,'perfecto','Cumple todo, incluidos trastero y balcón.'),
('demo-huerta-viva','NC-02','MX-006','total',true,'perfecto','Precio, habitaciones y aire acondicionado correctos.'),
('demo-huerta-viva','NC-03','MX-001','parcial',true,'parcial','Le falta el garaje imprescindible.'),
('demo-huerta-viva','NC-03','MX-002','parcial',true,'parcial','Precio un 5,6 % por encima del máximo.'),
('demo-huerta-viva','NC-04','MX-005','parcial',true,'parcial','Precio un 5 % por encima del máximo.'),
('demo-huerta-viva','NC-05','MX-003','total',true,'perfecto','Alquiler amueblado dentro de presupuesto.'),
('demo-huerta-viva','NC-06','MX-008','parcial',true,'parcial','Alquiler un 4,8 % por encima del máximo.'),
('demo-huerta-viva','NC-07',null,'ninguna',null,'no_encaja','Presupuesto de alquiler demasiado bajo; MX-004 está en borrador.'),
('demo-huerta-viva','NC-08','MX-002','total',true,'perfecto','Ático con terraza dentro de presupuesto.'),
('demo-huerta-viva','NC-08','MX-001','parcial',true,'perfecto','Cumple todo salvo la terraza imprescindible.'),
('demo-huerta-viva','NC-09',null,'ninguna',null,'no_encaja','MX-005 tiene una habitación menos y un 20 % menos de superficie.'),
('demo-huerta-viva','NC-10',null,'ninguna',null,'trampa','MX-007 encajaría, pero está reservado.'),
('demo-huerta-viva','NC-11','MX-001','total',false,'trampa','Encaja, pero el comprador no tiene consentimiento comercial: no puede entrar en campañas.'),
('demo-huerta-viva','NC-12',null,'ninguna',null,'trampa','Necesidad cancelada: debe ignorarse aunque MX-006 encajaría.'),
('demo-mar-menor','NC-13','MX-013','total',true,'perfecto','Apartamento en La Manga con piscina y terraza.'),
('demo-mar-menor','NC-13','MX-014','total',true,'perfecto','Bungalow con piscina y terraza dentro de presupuesto.'),
('demo-mar-menor','NC-14',null,'ninguna',null,'no_encaja','No hay alquileres disponibles (MX-016 ya está alquilado).'),
('demo-mar-menor','NC-15','MX-011','total',true,'perfecto','Piso con garaje dentro de presupuesto.'),
('demo-mar-menor','NC-16','MX-011','parcial',true,'parcial','Precio justo un 10 % por encima del máximo (caso límite).'),
('demo-mar-menor','NC-17','MX-014','total',true,'perfecto','Bungalow cerca de la playa con piscina y garaje.'),
('demo-mar-menor','NC-18',null,'ninguna',null,'no_encaja','El único chalet (MX-015) está vendido.'),
('demo-mar-menor','NC-19',null,'ninguna',null,'trampa','MX-001 encajaría, pero es de otra inmobiliaria: cualquier coincidencia es una fuga de datos.'),
('demo-mar-menor','NC-20','MX-011','parcial',true,'parcial','Le faltan las vistas imprescindibles.'),
('demo-mar-menor','NC-21','MX-014','parcial',true,'parcial','Precio un 9,4 % por encima del máximo.'),
('demo-noroeste','NC-22','MX-021','total',true,'perfecto','Piso con garaje en el centro de Lorca.'),
('demo-noroeste','NC-23','MX-022','total',true,'perfecto','Casa de campo con terreno, pozo y frutales.'),
('demo-noroeste','NC-24','MX-024','parcial',true,'parcial','Precio un 2,9 % por encima del máximo.'),
('demo-noroeste','NC-25','MX-025','parcial',true,'parcial','Precio un 4,7 % por encima del máximo.'),
('demo-noroeste','NC-26','MX-025','parcial',true,'parcial','Tiene una habitación menos de la pedida.'),
('demo-noroeste','NC-27',null,'ninguna',null,'no_encaja','El chalet de Cehegín (MX-026) está reservado.'),
('demo-noroeste','NC-28','MX-022','parcial',true,'parcial','Tiene una habitación menos de la pedida.'),
('demo-noroeste','NC-29',null,'ninguna',null,'no_encaja','No hay locales en cartera.'),
('demo-noroeste','NC-30',null,'ninguna',null,'no_encaja','Presupuesto muy inferior a cualquier piso disponible.');
