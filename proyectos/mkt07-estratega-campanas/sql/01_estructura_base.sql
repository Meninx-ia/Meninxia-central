-- MKT-07 · Migración aplicada en Supabase: mkt07_estructura_base (2026-11-03)

-- 1. Empresas
create table public.empresas (
  id text primary key check (id ~ '^[a-z0-9_-]+$'),
  nombre text not null,
  es_demo boolean not null default false,
  activa boolean not null default true,
  creado_en timestamptz not null default now()
);
comment on table public.empresas is 'Lista oficial de empresas (inmobiliarias clientes y la propia plataforma). Las tablas nuevas referencian empresa_id aquí.';
alter table public.empresas enable row level security;

insert into public.empresas (id, nombre, es_demo) values
  ('_plataforma', 'Plataforma MENINXIA (uso interno)', false),
  ('meninxia', 'MENINXIA', false),
  ('demo-huerta-viva', 'Huerta Viva Inmobiliaria (demo)', true),
  ('demo-mar-menor', 'Mar Menor Hogar (demo)', true),
  ('demo-noroeste', 'Noroeste Casas (demo)', true);

-- 2. Restricción única compuesta en inmuebles (no modifica datos)
alter table public.inmuebles add constraint inmuebles_empresa_id_id_key unique (empresa_id, id);

-- 3. Compradores
create table public.compradores (
  id uuid primary key default gen_random_uuid(),
  empresa_id text not null references public.empresas(id),
  codigo text not null,
  nombre text not null,
  apellidos text,
  email text,
  telefono text,
  perfil text not null check (perfil in ('familia','pareja','persona_sola','inversor','jubilado','estudiante','teletrabajador','segunda_residencia')),
  idioma text not null default 'es',
  presupuesto_min numeric check (presupuesto_min >= 0),
  presupuesto_max numeric check (presupuesto_max >= 0),
  financiacion text check (financiacion in ('hipoteca_preaprobada','hipoteca_pendiente','contado','mixta','no_aplica')),
  estado_comercial text not null default 'nuevo' check (estado_comercial in ('nuevo','contactado','cualificado','visita_programada','negociando','cerrado_ganado','cerrado_perdido','inactivo')),
  origen text check (origen in ('web','portal','referido','correo','telefono','oficina','redes_sociales')),
  consentimiento_comercial boolean not null default false,
  consentimiento_fecha timestamptz,
  notas text,
  es_ficticio boolean not null default false,
  creado_en timestamptz not null default now(),
  actualizado_en timestamptz not null default now(),
  constraint compradores_presupuesto_coherente check (presupuesto_max is null or presupuesto_min is null or presupuesto_max >= presupuesto_min),
  constraint compradores_consentimiento_con_fecha check (not consentimiento_comercial or consentimiento_fecha is not null),
  constraint compradores_empresa_codigo_key unique (empresa_id, codigo),
  constraint compradores_empresa_id_id_key unique (empresa_id, id)
);
comment on table public.compradores is 'Compradores e inquilinos potenciales por empresa. Datos personales: acceso mínimo. Sin consentimiento_comercial no pueden recibir campañas (lo impide un trigger).';
alter table public.compradores enable row level security;

-- 4. Necesidades inmobiliarias
create table public.necesidades_inmobiliarias (
  id uuid primary key default gen_random_uuid(),
  empresa_id text not null references public.empresas(id),
  comprador_id uuid not null,
  codigo text not null,
  operacion text not null check (operacion in ('venta','alquiler')),
  tipos text[] not null check (cardinality(tipos) > 0),
  municipios text[] not null check (cardinality(municipios) > 0),
  zonas text[] not null default '{}',
  precio_min numeric check (precio_min >= 0),
  precio_max numeric not null check (precio_max >= 0),
  habitaciones_min integer check (habitaciones_min >= 0),
  banos_min integer check (banos_min >= 0),
  superficie_min_m2 numeric check (superficie_min_m2 >= 0),
  caracteristicas_imprescindibles text[] not null default '{}',
  caracteristicas_deseables text[] not null default '{}',
  urgencia text not null default 'media' check (urgencia in ('alta','media','baja')),
  fecha_objetivo date,
  estado text not null default 'activa' check (estado in ('activa','pausada','satisfecha','cancelada')),
  notas text,
  es_ficticio boolean not null default false,
  creado_en timestamptz not null default now(),
  actualizado_en timestamptz not null default now(),
  constraint necesidades_precio_coherente check (precio_min is null or precio_max >= precio_min),
  constraint necesidades_empresa_codigo_key unique (empresa_id, codigo),
  constraint necesidades_empresa_id_id_key unique (empresa_id, id),
  constraint necesidades_comprador_misma_empresa_fkey foreign key (empresa_id, comprador_id) references public.compradores(empresa_id, id)
);
comment on table public.necesidades_inmobiliarias is 'Lo que busca cada comprador. La clave foránea compuesta impide asociar una necesidad a un comprador de otra empresa.';
alter table public.necesidades_inmobiliarias enable row level security;

-- 5. Coincidencias calculadas por MKT-07
create table public.mkt07_coincidencias (
  id uuid primary key default gen_random_uuid(),
  empresa_id text not null references public.empresas(id),
  necesidad_id uuid not null,
  inmueble_id uuid not null,
  puntuacion integer not null check (puntuacion between 0 and 100),
  encaje text not null check (encaje in ('total','parcial','no_encaja')),
  criterios_cumplidos jsonb not null default '[]',
  criterios_fallidos jsonb not null default '[]',
  explicacion text,
  modelo_ia text,
  ejecucion_id text,
  estado text not null default 'propuesta' check (estado in ('propuesta','revisada','descartada')),
  creado_en timestamptz not null default now(),
  constraint coincidencias_necesidad_misma_empresa_fkey foreign key (empresa_id, necesidad_id) references public.necesidades_inmobiliarias(empresa_id, id),
  constraint coincidencias_inmueble_misma_empresa_fkey foreign key (empresa_id, inmueble_id) references public.inmuebles(empresa_id, id)
);
comment on table public.mkt07_coincidencias is 'Resultados de MKT-07. Las claves compuestas impiden cruzar necesidades e inmuebles de empresas distintas.';
alter table public.mkt07_coincidencias enable row level security;

