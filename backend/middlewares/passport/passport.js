const passport = require('passport')
const LocalStrategy =require ('./strategies/localStrategy')


passport.use(LocalStrategy)

module.exports = passport