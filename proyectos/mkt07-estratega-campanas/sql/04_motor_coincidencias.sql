-- Motor de coincidencias. Migración aplicada en Supabase: motor_coincidencias (2026-11-04).
-- Reglas en ../MOTOR_COINCIDENCIAS.md

create function clientes.buscar_coincidencias(p_empresa_id text default null, p_necesidad_id uuid default null)
returns table (
  empresa_id text, necesidad_id uuid, necesidad_codigo text, comprador_id uuid, comprador_codigo text, idioma text,
  inmueble_id uuid, referencia text, titulo text, precio numeric,
  grupo text, puntuacion integer, diferencias jsonb, deseables_cumplidas text[], deseables_faltan text[],
  avisos text[], apto_envio boolean)
language sql stable
set search_path = ''
as $$
with base as (
  select c.*,
    array(select unnest(c.caracteristicas_imprescindibles) except select unnest(c.caracteristicas)) as impr_faltan,
    array(select unnest(c.caracteristicas_deseables) intersect select unnest(c.caracteristicas)) as des_ok,
    array(select unnest(c.caracteristicas_deseables) except select unnest(c.caracteristicas)) as des_faltan,
    case when c.precio > c.precio_max then round((c.precio / c.precio_max - 1) * 100, 1) else 0 end as pct_precio,
    case when c.superficie_min_m2 is not null and c.superficie_construida_m2 < c.superficie_min_m2
         then round((1 - c.superficie_construida_m2 / c.superficie_min_m2) * 100, 1) else 0 end as pct_sup,
    greatest(coalesce(c.habitaciones_min, 0) - coalesce(c.habitaciones, 0), 0) as hab_menos,
    greatest(coalesce(c.banos_min, 0) - coalesce(c.banos, 0), 0) as ban_menos
  from clientes.v_candidatos c
  where (p_empresa_id is null or c.empresa_id = p_empresa_id)
    and (p_necesidad_id is null or c.necesidad_id = p_necesidad_id)
    and c.tipo = any(c.tipos)
    and c.municipio = any(c.municipios)
),
eval as (
  select b.*,
    (b.pct_precio > 10 or b.hab_menos > 1 or b.ban_menos > 1 or b.pct_sup > 10 or cardinality(b.impr_faltan) > 1) as fuera,
    (b.pct_precio > 0)::int + (b.hab_menos = 1)::int + (b.ban_menos = 1)::int + (b.pct_sup > 0)::int
      + (cardinality(b.impr_faltan) = 1)::int as leves,
    (cardinality(b.zonas) > 0 and not (coalesce(b.zona, '') = any(b.zonas))) as zona_fuera
  from base b
),
res as (
  select e.empresa_id, e.necesidad_id, e.necesidad_codigo, e.comprador_id, e.comprador_codigo, e.idioma,
    e.inmueble_id, e.referencia, e.titulo, e.precio,
    case when e.leves = 1 then 'cercana'
         when cardinality(e.des_faltan) > 0 or e.zona_fuera then 'parcial'
         else 'total' end as grupo,
    greatest(0, least(100, 100
      - round(e.pct_precio * 2) - e.hab_menos * 15 - e.ban_menos * 10 - round(e.pct_sup * 2)
      - cardinality(e.impr_faltan) * 20 - cardinality(e.des_faltan) * 5
      - case when e.zona_fuera then 5 else 0 end))::int as puntuacion,
    (select coalesce(jsonb_agg(d), '[]'::jsonb) from (values
      (case when e.pct_precio > 0 then jsonb_build_object('criterio','precio','tipo','obligatorio',
        'detalle', e.pct_precio || ' % por encima del máximo (' || e.precio || ' frente a ' || e.precio_max || ')') end),
      (case when e.hab_menos = 1 then jsonb_build_object('criterio','habitaciones','tipo','obligatorio',
        'detalle', e.habitaciones || ' habitaciones; pedía ' || e.habitaciones_min) end),
      (case when e.ban_menos = 1 then jsonb_build_object('criterio','banos','tipo','obligatorio',
        'detalle', e.banos || ' baños; pedía ' || e.banos_min) end),
      (case when e.pct_sup > 0 then jsonb_build_object('criterio','superficie','tipo','obligatorio',
        'detalle', e.superficie_construida_m2 || ' m²; pedía ' || e.superficie_min_m2 || ' m² (' || e.pct_sup || ' % menos)') end),
      (case when cardinality(e.impr_faltan) = 1 then jsonb_build_object('criterio','caracteristica','tipo','obligatorio',
        'detalle', 'Le falta: ' || e.impr_faltan[1]) end),
      (case when e.zona_fuera then jsonb_build_object('criterio','zona','tipo','deseable',
        'detalle', 'Está en ' || coalesce(e.zona, 'zona sin indicar') || '; prefería ' || array_to_string(e.zonas, ', ')) end)
    ) as v(d) where d is not null) as diferencias,
    e.des_ok as deseables_cumplidas,
    e.des_faltan as deseables_faltan,
    array_remove(array[
      case when e.pct_precio > 0 and e.financiacion = 'hipoteca_preaprobada'
           then 'Supera el presupuesto y tiene hipoteca preaprobada: revisar financiación' end,
      case when not e.consentimiento_comercial
           then 'Sin consentimiento comercial: no se le puede enviar la campaña' end
    ], null) as avisos,
    e.consentimiento_comercial as apto_envio
  from eval e
  where not e.fuera and e.leves <= 1
)
select * from res order by necesidad_codigo, puntuacion desc;
$$;

revoke execute on function clientes.buscar_coincidencias(text, uuid) from public, anon, authenticated;
grant execute on function clientes.buscar_coincidencias(text, uuid) to service_role;

create view clientes.v_coincidencias with (security_invoker = true) as
  select * from clientes.buscar_coincidencias();
grant select on clientes.v_coincidencias to service_role;
