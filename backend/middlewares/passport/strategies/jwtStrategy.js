const { Strategy, ExtractJwt } = require('passport-jwt')
const { configToken } = require("../../../config/config");

/**
 * Configurar la extracción y validación del token que posee el usuario
 */
const options = {
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: configToken.secretKey
}

/**
 * @callback
 * Configura la estrategia por Jwt
 * @returns {Strategy} Configuración de estrategia JWT
 */
const jwtStrategy = new Strategy(options, (payload, done) => {
    return done(null, payload)
})

module.exports = jwtStrategy