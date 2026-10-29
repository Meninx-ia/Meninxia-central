# MENINXIA — HISTORIAL DE SESIONES
## 1. Objetivo
Esta carpeta conserva el historial de trabajo de MENINXIA para que ambos responsables y los futuros agentes puedan recuperar avances, decisiones y tareas pendientes. Cada sesión tendrá un archivo independiente.
## 2. Nombre de los archivos
Formato: `AAAA-MM-DD_HHMM_USUARIO.md`
Ejemplos: `2026-10-29_1030_team.md` y `2026-10-29_1730_team2.md`.
Se utilizará el horario de España peninsular. Si coinciden fecha, hora y usuario, se añadirá un identificador único para evitar sobrescrituras.
## 3. Contenido de cada sesión
Cada resumen incluirá:
- Fecha, hora y responsable.
- Objetivo y trabajo realizado.
- Resultados comprobados y decisiones tomadas.
- Problemas pendientes y próximos pasos.
- Archivos o sistemas modificados.
Se distinguirán claramente los hechos confirmados, las propuestas y las tareas pendientes.
## 4. Reglas de almacenamiento
1. Nunca sobrescribir sesiones anteriores.
2. No inventar avances ni decisiones.
3. No almacenar contraseñas, tokens, claves API ni datos personales de clientes.
4. Confirmar que GitHub ha guardado correctamente cada archivo.
5. Comunicar cualquier error de almacenamiento.
6. Mantener el historial accesible para ambos responsables autorizados.
## 5. Relación con la memoria principal
Los archivos de `sesiones/` conservan el historial detallado. `memoria/ESTADO_ACTUAL.md` contiene el resumen consolidado y se actualizará cuando corresponda. Las decisiones estratégicas relevantes se registrarán también en `decisiones/DECISIONES.md`.
## 6. Integración con Claude y n8n
Al finalizar una sesión, el procedimiento previsto será:
1. Generar un resumen estructurado.
2. Enviarlo al mecanismo de almacenamiento autorizado.
3. Crear un archivo independiente en `sesiones/`.
4. Confirmar el guardado en GitHub.
5. Actualizar el estado general y las decisiones cuando corresponda.
6. Comunicar el resultado al responsable.
**Importante:** esta automatización todavía debe implementarse y probarse. Conectar GitHub con Claude no guarda automáticamente las conversaciones.
## 7. Recuperación de contexto
Al comenzar una sesión, Claude deberá consultar la Constitución vigente, `memoria/ESTADO_ACTUAL.md`, las sesiones recientes relevantes y las decisiones permanentes. Si no puede acceder a estos documentos o no están sincronizados, deberá comunicarlo.
## 8. Principio fundamental
La memoria de MENINXIA debe ser compartida, verificable y recuperable, garantizando la continuidad del trabajo de ambos responsables y evitando pérdidas de información.
