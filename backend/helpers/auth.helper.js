const jwt = require('jsonwebtoken')
const { configToken } = require("../config/config");
const ResponseUtil = require('../utils/response.util');

/**
 * @class Esta clase contiene métodos para la gestión de autenticación de usuarios.
 * @description AuthHelper es una clase que proporciona métodos para generar tokens de autenticación y verificar la validez de los mismos.
 */
class AuthHelper {

    /**
     * Método que genera token de usuario con datos incluidos
     * @param {string} idUser  Id de usuario
     * @param {string} userRole  Rol de usuario
     * @returns {ResponseUtil} Respuesta en formato JSON
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
        return ResponseUtil.success('Inicio de sesión exitoso', token)
    }
}

module.exports = AuthHelper