const { Router } = require('express')
const authRouter = require('../router/auth.router')

const router = Router()

router.use('/auth',authRouter)

module.exports = router


