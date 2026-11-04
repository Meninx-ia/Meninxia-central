# Motor de coincidencias (paso 1 de 5)

**Fecha:** 2026-11-04  
**Estado:** Creado en Supabase y verificado con los datos de prueba. Todavía no lo usa ningún workflow de n8n.

## Qué es
Una función de Supabase, sin IA, que para cada comprador con una necesidad activa devuelve los inmuebles disponibles de su inmobiliaria, clasificados y explicados. Es el punto de partida de la campaña personalizada.

- Función: `clientes.buscar_coincidencias(p_empresa_id, p_necesidad_id)`; ambos parámetros son opcionales.
- Vista con todos los resultados: `clientes.v_coincidencias`.
- Solo accesible con la clave de servicio (n8n).

## Reglas

**Nunca se perdona** (el inmueble no aparece):
- Otra inmobiliaria, otra operación (venta o alquiler), inmueble no publicado o necesidad no activa.
- Tipo de inmueble o municipio distintos de los que pide el comprador.
- Dos o más detalles leves a la vez.

**Se perdona un detalle leve** (grupo "cercana"):
- Precio hasta un 10 % por encima del máximo.
- Una habitación o un baño menos.
- Superficie hasta un 10 % menor.
- Una característica imprescindible ausente.

**Grupos:**
| Grupo | Significado |
|---|---|
| `total` | Cumple todo lo obligatorio y lo deseable |
| `parcial` | Cumple todo lo obligatorio; falta algo deseable o la zona preferida |
| `cercana` | Falla en un solo detalle leve. Se propone igualmente, explicando la diferencia |

**Puntuación (0-100):** parte de 100 y resta 2 puntos por cada 1 % de precio por encima, 15 por habitación menos, 10 por baño menos, 2 por cada 1 % de superficie menos, 20 por característica imprescindible ausente, 5 por cada deseable ausente y 5 si está fuera de la zona preferida.

**Avisos:**
- Sin consentimiento comercial: no se le puede enviar la campaña (`apto_envio = false`).
- Supera el presupuesto con hipoteca preaprobada: revisar financiación.

## Verificación (2026-11-04)
- 23 de 23 coincidencias esperadas, sin ninguna que falte ni sobre.
- Lo que antes se esperaba como "parcial" (un detalle leve) sale ahora como `cercana`; lo esperado como "total" sale como `total` o `parcial`.
- Las 10 necesidades trampa (vendidos, reservados, otra inmobiliaria, cancelada, sin oferta) devuelven 0 resultados.
- El comprador sin consentimiento (CP-11) sale con `apto_envio = false`.
- Reparto: 10 totales, 1 parcial y 12 cercanas.

## Pendiente
- El aviso de hipoteca no se ha activado nunca: falta un caso de prueba que lo provoque (paso 2).
- Comprobar encargos (propio, compartido o ajeno) cuando exista la tabla (paso 2).
- El formato de precios ("285000.00") lo adaptará MKT-07 al redactar.
