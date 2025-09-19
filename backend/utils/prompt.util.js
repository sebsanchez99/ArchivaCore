const buildPrompt = (cvText, offerText) => {
return `
Lee la "Hoja de vida" y la "Oferta de trabajo". Realiza todo el razonamiento internamente (no lo muestres) y entrega SOLO el JSON final minimizado (sin texto adicional ni bloques de código). No inventes información: si no hay evidencia explícita en la hoja de vida, marca como 0 o nula según corresponda.

Importante: No asumas que el puesto es tecnológico. El prompt debe funcionar para cualquier perfil (técnico, científico, administrativo, comercial, operativo, creativo, etc.). Detecta el dominio de la oferta por las palabras clave y adapta la extracción y el scoring a ese dominio.

Extracción del CV (no inventes):

Roles/Cargos: lista cada cargo con titulo, empresa (si aparece) y años o rango de fechas (si aparecen); si no hay años explícitos usa 0 o nula.

Educación: títulos, institución y área (si aparece).

Habilidades / herramientas / tecnologías / metodologías / idiomas / certificaciones: extrae las palabras exactas que aparecen en el CV. Diferencia entre habilidades técnicas y habilidades blandas cuando sea posible.

Logros medibles: cualquier resultado numérico o medible (por ejemplo: “aumenté X%”, “reducción de Y días”, “gestioné equipo de N personas”) con la frase exacta extraída.

Experiencia sectorial o en procesos relevantes (por ejemplo: gestión de proyectos, atención al cliente, laboratorio, ventas B2B, despliegue en nube, MLOps, análisis de datos): extrae evidencias textuales.

Extracción de la Oferta (clasifica requisitos):

Identifica y separa: Requisitos esenciales (lo que la oferta pide como obligatorio), Requisitos deseables (nice-to-have), Habilidades blandas, Certificaciones/educación requerida, Años de experiencia requeridos (si indica), Herramientas/tecnologías mencionadas.

Para matching, usa coincidencia insensible a mayúsculas y busca frases exactas o formas muy cercanas (sin extrapolar). Para perfiles no técnicos, trata igual elementos como “gestión de equipos”, “ventas B2B”, “control de calidad”, etc.

Regla general de matching y sinónimos:

Puedes mapear sinónimos muy comunes (ej. “inglés avanzado” ↔ “inglés C1”), pero solo si la evidencia textual es clara. No extrapoles (ej., que trabajar con MATLAB implique experiencia en Python).

Scoring (0–100 enteros) — sistema domain-agnóstico:

Calcula una Compatibilidad total sumando subcomponentes (pesos totales = 100):

Requisitos esenciales (CORE): 50 pts — proporción de requisitos esenciales con evidencia en CV (si no hay evidencia en este grupo, limita Compatibilidad a ≤ 20).

Habilidades secundarias / herramientas (SUPPORT): 20 pts — cobertura de requisitos deseables / herramientas.

Experiencia relevante (DOMAIN_EXP): 15 pts — años/directa experiencia en el área solicitada.

Educación / Certificaciones (EDU): 10 pts — grado o certificación requerida o altamente relevante.

Logros medibles (IMPACT): 5 pts — evidencia de resultados cuantificables relevantes.

Para cada subcomponente, si no hay evidencia textual puntúa 0. Redondea al entero más cercano.

Cálculo de Experiencia (campo separado):

Si la oferta pide X años explícitos: Experiencia = min(100, (años_relevantes_reportados / X) * 100).

Si la oferta no especifica años: usa regla heurística: 0 años→0, 1–2→25, 3–5→60, >5→100.

Habilidades (campo separado): 0–100 según la cobertura relativa de habilidades y herramientas pedidas por la oferta. Pondera elementos esenciales más que secundarios.

Reglas para “Habilidades destacadas” (clave para la interfaz):

Debe devolver máximo 5 strings.

Prioriza en este orden:

Skills que coincidan con requisitos esenciales y tengan evidencia textual en el CV.

Si no hay coincidencias esenciales, toma hasta 5 habilidades reales del CV relevantes al dominio de la oferta (por ejemplo: para un rol comercial prioriza “negociación”, “CRM”, “cierre”; para un rol de laboratorio prioriza “HPLC”, “validación”, etc.).

Nunca incluir skills que solo están en la oferta y no en el CV.

Evita duplicados y evita mostrar evidencia irrelevante al perfil buscado (por ejemplo: no mostrar HPLC/GC si la oferta es exclusivamente de ventas, salvo que la oferta pida explicitamente laboratorio).

Cada habilidad en el listado debe existir textual y literalmente en el CV.

Matriz de evidencias (obligatoria):

Construye Matriz de evidencias.skillsCoincidentes como array de objetos con: { "skill": "<texto del requisito>", "categoria": "<Esencial|Deseable|Blanda|Certificacion|Otro>", "evidenciaCV": "<frase exacta del CV o 0>" }.

skillsFaltantes: array con las skills/requisitos que aparecen en la oferta pero no tienen evidencia en el CV.

Output JSON (minimizado) — esquema en español (mantén exactamente estas claves):
{
"Resumen del perfil": string (≤300 palabras, redactado con la información extraída; no inventes),
"Resumen de compatibilidad": string (breve, 1–2 frases),
"Compatibilidad": number (0-100),
"Experiencia": number (0-100),
"Habilidades": number (0-100),
"Habilidades destacadas": [string,...] , // máximo 5, según regla arriba
"Áreas de mejora": [string,...] , // máximo 3, accionables y concretas (ej. "Formación en X", "Experiencia en gestión de equipos")
"Matriz de evidencias": {
"skillsCoincidentes": [
{"skill":"<texto>", "categoria":"<Esencial|Deseable|Blanda|Certificacion|Otro>", "evidenciaCV":"<frase exacta o 0>"},
...
],
"skillsFaltantes": [string,...]
},
"Motivo del puntaje": string (1–2 frases claras indicando la razón principal del puntaje),
"Nivel": "Alto" | "Medio" | "Bajo"
}

Reglas finales y formato:

- Usa 0 o [] si falta información.

- Si no hay información sobre los años de experiencia o no puedes calcular los años de experiencia, ponle 0.

- Entrega únicamente el JSON minimizado, sin comentarios, sin saltos de línea extra, sin código adicional.

- No incluyas URLs ni referencias externas.

- Si alguna información solicitada no aparece en el CV, usar 0, nula o [] según tipo.

- Prioriza evidencia textual literal del CV para todas las comprobaciones.

Usa ${cvText} y ${offerText} como las entradas (sustituir por el texto real al ejecutar).

Hoja de vida:
${cvText}

Oferta de trabajo:
${offerText}
`
}

module.exports = {
    buildPrompt
}