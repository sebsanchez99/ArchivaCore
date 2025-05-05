const jwt = require('jsonwebtoken')
const { configToken } = require("../config/config");
const ResponseUtil = require('../utils/response.util');

class AuthHelper {

    /**
     * Método que genera token de usuario con datos incluidos
     * @param idUser - Id de usuario
     * @param userRole - Rol de usuario
     * @param companyName - Nombre de la empresa
     * @returns Respuesta en formato JSON
     */
    generateToken(idUser, userRole, companyName) {
        const payload = {
            id: idUser, 
            role: userRole,
            company: companyName
        }
        const options = {
            expiresIn: configToken.expireToken
        }
        const token = jwt.sign(payload, configToken.secretKey , options)
        return ResponseUtil.success('Inicio de sesión exitoso', token)
    }
}

module.exports = AuthHelper