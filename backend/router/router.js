const { Router } = require('express')
const passport =require('passport')
const authRouter = require('../router/auth.router')
const adminRouter = require('../router/admin.router')

const router = Router()

router.use('/auth',authRouter)
router.use('/admin', passport.authenticate('jwt', {session: false}),adminRouter)

module.exports = router


