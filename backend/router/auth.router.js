const { Router } = require('express')
const passport = require('passport')
const { login } = require('../controllers/auth.controller')

const router = Router()

// http://localhost:3000/api/v1/auth/login
router.post('/login', passport.authenticate('local', {session: false}), login)

module.exports = router

// Esto es otro ejemplo 