/**
 * @namespace Helpers
 * @description Helper para análisis de hoja de vida usando Gemini
 */
const { GoogleGenerativeAI } = require('@google/generative-ai')
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY)



/**
 * @memberof Helpers
 * @function analyzeCV
 * @description Envia el texto del CV a Gemini para resumen inteligente
 * @param {string} pdfText Texto extraído del CV
 * @returns {Promise<string>} Resumen generado por Gemini
 */
const analyzeCV = async (pdfText, ofertaText) => {
  const prompt = `
"Considerando la \"Hoja de vida\" proporcionada y la \"Oferta de trabajo\" ingresada, 
realiza un análisis exhaustivo para generar un objeto JSON con la siguiente estructura 
y contenido: {\"Resumen del perfil\": \"Un resumen profesional de la hoja de vida, 
máximo 300 palabras. Debe incluir el rol principal, tecnologías clave, 
experiencia destacada y fortalezas.\", 
\"Resumen de compatibilidad\": \"Un breve párrafo que indique la compatibilidad 
general de la hoja de vida con la oferta de trabajo, basándose en la 
comparación de habilidades y experiencia. Se debe mencionar si se 
recomienda destacar alguna experiencia específica.\", \"Compatibilidad\": 
\"Porcentaje numérico de compatibilidad de la hoja de vida con el perfil 
buscado (ejemplo: 87).\", \"Experiencia\": \"Porcentaje numérico de la 
experiencia en años en el sector (ejemplo: 75).\", \"Habilidades\": 
\"Porcentaje numérico de las habilidades relevantes encontradas (ejemplo: 90).
\", \"Habilidades destacadas\": [\"Habilidad 1\", \"Habilidad 2\", 
\"Habilidad 3\", \"Habilidad 4\", \"Habilidad 5\"] 
(Máximo 5 habilidades clave de la hoja de vida que sean relevantes 
para la oferta, o habilidades generales si la oferta es muy abierta).
\", \"Áreas de mejora\": [\"Área de mejora 1\", \"Área de mejora 2\", 
\"Área de mejora 3\"] (Máximo 3 áreas donde el candidato podría mejorar 
para ajustarse mejor al perfil o la industria, incluyendo recomendaciones 
si es posible).\"} Instrucciones adicionales para el cálculo de 
compatibilidad: * Si la \"Compatibilidad\" es mayor al 70%, 
el perfil de comparación es \"alto\". * Si la \"Compatibilidad\" 
es mayor al 40% y menor o igual al 70%, el perfil de comparación es 
\"medio\". * De lo contrario, el perfil de comparación es \"bajo\". 
La respuesta debe ser únicamente el objeto JSON."
Hoja de vida:
${pdfText},
oderta de trabajo
${ofertaText}
`

  const model = genAI.getGenerativeModel({ model: 'gemma-3-4b-it' })
  const result = await model.generateContent(prompt)
  const response = await result.response
  return response.text()
}

module.exports = {
  analyzeCV
}
