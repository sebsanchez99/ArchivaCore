/**
 * @namespace Rutas
 * @description Grupo principal de rutas de la API.
 */
const { Router } = require('express');
const passport = require('passport');
const authRouter = require('../router/auth.router');
const adminRouter = require('../router/admin.router');
const checkRole = require('../middlewares/checkRole');

const router = Router();


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
