const express = require('express')
const multer = require('multer')
const router = express.Router()
const upload = multer({ dest: 'uploads/' })
const { resumenCV } = require("../../controllers/app/microservice.controller")

/**
 * @route POST /microservice/resumen-cv
 * @description Subir un CV en PDF y recibir resumen generado por Gemini
 */
router.post('/resumenCV', upload.single('cv'), resumenCV)

module.exports = router
