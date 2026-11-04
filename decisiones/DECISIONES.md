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

Detalle técnico en `proyectos/mkt07-estratega-campanas/README.md`. Los nombres de tablas citados aquí cambiaron el 2026-11-04 (ver D-010).

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
**Decisión:** MKT-07 leerá solo vistas que excluyen email y teléfono. Las respuestas correctas de las pruebas se guardan en el esquema `evaluacion`, que el agente no debe consultar.  
**Estado:** Propuesta. Pendiente de ratificación de ambos socios.  
**Aprobada por:** Pendiente.  
**Justificación:** Minimización de datos y evaluación fiable de la precisión del agente.  
**Implementación:** Vistas y esquema creados. Flujo de n8n pendiente.

## 6. Decisiones técnicas — Organización de datos

Detalle técnico en `proyectos/organizacion-datos/README.md`.

### D-010 — Un esquema de Supabase por departamento y Drive organizado por cliente
**Fecha:** 2026-11-04  
**Decisión:** Los datos se agrupan en esquemas por departamento: `plataforma`, `inmobiliario`, `clientes`, `atencion_cliente` y `marketing`. Google Drive se organiza como `clientes/<empresa>/<departamento>`. Los workflows antiguos de n8n siguen funcionando mediante accesos directos temporales en `public`; los workflows nuevos deben usar los esquemas de departamento.  
**Estado:** Propuesta. Autorizada en conversación con Claude por un socio el 2026-11-04; pendiente de ratificación del segundo socio.  
**Aprobada por:** Pendiente.  
**Justificación:** Orden, permisos por departamento y, en Drive, poder entregar o borrar todos los datos de un cliente de una vez.  
**Implementación:** Operativa. Pendiente actualizar workflows antiguos y retirar accesos directos.

### D-011 — Clínica Sijé separada de los datos inmobiliarios
**Fecha:** 2026-11-04  
**Decisión:** Los datos del blog de Clínica Sijé pasan al esquema propio `clinica_sije`. La clave pública solo puede leer sus artículos publicados. A medio plazo, valorar trasladarlo a un proyecto de Supabase independiente.  
**Estado:** Propuesta. Autorizada en conversación con Claude por un socio el 2026-11-04; pendiente de ratificación del segundo socio.  
**Aprobada por:** Pendiente.  
**Justificación:** Es otro cliente y otro sector, con una web pública que accede a la base de datos. Debe estar aislado del resto.  
**Implementación:** Operativa (esquema propio). Proyecto independiente: pendiente de decisión.

## 7. Decisiones comerciales — Campañas personalizadas

Detalle técnico en `proyectos/mkt07-estratega-campanas/MOTOR_COINCIDENCIAS.md`.

### D-012 — Proponer también inmuebles que fallan en un detalle leve
**Fecha:** 2026-11-04  
**Decisión:** Las campañas personalizadas incluyen, además de los encajes totales y parciales, las "alternativas cercanas": inmuebles que fallan en un solo detalle leve (precio hasta un 10 % superior, una habitación o un baño menos, superficie hasta un 10 % menor o una característica imprescindible ausente). La campaña debe explicar la diferencia con claridad; nunca ocultarla. No se perdonan nunca: inmuebles vendidos, reservados o sin autorización, otra operación, otro tipo o municipio, ni compradores sin consentimiento.  
**Estado:** Propuesta. Autorizada en conversación con Claude por un socio el 2026-11-04; pendiente de ratificación del segundo socio.  
**Aprobada por:** Pendiente.  
**Justificación:** "Por un pequeño detalle no vamos a perder una venta." En los datos de prueba, 12 de las 23 oportunidades son alternativas cercanas. Explicar la diferencia protege la confianza del cliente y evita publicidad engañosa.  
**Implementación:** Motor de coincidencias operativo y verificado. Campaña y envío pendientes.  
**Sustituye a:** La regla "no recomendar inmuebles que incumplan requisitos obligatorios" del documento de especificación del sistema de compradores e inmuebles, en lo relativo a detalles leves.

## 8. Reglas de consulta
Antes de proponer cambios estratégicos, Claude y los agentes deberán consultar las decisiones relevantes.

Si no pueden acceder a este documento, deberán advertirlo.

Las decisiones pendientes de ratificación no se considerarán formalmente aprobadas.

## 9. Principio fundamental
Las decisiones deben ser trazables, verificables y revisables, respetando la autoridad de ambos responsables y la Constitución de MENINXIA.
