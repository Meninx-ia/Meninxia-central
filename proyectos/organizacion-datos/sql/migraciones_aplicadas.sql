-- Organización por departamentos. Migraciones aplicadas en Supabase el 2026-11-04, en este orden.

-- 1. departamento_clientes
create schema clientes;
alter table public.compradores set schema clientes;
alter table public.necesidades_inmobiliarias set schema clientes;
alter table clientes.necesidades_inmobiliarias rename to necesidades;
alter table public.mkt07_coincidencias set schema clientes;
alter table clientes.mkt07_coincidencias rename to coincidencias;
alter view public.v_mkt07_necesidades_activas set schema clientes;
alter view clientes.v_mkt07_necesidades_activas rename to v_necesidades_activas;
alter view public.v_mkt07_candidatos set schema clientes;
alter view clientes.v_mkt07_candidatos rename to v_candidatos;
-- La función de consentimiento se reescribió para leer clientes.compradores (search_path vacío).
grant usage on schema clientes to service_role;
grant all on all tables in schema clientes to service_role;
alter default privileges in schema clientes grant all on tables to service_role;

-- 2. departamento_inmobiliario
create schema inmobiliario;
alter table public.inmuebles set schema inmobiliario;
alter table public.inmueble_medios set schema inmobiliario;
alter table inmobiliario.inmueble_medios rename to medios;
alter view public.v_inmueble_medios set schema inmobiliario;
alter view inmobiliario.v_inmueble_medios rename to v_medios;
alter view public.v_mkt07_inmuebles_disponibles set schema inmobiliario;
alter view inmobiliario.v_mkt07_inmuebles_disponibles rename to v_inmuebles_disponibles;
create view public.inmuebles with (security_invoker = true) as select * from inmobiliario.inmuebles;
create view public.inmueble_medios with (security_invoker = true) as select * from inmobiliario.medios;
create view public.v_inmueble_medios with (security_invoker = true) as select * from inmobiliario.v_medios;

-- 3. departamento_atencion_cliente
create schema atencion_cliente;
alter table public.correos_analizados set schema atencion_cliente;
alter table public.borradores_respuesta set schema atencion_cliente;
alter view public.correos_pendientes_respuesta set schema atencion_cliente;
create view public.correos_analizados with (security_invoker = true) as select * from atencion_cliente.correos_analizados;
create view public.borradores_respuesta with (security_invoker = true) as select * from atencion_cliente.borradores_respuesta;
create view public.correos_pendientes_respuesta with (security_invoker = true) as select * from atencion_cliente.correos_pendientes_respuesta;

-- 4. departamento_marketing
create schema marketing;
-- marketing_estudios, _guiones, _personajes, _escenas, _videos, _campanas, _campana_inmuebles, _campana_destinatarios
-- se movieron a marketing.* y se renombraron sin el prefijo marketing_.
alter function public.exigir_consentimiento_comercial() set schema marketing;
-- Accesos directos: public.marketing_estudios, _guiones, _personajes, _escenas, _videos.

-- 5. departamento_plataforma
create schema plataforma;
alter table public.empresas set schema plataforma;
alter table public.almacen_carpetas set schema plataforma;
create view public.almacen_carpetas with (security_invoker = true) as select * from plataforma.almacen_carpetas;

-- 6. cliente_clinica_sije
create schema clinica_sije;
alter table public.blog_posts set schema clinica_sije;
alter table public.noticias   set schema clinica_sije;
alter table public.fuentes    set schema clinica_sije;
alter table public.busquedas  set schema clinica_sije;
alter function public.normalizar_fuentes_blog() set schema clinica_sije;
revoke all on clinica_sije.blog_posts, clinica_sije.noticias, clinica_sije.fuentes, clinica_sije.busquedas from anon, authenticated;
grant usage on schema clinica_sije to anon, authenticated;
grant select on clinica_sije.blog_posts to anon, authenticated;
create view public.blog_posts with (security_invoker = true) as select * from clinica_sije.blog_posts;
create view public.noticias   with (security_invoker = true) as select * from clinica_sije.noticias;
create view public.fuentes    with (security_invoker = true) as select * from clinica_sije.fuentes;
create view public.busquedas  with (security_invoker = true) as select * from clinica_sije.busquedas;
grant select on public.blog_posts to anon, authenticated;

-- En todos los pasos: cada esquema y acceso directo con permisos solo para service_role
-- (revoke a anon y authenticated), salvo la lectura pública de blog_posts.
