const passport = require('passport')
const { localStrategy, localCompanyStrategy } =require ('./strategies/localStrategy.js')
const jwtStrategy = require ('./strategies/jwtStrategy.js')

// Configura las estrategias a usar en Passport
passport.use('appLocalStrategy', localStrategy)
passport.use('webLocalStrategy', localCompanyStrategy)
passport.use(jwtStrategy)

module.exports = passport