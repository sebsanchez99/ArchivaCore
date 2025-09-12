const { Strategy, ExtractJwt } = require('passport-jwt')
const { configToken } = require("../../../config/config.js");


// Configurar la extracción y validación del token que posee el usuario

const options = {
    jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
    secretOrKey: configToken.secretKey
}

/**
 * @callback
 * @memberof Middlewares
 * @param {Object} payload Datos decodificados del token
 * @param {Function} done Callback para manejar el resultado de la autenticación
 * @description Configura la estrategia por Jwt
 * @returns {Strategy} Configuración de estrategia JWT
 */
const jwtStrategy = new Strategy(options, (payload, done) => {
    return done(null, payload)
})

module.exports = jwtStrategy