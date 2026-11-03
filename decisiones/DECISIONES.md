# MENINXIA — REGISTRO DE DECISIONES

## 1. Objetivo
Conservar las decisiones estratégicas y técnicas de MENINXIA para garantizar la continuidad y coherencia del trabajo de ambos responsables y los futuros agentes.

## 2. Normas
1. Cada decisión tendrá un identificador único: D-001, D-002, etc.
2. Los identificadores no se reutilizarán.
3. Las decisiones estratégicas requerirán la aprobación de ambos responsables, salvo que la Constitución establezca otra regla.
4. Claude y los agentes podrán proponer decisiones, pero no aprobarlas por sí mismos.
5. No eliminar decisiones anteriores: las sustituidas conservarán su historial.
6. Diferenciar siempre la aprobación de una decisión de su implementación técnica.
7. Registrar cambios relevantes mediante GitHub.
8. No almacenar contraseñas, claves API ni datos confidenciales de clientes.

## 3. Formato de cada decisión
**ID:** D-XXX  
**Fecha:** AAAA-MM-DD  
**Decisión:** Descripción.  
**Estado:** Propuesta / Aprobada / Sustituida.  
**Aprobada por:** Responsables que la autorizaron.  
**Justificación:** Motivo.  
**Implementación:** Pendiente / En curso / Operativa / Bloqueada.  
**Sustituye a:** ID anterior, si corresponde.

## 4. Decisiones iniciales

### D-001 — Plataforma comercial
**Decisión:** Desarrollar MENINXIA como plataforma comercial de inteligencia artificial para empresas, comenzando por agencias inmobiliarias.  
**Estado:** Pendiente de ratificación documental.  
**Implementación:** En curso.

### D-002 — Claude Team
**Decisión:** Utilizar Claude Team como entorno compartido de planificación, análisis y coordinación.  
**Estado:** Pendiente de ratificación documental.  
**Implementación:** En curso.

### D-003 — GitHub
**Decisión:** Utilizar GitHub para conservar Constitución, memoria, sesiones y decisiones.  
**Estado:** Pendiente de ratificación documental.  
**Implementación:** En curso.

### D-004 — n8n Cloud
**Decisión:** Utilizar n8n Cloud para ejecutar automatizaciones y coordinar agentes.  
**Estado:** Pendiente de ratificación documental.  
**Implementación:** Pendiente de verificación.

### D-005 — Supabase
**Decisión:** Utilizar Supabase para almacenar datos estructurados de MENINXIA y sus futuros clientes.  
**Estado:** Pendiente de ratificación documental.  
**Implementación:** Pendiente de verificación.

## 5. Decisiones técnicas — MKT-07 (base de datos de pruebas)

Detalle técnico en `proyectos/mkt07-estratega-campanas/README.md`.

### D-006 — Una sola tabla de inmuebles para datos reales y de prueba
**Fecha:** 2026-11-03  
**Decisión:** No crear `inmuebles_prueba`. Los inmuebles de prueba viven en `inmuebles`, distinguidos por `es_ficticio = true`.  
**Estado:** Propuesta. Autorizada en conversación con Claude por un socio el 2026-11-03; pendiente de ratificación del segundo socio.  
**Aprobada por:** Pendiente.  
**Justificación:** Evita duplicar estructura y que los agentes tengan que consultar dos tablas.  
**Implementación:** Operativa.

### D-007 — Tabla `empresas` y claves foráneas compuestas
**Fecha:** 2026-11-03  
**Decisión:** Crear la tabla `empresas` como lista oficial de identificadores. Las tablas nuevas la referencian y usan claves compuestas `(empresa_id, id)` para que la base de datos impida relacionar datos de empresas distintas.  
**Estado:** Propuesta. Autorizada en conversación con Claude por un socio el 2026-11-03; pendiente de ratificación del segundo socio.  
**Aprobada por:** Pendiente.  
**Justificación:** La separación entre clientes debe imponerse técnicamente y no depender de instrucciones a los agentes.  
**Implementación:** Operativa en las tablas nuevas. Pendiente en las tablas anteriores.

### D-008 — Consentimiento comercial obligatorio por control técnico
**Fecha:** 2026-11-03  
**Decisión:** Un comprador sin `consentimiento_comercial` no puede ser destinatario de campañas; lo impide un trigger en la base de datos. Toda campaña nace en `pendiente_revision` y requiere aprobación humana.  
**Estado:** Propuesta. Pendiente de ratificación de ambos socios.  
**Aprobada por:** Pendiente.  
**Justificación:** Cumplimiento de RGPD y LSSI desde el diseño. La base legal concreta requiere revisión jurídica antes de usar datos reales.  
**Implementación:** Operativa.

### D-009 — Acceso de MKT-07 solo mediante vistas y evaluación separada
**Fecha:** 2026-11-03  
**Decisión:** MKT-07 leerá solo las vistas `v_mkt07_*`, que excluyen email y teléfono. Las respuestas correctas de las pruebas se guardan en el esquema `evaluacion`, que el agente no debe consultar.  
**Estado:** Propuesta. Pendiente de ratificación de ambos socios.  
**Aprobada por:** Pendiente.  
**Justificación:** Minimización de datos y evaluación fiable de la precisión del agente.  
**Implementación:** Vistas y esquema creados. Flujo de n8n pendiente.

## 6. Reglas de consulta
Antes de proponer cambios estratégicos, Claude y los agentes deberán consultar las decisiones relevantes.

Si no pueden acceder a este documento, deberán advertirlo.

Las decisiones pendientes de ratificación no se considerarán formalmente aprobadas.

## 7. Principio fundamental
Las decisiones deben ser trazables, verificables y revisables, respetando la autoridad de ambos responsables y la Constitución de MENINXIA.