-- 6. Campañas y sus destinatarios / inmuebles
create table public.marketing_campanas (
  id uuid primary key default gen_random_uuid(),
  empresa_id text not null references public.empresas(id),
  titulo text not null,
  objetivo text,
  segmento jsonb not null default '{}',
  canal text not null check (canal in ('email','whatsapp','redes_sociales','portal','mixto')),
  mensaje text,
  estado text not null default 'pendiente_revision' check (estado in ('pendiente_revision','aprobada','rechazada','lanzada','finalizada')),
  modelo_ia text,
  revisado_por text,
  revisado_en timestamptz,
  creado_en timestamptz not null default now(),
  constraint campanas_empresa_id_id_key unique (empresa_id, id)
);
comment on table public.marketing_campanas is 'Propuestas de campaña de MKT-07. Ninguna se lanza sin aprobación humana.';
alter table public.marketing_campanas enable row level security;

create table public.marketing_campana_inmuebles (
  empresa_id text not null,
  campana_id uuid not null,
  inmueble_id uuid not null,
  primary key (campana_id, inmueble_id),
  foreign key (empresa_id, campana_id) references public.marketing_campanas(empresa_id, id) on delete cascade,
  foreign key (empresa_id, inmueble_id) references public.inmuebles(empresa_id, id)
);
alter table public.marketing_campana_inmuebles enable row level security;

create table public.marketing_campana_destinatarios (
  empresa_id text not null,
  campana_id uuid not null,
  comprador_id uuid not null,
  primary key (campana_id, comprador_id),
  foreign key (empresa_id, campana_id) references public.marketing_campanas(empresa_id, id) on delete cascade,
  foreign key (empresa_id, comprador_id) references public.compradores(empresa_id, id)
);
alter table public.marketing_campana_destinatarios enable row level security;

create function public.exigir_consentimiento_comercial() returns trigger
language plpgsql set search_path = public as $$
begin
  if not exists (select 1 from public.compradores c
                 where c.id = new.comprador_id and c.empresa_id = new.empresa_id
                   and c.consentimiento_comercial) then
    raise exception 'El comprador % no tiene consentimiento comercial: no puede ser destinatario de campañas', new.comprador_id;
  end if;
  return new;
end $$;

create trigger trg_destinatarios_consentimiento
before insert or update on public.marketing_campana_destinatarios
for each row execute function public.exigir_consentimiento_comercial();

-- 7. Vistas de entrada para MKT-07 (sin email ni teléfono: minimización)
create view public.v_mkt07_necesidades_activas with (security_invoker = true) as
select n.id as necesidad_id, n.empresa_id, n.codigo as necesidad_codigo,
       c.id as comprador_id, c.codigo as comprador_codigo, c.perfil, c.idioma,
       c.financiacion, c.estado_comercial, c.consentimiento_comercial,
       n.operacion, n.tipos, n.municipios, n.zonas, n.precio_min, n.precio_max,
       n.habitaciones_min, n.banos_min, n.superficie_min_m2,
       n.caracteristicas_imprescindibles, n.caracteristicas_deseables,
       n.urgencia, n.fecha_objetivo, n.notas
from public.necesidades_inmobiliarias n
join public.compradores c on c.empresa_id = n.empresa_id and c.id = n.comprador_id
where n.estado = 'activa';

create view public.v_mkt07_inmuebles_disponibles with (security_invoker = true) as
select i.id as inmueble_id, i.empresa_id, i.referencia, i.operacion, i.tipo, i.titulo,
       i.precio, i.precio_periodo, i.municipio, i.zona, i.superficie_construida_m2,
       i.superficie_parcela_m2, i.habitaciones, i.banos, i.planta, i.ascensor,
       i.estado_conservacion, i.certificado_energetico, i.caracteristicas, i.precio_m2
from public.inmuebles i
where i.estado_publicacion = 'publicado';

create view public.v_mkt07_candidatos with (security_invoker = true) as
select n.*, i.inmueble_id, i.referencia, i.tipo, i.titulo, i.precio, i.precio_periodo,
       i.municipio, i.zona, i.superficie_construida_m2, i.superficie_parcela_m2,
       i.habitaciones, i.banos, i.ascensor, i.estado_conservacion, i.caracteristicas
from public.v_mkt07_necesidades_activas n
join public.v_mkt07_inmuebles_disponibles i
  on i.empresa_id = n.empresa_id and i.operacion = n.operacion;

-- 8. Esquema de evaluación (fuera de la API y de las vistas del agente)
create schema evaluacion;
revoke all on schema evaluacion from anon, authenticated;
create table evaluacion.mkt07_esperado (
  id bigint generated always as identity primary key,
  empresa_id text not null references public.empresas(id),
  necesidad_codigo text not null,
  inmueble_referencia text,
  encaje_esperado text not null check (encaje_esperado in ('total','parcial','ninguna')),
  apto_campana boolean,
  grupo_prueba text not null check (grupo_prueba in ('perfecto','parcial','no_encaja','trampa')),
  motivo text not null,
  constraint esperado_coherente check ((encaje_esperado = 'ninguna') = (inmueble_referencia is null))
);
comment on table evaluacion.mkt07_esperado is 'Respuestas correctas para evaluar MKT-07. El agente nunca debe leer esta tabla.';
