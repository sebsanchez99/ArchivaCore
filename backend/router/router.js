const { Router } = require('express');
const passport = require('passport');
const authRouter = require('../router/auth.router');
const adminRouter = require('../router/admin.router');
const checkRole = require('../middlewares/checkRole');

const router = Router();

/**
 * @route /api/v1/auth
 * @description Rutas de autenticación para login, registro, etc.
 * @use {authRouter} Sub-rutas de autenticación.
 * @memberof module:routers/main~router
 */
router.use('/auth', authRouter);

/**
 * @route /api/v1/admin
 * @description Rutas de administración protegidas por autenticación y roles de usuario.
 * @use {passport.authenticate('jwt', { session: false })} Autenticación JWT para validar el usuario.
 * @use {checkRole} Middleware que verifica el rol del usuario.
 * @use {adminRouter} Sub-rutas de administración.
 * @memberof module:routers/main~router
 */
router.use('/admin', passport.authenticate('jwt', { session: false }), checkRole, adminRouter);

module.exports = router;
