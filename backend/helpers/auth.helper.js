const jwt = require('jsonwebtoken')
const { configToken } = require("../config/config");

class AuthHelper {

    /**
     * Método que genera token de usuario con datos incluidos
     * @param idUser - Id de usuario
     * @returns Token de sesión 
     */
    generateToken(idUser, userRole){
        const payload = {
            id: idUser, 
            role: userRole
        }
        const options = {
            expiresIn: configToken.expireToken
        }
        const token = jwt.sign(payload, configToken.secretKey , options)
        return token
    }
}

module.exports = AuthHelper