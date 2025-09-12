const { Router } = require('express')
const passport = require('passport')
const { login, register } = require('../../controllers/web/auth.controller.js')

const router = Router()

// http://localhost:3000/api/v1/web/auth/register
router.post('/register', register)

// http://localhost:3000/api/v1/web/auth/login
router.post('/login', passport.authenticate('webLocalStrategy', { session: false }), login)

module.exports = router