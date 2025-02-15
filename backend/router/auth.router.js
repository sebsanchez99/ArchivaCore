const { Router } = require('express')
const passport = require('passport')
const { login } = require('../controllers/auth.controller')

const router = Router()

/** 
 * Autentica al usuario con estrategia local
*/
// http://localhost:3000/api/v1/auth/login
router.post('/login', passport.authenticate('local', {session: false}),login)

module.exports = router
