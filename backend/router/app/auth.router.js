const { Router } = require('express')
const passport = require('passport')
const { login, changePassword } = require('../../controllers/app/auth.controller.js')
const checkRole = require('../../middlewares/checkRole.js')

const router = Router()

// http://localhost:3000/api/v1/auth/login
router.post('/login', passport.authenticate('appLocalStrategy', {session: false}), login)

// http://localhost:3000/api/v1/auth/changePassword
router.put('/changePassword', passport.authenticate('jwt', { session: false }), checkRole('Administrador', 'Empresa', 'Usuario'), changePassword)

module.exports = router
