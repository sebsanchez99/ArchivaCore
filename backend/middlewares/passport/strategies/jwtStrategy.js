const { Strategy, ExtractJwt } = require('passport-jwt')
const jwt = require('jsonwebtoken')
const { configToken } = require("../../../config/config");

/**
 * Configurar la extracción y validación del token que posee el usuario
 */
const options = {
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: configToken.secretKey
}

/**
 * Configura la estrategia por Jwt
 */
const jwtStrategy = new Strategy(options, (payload, done) => {
    return done(null, payload)
})

module.exports = jwtStrategy