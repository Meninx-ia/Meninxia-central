-- MKT-07 · Limpieza de los datos de prueba
-- NO EJECUTADO. NO EJECUTAR sin autorización expresa de los socios.
-- Borra solo datos ficticios de MKT-07 y devuelve los 7 inmuebles a borrador. No elimina las tablas.
-- Revisar antes si algún agente de marketing ha creado guiones, escenas o vídeos sobre los inmuebles nuevos.

begin;

delete from evaluacion.mkt07_esperado;

delete from public.marketing_campana_destinatarios d
using public.compradores c where c.id = d.comprador_id and c.es_ficticio;

delete from public.mkt07_coincidencias m
using public.necesidades_inmobiliarias n where n.id = m.necesidad_id and n.es_ficticio;

delete from public.necesidades_inmobiliarias where es_ficticio;
delete from public.compradores where es_ficticio;

delete from public.inmuebles
where es_ficticio and referencia in ('MX-005','MX-006','MX-007','MX-008','MX-014','MX-015','MX-016','MX-024','MX-025','MX-026');

update public.inmuebles set estado_publicacion = 'borrador', actualizado_en = now()
where es_ficticio and referencia in ('MX-001','MX-002','MX-003','MX-011','MX-013','MX-021','MX-022');

commit;
