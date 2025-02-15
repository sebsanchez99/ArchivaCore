const jwt = require('jsonwebtoken')
const { configToken } = require("../config/config");

class AuthHelper {

    /**
     * Toma el nombre de usuario y genera el Token para retornarlo
     * @param username - Nombre de usuario
     * @returns Token de sesión con nombre de usuario
     */
    generateToken(username){
        const payload = {
            username: username
        }

        const options = {
            expiresIn: configToken.expireToken
        }

        const token = jwt.sign(payload, configToken.secretKey , options)

        return token
    }
}

module.exports = AuthHelper