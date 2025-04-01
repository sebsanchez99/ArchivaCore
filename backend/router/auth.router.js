const { Router } = require('express')
const passport = require('passport')
const { login } = require('../controllers/auth.controller')

const router = Router()

/**
 * @name post/api/v1/auth/login
 * @memberof Rutas.AuthRoutes
 * @description Autentica al usuario y le permite iniciar sesión en la aplicación.
 */
router.post('/login', passport.authenticate('local', { session: false }), login)

module.exports = router
