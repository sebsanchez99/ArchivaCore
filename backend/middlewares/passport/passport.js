const passport = require('passport')
const localStrategy =require ('./strategies/localStrategy')


passport.use(localStrategy)

module.exports = passport