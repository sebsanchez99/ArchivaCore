/**
 * @namespace Helpers
 * @description Helper para análisis de hoja de vida usando Gemini
 */
const OpenAI = require( 'openai')
const pdfParse = require("pdf-parse")
const mammoth = require("mammoth")
const { configGPT } = require("../config/config")
const { buildPrompt } = require('../utils/prompt.util')
const ResponseUtil = require('../utils/response.util')

const models = {
  accurate: "gpt-4.1",               
  balanced: "gpt-4o",                
  fast: "gpt-4o-mini",               
  cheap: "gpt-3.5-turbo",            
}

class AIHelper {

  constructor(){
    this.client = new OpenAI({
      apiKey: configGPT.gptApiKey
    })
  }

  /**
   * @method extractTextFromBuffer
   * @description Extrae texto desde un archivo en memoria (PDF, DOCX, TXT)
   * @param {Buffer} buffer - Contenido del archivo en bytes
   * @param {string} ext - Extensión del archivo (.pdf, .docx, .txt)
   * @returns {Promise<string>} Texto extraído
   */
  async extractTextFromBuffer(buffer, ext) {
    const extension = ext.toLowerCase()

    if (extension === ".pdf") {
      const data = await pdfParse(buffer)
      return data.text
    }

    if (extension === ".docx") {
      const result = await mammoth.extractRawText({ buffer })
      return result.value
    }

    if (extension === ".txt") {
      return buffer.toString("utf-8")
    }

    throw new Error(`Formato no soportado: ${extension}`)
  }

  /**
   * @method analyzeCV
   * @description Analiza un CV con Gemini en base a una oferta
   * @param {Buffer} buffer - Archivo en memoria
   * @param {string} ext - Extensión del archivo
   * @param {string} offerText - Texto de la oferta
   * @returns {Promise<Object>} Objeto JSON generado por Gemini
   */
  async analyzeCV(buffer, ext, offerText, mode = 'balanced') {
    const cvText = await this.extractTextFromBuffer(buffer, ext)
    const prompt = buildPrompt(cvText, offerText)
    const model = models[mode] || models.balanced
    try {
      const response = await this.client.chat.completions.create({
        model,
        messages: [
          { role: "system", content: "Eres un asistente que ayuda a analizar hojas de vida en base a ofertas laborales. Responde estrictamente en formato JSON y bien estructurado." },
          { role: "user", content: prompt }
        ],
        temperature: 0.2,
      })
      const raw = response.choices[0].message.content
      const clean = raw.replace(/```json/g, "").replace(/```/g, "").trim()
      const jsonResponse = JSON.parse(clean)
      return ResponseUtil.success('Resumen generado exitosamente.', jsonResponse)
    } catch (err) {
      return ResponseUtil.fail('Hubo un error al realizar el análisis. Intenta de nuevo.')
    }
  }
}

module.exports = AIHelper
