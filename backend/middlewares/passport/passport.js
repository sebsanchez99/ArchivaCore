const passport = require('passport')
const localStrategy =require ('./strategies/localStrategy')
const jwtStrategy = require ('./strategies/jwtStrategy')


passport.use(localStrategy)


passport.use(jwtStrategy)


module.exports = passport