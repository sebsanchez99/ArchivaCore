const express = require('express')
const multer = require('multer')
const router = express.Router()
const { resumenCV } = require("../../controllers/app/microservice.controller")

const upload = multer({ storage: multer.memoryStorage() })

/**
 * @route POST /microservice/resumen-cv
 * @description Subir un CV en PDF y recibir resumen generado por Gemini
 */
router.post('/resumenCV', upload.single('hvFile'), resumenCV)

module.exports = router
