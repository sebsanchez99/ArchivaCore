const { Router } = require('express')
const passport = require('passport')
const { register } = require('../../controllers/web/auth.controller')

const router = Router()

// http://localhost:3000/api/v1/web/auth/register
router.post('/register', register)

module.exports = router