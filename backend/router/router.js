const { Router } = require('express')
const passport =require('passport')
const authRouter = require('../router/auth.router')
const adminRouter = require('../router/admin.router')
const checkRole  = require('../middlewares/checkRole')

const router = Router()

// Ruta de autenticación
router.use('/auth',authRouter)
// Ruta de administración
router.use('/admin', passport.authenticate('jwt', {session: false}), checkRole, adminRouter)


module.exports = router


