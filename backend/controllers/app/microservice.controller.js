/**
 * @namespace Controladores
 * @description Controladores de la API
 */
const CVHelper = require('../../helpers/microservice.helper')
const ResponseUtil = require('../../utils/response.util')
const fs = require('fs')
const path = require('path')

/**
 * @namespace MicroserviceController
 * @memberof Controladores
 * @description Controlador para resumen de CV con Gemini
 */

/**
 * @memberof Controladores.MicroserviceController
 * @function resumenCV
 * @description Extrae y analiza PDF de hoja de vida con Gemini
 * @param {*} req 
 * @param {*} res 
 */
const resumenCV = async (req, res) => {
  try {
    const { ofertaText, hVText } = req.body

    // const cvText = await CVHelper.extractTextFromPDF(file.path)
    const resumen = await CVHelper.analyzeCV(hVText,ofertaText )

    res.json(ResponseUtil.success('Resumen generado exitosamente.', { resumen }))
  } catch (error) {
    console.error('Error en resumenCV:', error)
    res.status(500).send(ResponseUtil.fail('Error interno al generar resumen.'))
  } finally {
    if (req.file) {
      fs.unlinkSync(path.resolve(req.file.path))
    }
  }
}

module.exports = {
  resumenCV
}
