const { Router } = require('express')
const passport = require('passport')
const authRouter = require('./app/auth.router')
const adminRouter = require('./app/admin.router')
const checkRole = require('../middlewares/checkRole')

const router = Router()

// Rutas de aplicación
// Ruta de autenticación
router.use('/auth', authRouter)
// Ruta de administración
router.use('/admin', passport.authenticate('jwt', { session: false }), checkRole('Administrador', 'Empresa', 'Superusuario'), adminRouter)

// Rutas de página web
// Ruta de autenticación
router.use('/web/auth', authRouter)
// Ruta de administración
router.use('/web/admin', passport.authenticate('jwt', { session: false }), checkRole('Superusuario'), adminRouter)

module.exports = router


