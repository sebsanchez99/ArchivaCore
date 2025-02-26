const passport = require('passport')
const localStrategy =require ('./strategies/localStrategy')
const jwtStrategy = require ('./strategies/jwtStrategy')

// Configura las estrategias a usar en Passport
passport.use(localStrategy)
passport.use(jwtStrategy)

module.exports = passport