/**
 * @module router/auth
 * @description Rutas que gestionan autorización de la aplicación
 */
const { Router } = require('express')
const passport = require('passport')
const { login } = require('../controllers/auth.controller')

const router = Router()

/**
 * @name post/api/v1/auth/login
 * @memberof module:router/auth~AuthRouter
 * @inner
 * @description Autentica al usuario y le permite iniciar sesión en la aplicación.
 */
router.post('/login', passport.authenticate('local', { session: false }), login)

module.exports = router
