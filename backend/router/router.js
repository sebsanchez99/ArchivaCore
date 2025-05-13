const { Router } = require('express')
const passport = require('passport')
const authAppRouter = require('./app/auth.router')
const adminAppRouter = require('./app/admin.router')
const authWebRouter = require('./web/auth.router')
const checkRole = require('../middlewares/checkRole')

const router = Router()

// Rutas de aplicación
// Ruta de autenticación
router.use('/auth', authAppRouter)
// Ruta de administración
router.use('/admin', passport.authenticate('jwt', { session: false }), checkRole('Administrador', 'Empresa', 'Superusuario'), adminAppRouter)

// Rutas de página web
// Ruta de autenticación
router.use('/web/auth', authWebRouter)

module.exports = router


/**
 * @namespace AuthRoutes
 * @memberof Rutas
 * @description Rutas relacionadas con la autenticación (login, registro, etc.).
 */
router.use('/auth', authRouter);

/**
 * @namespace AdminRoutes
 * @memberof Rutas
 * @description Rutas protegidas para la administración.
 * @middleware {passport.authenticate} JWT Authentication
 * @middleware {checkRole} Verificación de rol del usuario.
 */
router.use('/admin', passport.authenticate('jwt', { session: false }), checkRole, adminRouter);

module.exports = router;
