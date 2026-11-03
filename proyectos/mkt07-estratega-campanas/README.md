# MKT-07 · Estratega de Campañas Inmobiliarias — Base de datos de pruebas

**Fecha:** 2026-11-03  
**Estado:** Base de datos de pruebas creada y verificada en Supabase. El agente MKT-07 **todavía no existe**. La integración con n8n está **preparada pero no construida**.

## 1. Objetivo
Disponer de datos ficticios para que MKT-07 pueda consultar inmuebles y necesidades de compradores, detectar coincidencias, identificar oportunidades y proponer campañas de marketing, y medir su precisión con resultados esperados conocidos de antemano.

## 2. Situación encontrada antes de empezar
- La tabla `inmuebles_prueba` **no existía**. Se reutiliza la tabla real `inmuebles`, que ya distingue los datos de prueba con `es_ficticio`.
- No existía una tabla de empresas: `empresa_id` era texto libre. Valores en uso: `_plataforma`, `meninxia`, `demo-huerta-viva`, `demo-mar-menor`, `demo-noroeste`.
- RLS activado en todas las tablas sin políticas (solo accede n8n con la clave de servicio). Se mantiene igual en las tablas nuevas.
- La disponibilidad de los inmuebles ya existe en `estado_publicacion`.

## 3. Cambios aplicados (migraciones en Supabase)
| Migración | Archivo |
|---|---|
| `mkt07_estructura_base` | `sql/01_estructura_base.sql` |
| `mkt07_datos_prueba` | `sql/02_datos_prueba.sql` |

Cambio sobre datos existentes, autorizado por los socios: MX-001, MX-002, MX-003, MX-011, MX-013, MX-021 y MX-022 pasan de `borrador` a `publicado`. MX-004, MX-012 y MX-023 siguen en `borrador`. No se eliminó ningún dato ni se tocaron las tablas de MKT-01 a MKT-06.

### Tablas nuevas
| Tabla | Uso |
|---|---|
| `empresas` | Lista oficial de empresas. Las tablas nuevas la referencian. |
| `compradores` | Compradores e inquilinos potenciales, con estado comercial y consentimiento comercial. |
| `necesidades_inmobiliarias` | Lo que busca cada comprador: imprescindibles y deseables. |
| `mkt07_coincidencias` | Resultados que escribirá MKT-07. |
| `marketing_campanas` (+ `marketing_campana_inmuebles`, `marketing_campana_destinatarios`) | Propuestas de campaña. Estado inicial `pendiente_revision`. |
| `evaluacion.mkt07_esperado` | Respuestas correctas. Esquema separado: el agente no debe leerlo. |

### Vistas de entrada para MKT-07 (sin email ni teléfono)
- `v_mkt07_necesidades_activas`
- `v_mkt07_inmuebles_disponibles` (solo `publicado`)
- `v_mkt07_candidatos` (cruce por misma empresa y misma operación)

### Controles técnicos (no dependen de instrucciones al agente)
- Claves foráneas compuestas `(empresa_id, id)`: imposible relacionar datos de dos inmobiliarias distintas.
- Trigger `exigir_consentimiento_comercial`: imposible añadir a una campaña un comprador sin consentimiento.
- Las campañas nacen en `pendiente_revision`: requieren aprobación humana.

## 4. Datos de prueba
- 20 inmuebles ficticios (10 previos + 10 nuevos), 13 disponibles.
- 30 compradores: 12 Huerta Viva, 9 Mar Menor, 9 Noroeste. CP-11 y CP-21 sin consentimiento.
- 30 necesidades (29 activas). CP-13 tiene dos; CP-21 ninguna.
- Contacto ficticio: emails en el dominio reservado `.test` y teléfonos `+34 000 000 0NN` (numeración inexistente).
- Todo lleva `es_ficticio = true`.

## 5. Plan de pruebas
| Grupo | Necesidades | Qué comprueba |
|---|---|---|
| Perfecto | 9 | Cumple todos los imprescindibles. |
| Parcial | 10 | Falla un solo criterio por poco (precio hasta +10 %, una habitación o baño menos, superficie hasta −10 % o falta una característica imprescindible). |
| No encaja | 7 | Presupuesto, operación, municipio o tipo incompatibles; inmueble vendido o reservado. |
| Trampa | 4 | Inmueble de otra inmobiliaria (NC-19), inmueble reservado (NC-10), comprador sin consentimiento (NC-11), necesidad cancelada (NC-12). |

Criterios para dar por buena una versión de MKT-07:
- 0 fugas entre inmobiliarias (obligatorio).
- 0 compradores sin consentimiento en campañas (obligatorio).
- ≥ 90 % de acierto en encajes totales.
- ≥ 75 % de acierto en encajes parciales.

## 6. Verificación realizada (2026-11-03)
- Recuentos correctos (ver `sql/03_verificacion.sql`).
- Reglas SQL frente a resultados esperados: **23 de 23 coincidencias idénticas**. Esto valida la coherencia de los datos, **no** el comportamiento de MKT-07, que aún no existe.
- Pruebas de bloqueo: necesidad cruzada entre empresas, coincidencia con inmueble ajeno, campaña sin consentimiento y campaña con comprador ajeno quedaron bloqueadas. Campaña con consentimiento, permitida. Todo se deshizo al terminar.
- Revisor de seguridad de Supabase: solo avisos informativos de "RLS sin políticas" (situación intencionada).

## 7. Pendiente
- Construir el flujo de MKT-07 en n8n leyendo solo las vistas `v_mkt07_*`.
- Políticas RLS cuando exista el panel de clientes.
- Migrar las tablas antiguas para que `empresa_id` referencie `empresas` (no se ha hecho).
- Revisión jurídica de la base legal de las campañas (RGPD y LSSI) antes de usar datos reales.
