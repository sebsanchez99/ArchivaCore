/**
 * @namespace Controladores
 * @description Controladores de la API
 */
const AIHelper = require('../../helpers/microservice.helper.js')
const ResponseUtil = require('../../utils/response.util.js')

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
    const { offerText } = req.body;
    const buffer = req.file.buffer;
    const ext = req.file.originalname.substring(req.file.originalname.lastIndexOf("."));
    const aiHelper = new AIHelper()
    const result = await aiHelper.analyzeCV(buffer, ext, offerText);
    res.json(result)
  } catch (error) {
    res.status(500).send(ResponseUtil.fail('Error interno al generar resumen.'))
  } 
}

module.exports = {
  resumenCV
}
