/**
 * @namespace Helpers
 * @description Helper para análisis de hoja de vida usando Gemini
 */
const pdfParse = require("pdf-parse")
const mammoth = require("mammoth")
const { GoogleGenerativeAI } = require("@google/generative-ai")
const { configGemini } = require("../config/config")
const { buildPrompt } = require('../utils/prompt.util')
const ResponseUtil = require('../utils/response.util')

class AIHelper {
  constructor() {
    this.genAI = new GoogleGenerativeAI(configGemini.geminiApiKey)
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
  async analyzeCV(buffer, ext, offerText) {
    const cvText = await this.extractTextFromBuffer(buffer, ext)
    const prompt = buildPrompt(cvText, offerText)

    const model = this.genAI.getGenerativeModel({ model: "gemma-3n-e2b-it" })
    const result = await model.generateContent(prompt)
    const raw = result.response.text()

    try {
      const clean = raw
        .replace(/```json/g, "")
        .replace(/```/g, "")
        .trim()
      const jsonResponse = JSON.parse(clean)
      return ResponseUtil.success('Resumen generado exitosamente.', jsonResponse)
    } catch (err) {
      return ResponseUtil.fail('Hubo un error al realizar el análisis. Intenta de nuevo.')
    }
  }
}

module.exports = AIHelper
