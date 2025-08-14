const { Router } = require('express')
const passport = require('passport')
const checkRole = require('../middlewares/checkRole')
const authAppRouter = require('./app/auth.router')
const adminAppRouter = require('./app/admin.router')
const folderRouter = require('./app/folder.router')
const microRouter = require('./app/micro.router')
const authWebRouter = require('./web/auth.router')
const supabaseWebRouter = require('./web/supabase.router')
const adminWebRouter = require('./web/admin.router')
const settingsWebRouter = require('./web/settings.router')
const notificationRouter = require('./app/notification.router')

const router = Router()

// Rutas de aplicación
// Ruta de autenticación
/**
 * @namespace AuthRoutes
 * @memberof Rutas
 * @description Rutas relacionadas con la autenticación (login, registro, etc.).
 */
router.use('/auth', authAppRouter)

// Ruta de administración
/**
 * @namespace AdminRoutes
 * @memberof Rutas
 * @description Rutas protegidas para la administración.
 * @middleware {passport.authenticate} JWT Authentication
 * @middleware {checkRole} Verificación de rol del usuario.
 */
router.use('/admin', passport.authenticate('jwt', { session: false }), checkRole('Administrador', 'Empresa'), adminAppRouter)

/**
 * @namespace folderRouter
 * @memberof Rutas
 * @description Rutas relacionadas con el Storage Supabase
*/
router.use('/supa', passport.authenticate('jwt', { session: false }), checkRole('Usuario', 'Empresa', 'Administrador'), folderRouter)

router.use("/microservice", passport.authenticate('jwt', {session: false}), checkRole('Usuario','Empresa', 'Administrador'), microRouter)

router.use("/notifications", passport.authenticate('jwt', {session: false}), checkRole('Usuario','Empresa', 'Administrador'), notificationRouter )
// Rutas de página web
// Ruta de autenticación
router.use('/web/auth', authWebRouter)

router.use('/web/admin', passport.authenticate('jwt', { session: false }), checkRole('Superusuario'), adminWebRouter)

router.use('/web/supabase', passport.authenticate('jwt', { session: false }), checkRole('Empresa', 'Administrador'), supabaseWebRouter)

router.use('/web/settings', passport.authenticate('jwt', { session: false }), settingsWebRouter)

module.exports = router;
