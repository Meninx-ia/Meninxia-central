-- MKT-07 · Consultas de verificación (solo lectura salvo la prueba 3, que se deshace sola)

-- 1. Recuentos
select 'inmuebles ficticios' que, count(*)::text valor from inmuebles where es_ficticio
union all select 'inmuebles por estado', string_agg(estado_publicacion||'='||n, ', ' order by estado_publicacion) from (select estado_publicacion, count(*) n from inmuebles group by 1) s
union all select 'compradores', count(*)::text from compradores
union all select 'compradores sin consentimiento', string_agg(codigo, ', ') from compradores where not consentimiento_comercial
union all select 'necesidades', count(*)::text from necesidades_inmobiliarias
union all select 'necesidades activas (vista)', count(*)::text from v_mkt07_necesidades_activas
union all select 'inmuebles disponibles (vista)', count(*)::text from v_mkt07_inmuebles_disponibles
union all select 'pares candidatos (vista)', count(*)::text from v_mkt07_candidatos
union all select 'filas esperadas', count(*)::text from evaluacion.mkt07_esperado
union all select 'emails no .test', count(*)::text from compradores where email not like '%.test';
-- Resultado del 2026-11-03: 20 / alquilado=1, borrador=3, publicado=13, reservado=2, vendido=1 / 30 / CP-11, CP-21 / 30 / 29 / 13 / 98 / 33 / 0

-- 2. Reglas SQL frente a resultados esperados (debe salir todo OK)
-- Parcial = un solo fallo leve: precio hasta +10 %, una habitación o baño menos, superficie hasta -10 %, o falta una característica imprescindible.
with c as (
  select necesidad_codigo, empresa_id, referencia,
    (not tipo = any(tipos) or not municipio = any(municipios)
     or precio > precio_max*1.10
     or (habitaciones_min is not null and habitaciones < habitaciones_min-1)
     or (banos_min is not null and banos < banos_min-1)
     or (superficie_min_m2 is not null and superficie_construida_m2 < superficie_min_m2*0.9)
     or cardinality(array(select unnest(caracteristicas_imprescindibles) except select unnest(caracteristicas))) >= 2) as fatal,
    (precio > precio_max)::int
    + (habitaciones_min is not null and habitaciones < habitaciones_min)::int
    + (banos_min is not null and banos < banos_min)::int
    + (superficie_min_m2 is not null and superficie_construida_m2 < superficie_min_m2)::int
    + cardinality(array(select unnest(caracteristicas_imprescindibles) except select unnest(caracteristicas))) as fallos
  from v_mkt07_candidatos),
r as (select necesidad_codigo, empresa_id, referencia, case when fatal or fallos>=2 then 'no' when fallos=0 then 'total' else 'parcial' end encaje from c),
reglas as (select * from r where encaje <> 'no'),
esp as (select necesidad_codigo, empresa_id, inmueble_referencia referencia, encaje_esperado encaje from evaluacion.mkt07_esperado where encaje_esperado <> 'ninguna')
select coalesce(reglas.necesidad_codigo, esp.necesidad_codigo) nc, coalesce(reglas.referencia, esp.referencia) ref,
       reglas.encaje segun_reglas, esp.encaje esperado,
       case when reglas.encaje is not distinct from esp.encaje then 'OK' else 'DISCREPANCIA' end resultado
from reglas full join esp on reglas.necesidad_codigo=esp.necesidad_codigo and reglas.empresa_id=esp.empresa_id and reglas.referencia=esp.referencia
order by resultado desc, nc, ref;
-- Resultado del 2026-11-03: 23 filas, todas OK.

-- 3. Pruebas de bloqueo. Termina SIEMPRE con un error intencionado que deshace todo.
do $$
declare r text := ''; v_camp uuid; v_cp11 uuid; v_cp01 uuid; v_nc19 uuid; v_mx001 uuid; v_cp18 uuid;
begin
  select id into v_cp11 from compradores where codigo='CP-11';
  select id into v_cp01 from compradores where codigo='CP-01';
  select id into v_cp18 from compradores where codigo='CP-18';
  select id into v_nc19 from necesidades_inmobiliarias where codigo='NC-19';
  select id into v_mx001 from inmuebles where referencia='MX-001';

  begin
    insert into necesidades_inmobiliarias (empresa_id, comprador_id, codigo, operacion, tipos, municipios, precio_max)
    values ('demo-mar-menor', v_cp01, 'NC-X1', 'venta', '{piso}', '{Murcia}', 100000);
    r := r || '1) Necesidad cruzada entre empresas: PERMITIDA (FALLO) | ';
  exception when foreign_key_violation then r := r || '1) Necesidad cruzada entre empresas: BLOQUEADA | ';
  end;

  begin
    insert into mkt07_coincidencias (empresa_id, necesidad_id, inmueble_id, puntuacion, encaje)
    values ('demo-mar-menor', v_nc19, v_mx001, 95, 'total');
    r := r || '2) Coincidencia con inmueble de otra empresa: PERMITIDA (FALLO) | ';
  exception when foreign_key_violation then r := r || '2) Coincidencia con inmueble de otra empresa: BLOQUEADA | ';
  end;

  insert into marketing_campanas (empresa_id, titulo, canal) values ('demo-huerta-viva', 'Prueba', 'email') returning id into v_camp;
  begin
    insert into marketing_campana_destinatarios (empresa_id, campana_id, comprador_id) values ('demo-huerta-viva', v_camp, v_cp11);
    r := r || '3) Campaña a comprador sin consentimiento: PERMITIDA (FALLO) | ';
  exception when raise_exception then r := r || '3) Campaña a comprador sin consentimiento: BLOQUEADA | ';
  end;
  begin
    insert into marketing_campana_destinatarios (empresa_id, campana_id, comprador_id) values ('demo-huerta-viva', v_camp, v_cp01);
    r := r || '4) Campaña a comprador con consentimiento: PERMITIDA (correcto) | ';
  exception when others then r := r || '4) Campaña a comprador con consentimiento: BLOQUEADA (FALLO) | ';
  end;
  begin
    insert into marketing_campana_destinatarios (empresa_id, campana_id, comprador_id) values ('demo-huerta-viva', v_camp, v_cp18);
    r := r || '5) Campaña con comprador de otra empresa: PERMITIDA (FALLO)';
  exception when foreign_key_violation or raise_exception then r := r || '5) Campaña con comprador de otra empresa: BLOQUEADA';
  end;

  raise exception 'RESULTADO (todo deshecho): %', r;
end $$;
-- Resultado del 2026-11-03: 1, 2, 3 y 5 BLOQUEADAS; 4 PERMITIDA (correcto).
