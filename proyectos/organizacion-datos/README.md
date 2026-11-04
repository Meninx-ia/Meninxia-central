# Organización de datos por departamentos

**Fecha:** 2026-11-04  
**Estado:** Aplicado en Supabase y Google Drive y verificado. Los workflows de n8n **no se han modificado** y siguen funcionando gracias a los accesos directos.

## 1. Supabase: un esquema por departamento

Antes, todas las tablas estaban en `public`. Ahora cada departamento tiene su propio esquema. En el editor de tablas de Supabase se elige con el desplegable de esquemas.

| Esquema | Contenido | Tablas y vistas |
|---|---|---|
| `plataforma` | Configuración común | `empresas`, `almacen_carpetas` |
| `inmobiliario` | Catálogo y archivos de inmuebles | `inmuebles`, `medios`, `v_medios`, `v_inmuebles_disponibles` |
| `clientes` | Compradores y lo que buscan | `compradores`, `necesidades`, `coincidencias`, `v_necesidades_activas`, `v_candidatos` |
| `atencion_cliente` | Correos y respuestas | `correos_analizados`, `borradores_respuesta`, `correos_pendientes_respuesta` |
| `marketing` | Contenido publicitario | `estudios`, `guiones`, `personajes`, `escenas`, `videos`, `campanas`, `campana_inmuebles`, `campana_destinatarios` |
| `clinica_sije` | **Cliente independiente** (psicología) | `blog_posts`, `noticias`, `fuentes`, `busquedas` |
| `evaluacion` | Respuestas esperadas para evaluar agentes | `mkt07_esperado` |

Funciones: `marketing.exigir_consentimiento_comercial()` y `clinica_sije.normalizar_fuentes_blog()`.

### Cambios de nombre
| Antes | Ahora |
|---|---|
| `inmueble_medios` | `inmobiliario.medios` |
| `v_inmueble_medios` | `inmobiliario.v_medios` |
| `v_mkt07_inmuebles_disponibles` | `inmobiliario.v_inmuebles_disponibles` |
| `necesidades_inmobiliarias` | `clientes.necesidades` |
| `mkt07_coincidencias` | `clientes.coincidencias` |
| `v_mkt07_necesidades_activas` | `clientes.v_necesidades_activas` |
| `v_mkt07_candidatos` | `clientes.v_candidatos` |
| `marketing_estudios`, `marketing_guiones`, etc. | `marketing.estudios`, `marketing.guiones`, etc. |

Los scripts de `proyectos/mkt07-estratega-campanas/sql/` usan los nombres antiguos porque documentan lo que se ejecutó en su momento. Para consultas nuevas, usar los nombres de esta tabla.

## 2. Accesos directos temporales en `public`

Para no romper los workflows de n8n, en `public` quedan vistas con los nombres antiguos que apuntan a las tablas nuevas. Leen y escriben exactamente igual que antes. Todas llevan un comentario "ACCESO DIRECTO TEMPORAL".

| Acceso directo | Apunta a | Lo usan |
|---|---|---|
| `inmuebles`, `inmueble_medios`, `v_inmueble_medios` | `inmobiliario.*` | MKT-02 a MKT-06, comprobaciones |
| `correos_analizados`, `borradores_respuesta`, `correos_pendientes_respuesta` | `atencion_cliente.*` | Clasificador y redactor |
| `marketing_estudios`, `_guiones`, `_personajes`, `_escenas`, `_videos` | `marketing.*` | MKT-01 a MKT-06 |
| `almacen_carpetas` | `plataforma.almacen_carpetas` | Agentes que guardan archivos, comprobaciones |
| `blog_posts`, `noticias`, `fuentes`, `busquedas` | `clinica_sije.*` | Agente del blog. **`blog_posts` lo usa también la web pública de Clínica Sijé** |

**Reglas:**
- Los workflows nuevos deben usar las tablas de su departamento, no los accesos directos.
- Los accesos directos se podrán borrar cuando cada workflow antiguo se actualice a la ruta nueva.
- `public.blog_posts` **no se puede borrar** hasta cambiar la web de Clínica Sijé.
- Para que n8n use los esquemas nuevos directamente, hay que añadirlos en Supabase → Project Settings → Data API → Exposed schemas.

## 3. Permisos
- Cada departamento solo es accesible con la clave de servicio (la que usa n8n).
- La clave pública (`anon`) solo puede **leer artículos publicados** de `clinica_sije.blog_posts`. Antes tenía permisos de escritura sobre las cuatro tablas del blog: RLS los bloqueaba, pero se han retirado.

## 4. Google Drive

Organizado primero por cliente y después por departamento:

```
(raíz MENINXIA)/
├── _plataforma/
│   └── _marketing-personajes/
└── clientes/
    ├── demo-huerta-viva/
    │   ├── inmobiliario/   MX-001 … MX-004
    │   ├── marketing/
    │   └── atencion_cliente/
    ├── demo-mar-menor/
    │   ├── inmobiliario/   MX-011 … MX-013
    │   ├── marketing/
    │   └── atencion_cliente/
    └── demo-noroeste/
        ├── inmobiliario/   MX-021 … MX-023
        ├── marketing/
        └── atencion_cliente/
```

Mover carpetas en Drive no cambia su identificador. Los agentes trabajan con identificadores (`plataforma.almacen_carpetas.id_externo`), así que no les afecta. La columna `ruta` de `almacen_carpetas` es un nombre lógico, no la ubicación física.

Las carpetas nuevas de departamentos aún no están registradas en `almacen_carpetas`. Se registrarán cuando un agente las necesite.

Las imágenes del blog de Clínica Sijé siguen en Supabase Storage (bucket `blog-imagenes`) y no se han tocado, para no romper las URLs de la web.

## 5. Verificación (2026-11-04)
- En la base de datos, para cada departamento: lectura, creación (con devolución del identificador), actualización y rechazo de duplicados a través de los accesos directos, con todo deshecho al terminar.
- Web de Clínica Sijé simulada con el rol `anon`: ve sus artículos publicados y no puede escribir ni leer nada más.
- Bloqueos de seguridad (empresas cruzadas y consentimiento comercial) siguen activos.
- n8n: el workflow "Comprobación completa Supabase + Drive" terminó con éxito después de cada cambio, incluido el movimiento de carpetas de Drive.
- No se han ejecutado los agentes que gastan saldo (MKT-01 a MKT-06, clasificador, redactor, blog). Su confirmación definitiva será su próximo uso.

## 6. Pendiente
- Actualizar cada workflow antiguo a la ruta nueva y borrar sus accesos directos.
- Valorar llevar Clínica Sijé a un proyecto de Supabase propio (aislamiento total, ver D-011).
- Añadir `empresa_id` a las tablas antiguas que no lo tienen.
