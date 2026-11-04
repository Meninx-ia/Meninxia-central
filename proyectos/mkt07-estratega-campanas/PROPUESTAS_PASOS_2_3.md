# Campañas personalizadas — pasos 2 y 3

**Fecha:** 2026-11-04  
**Estado:** Pasos 1 a 3 de 5 construidos y verificados con datos ficticios. **Nada se envía todavía**: las propuestas quedan pendientes de revisión humana.

## Proceso completo
1. Motor de coincidencias (sin IA). Ver `MOTOR_COINCIDENCIAS.md`. **Hecho.**
2. Encargos, propuestas e historial. **Hecho.**
3. MKT-07 en n8n: redacta email y WhatsApp y los guarda como borrador. **Hecho.**
4. Revisión por un socio y envío por email. Pendiente.
5. WhatsApp (API de WhatsApp Business de Meta). Pendiente.

## Paso 2 — Tablas nuevas (migraciones `paso2_*` en Supabase)
| Tabla | Para qué sirve |
|---|---|
| `inmobiliario.encargos` | Autorización para ofrecer un inmueble: `propio` (titular) o `compartido` (otra inmobiliaria autorizada), con fechas. Un trigger impide encargos propios de otra empresa y compartidos de la propia. |
| `inmobiliario.v_encargos_vigentes` | Encargos en vigor hoy. |
| `inmobiliario.v_inmuebles_comercializables` | Inmuebles publicados con encargo vigente, por inmobiliaria que puede ofrecerlos. |
| `clientes.propuestas` | Borradores de campaña (email y WhatsApp) y su estado. |
| `clientes.propuesta_inmuebles` | Inmuebles de cada propuesta, enlazados a su encargo. |
| `clientes.historial_ofertas` | Qué se ofreció a cada comprador y qué respondió. |

Columnas nuevas en `clientes.compradores`: `canal_preferido` (`email` o `whatsapp`) y `consentimiento_whatsapp`.

### Controles en la base de datos
- Solo se ofrecen inmuebles con encargo vigente (clave foránea al encargo + trigger de vigencia).
- No se puede usar el encargo de otra inmobiliaria.
- Una propuesta idéntica (`firma_contenido`) no se puede repetir.
- No se puede enviar una propuesta que no haya aprobado una persona.
- No se puede aprobar ni enviar sin consentimiento comercial, ni por WhatsApp sin consentimiento de WhatsApp.
- Un inmueble rechazado no vuelve a ofrecerse salvo bajada de precio de al menos un 5 % o cambio de necesidades.

### Verificación
- Motor: 25 de 25 coincidencias esperadas.
- Inmueble sin encargo y con encargo caducado: no aparecen.
- Inmueble compartido: lo ven solo los compradores de la inmobiliaria autorizada.
- Rechazado al mismo precio: no reaparece. Rechazado y rebajado un 5 %: reaparece con aviso.
- Avisos de hipoteca preaprobada y de WhatsApp sin consentimiento: funcionan.
- 8 intentos prohibidos sobre propuestas: todos bloqueados por el motivo correcto.

## Paso 3 — MKT-07 en n8n
**Workflow:** "MKT-07 · Estratega comercial" (proyecto personal Meninxia en n8n). Se lanza a mano. Está limitado a 3 compradores por ejecución mientras haya pruebas.

**Entrada:** `clientes.v_propuestas_pendientes` (migración `paso3_*`). Un registro por comprador con consentimiento, con sus 3 mejores inmuebles y lo que busca. Sin email ni teléfono. Excluye propuestas ya creadas.

**Pasos del workflow:**
1. Leer propuestas pendientes (Supabase, esquema `clientes`).
2. Claude Sonnet 5.5 redacta asunto, email y WhatsApp en el idioma del comprador, explicando con honestidad cada diferencia.
3. Control automático: cita todas las referencias, longitudes razonables y **ninguna cifra en euros que no coincida con un precio, el presupuesto o una diferencia exacta** (formatos español, inglés, francés y alemán). Si falla, la propuesta queda en `borrador` con el motivo.
4. Guardar la propuesta y sus inmuebles en Supabase. **No envía nada.**

**Requisito:** los esquemas `clientes` e `inmobiliario` están expuestos en Supabase → Integrations → Data API → Settings.

### Verificación (7 propuestas de prueba)
- Idiomas: español (3), inglés (2), alemán (1) y francés (1).
- Todas las afirmaciones de los textos se comprobaron contra las fichas: ningún dato inventado.
- Las diferencias se explican con el dato exacto (p. ej. "5,6 % por encima del presupuesto", "9,4 % au-dessus").
- Ningún texto menciona avisos internos (rechazos, puntuaciones, códigos de comprador).
- Todos incluyen la identificación como comunicación comercial y la opción de baja (LSSI).
- El control automático tuvo falsos positivos en su primera versión (presupuesto y diferencias calculadas) y no revisaba precios con el símbolo delante ("€285,000"). Ambos corregidos y probados con 8 casos, incluidos precios falsos. Las 4 propuestas afectadas se corrigieron a mano y quedaron marcadas en `revisado_por`.
- Coste: 7 llamadas a Claude.

## Pendiente
- Paso 4: revisión por un socio, nueva comprobación de disponibilidad, encargo y consentimiento, y envío por email. En pruebas, los correos llegarán a los socios, nunca a compradores.
- Paso 5: WhatsApp.
- Lanzar MKT-07 automáticamente cuando cambie un comprador o un inmueble (cola de eventos).
- Fotos: ningún medio está aprobado todavía para marketing; las campañas son solo de texto.
- Revisión jurídica del texto legal de las comunicaciones comerciales antes de usar datos reales.
