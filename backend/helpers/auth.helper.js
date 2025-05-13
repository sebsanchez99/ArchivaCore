const jwt = require('jsonwebtoken')
const bcrypt = require('bcrypt');
const { configToken } = require("../config/config");
const ResponseUtil = require('../utils/response.util');
const pool = require('../libs/postgres');

/**
 * @class Esta clase contiene métodos para la gestión de autenticación de usuarios.
 * @memberof Helpers
 * @description AuthHelper es una clase que proporciona métodos para generar tokens de autenticación y verificar la validez de los mismos.
 */
class AuthHelper {

    /**
     * Método que genera un token con un payload genérico
     * @param payload - Objeto con los datos a incluir en el token
     * @param options - Opciones adicionales para el token (opcional)
     * @returns Respuesta en formato JSON
     */
    generateToken(payload, options = {}) {
        const tokenOptions = {
            expiresIn: configToken.expireToken,
            ...options // Permite sobrescribir opciones predeterminadas
        }
        const token = jwt.sign(payload, configToken.secretKey, tokenOptions)
        return ResponseUtil.success('Token generado exitosamente', token)
    }

    async registerCompany(companyName, companyEmail, password){
        const companyExist = await this.#verifyCompany(companyEmail)
        if (companyExist) {
            return ResponseUtil.fail('El nombre de empresa ya existe. Seleccione otro.')
        }
        const hashPassword = await bcrypt.hash(password, 10)
        await pool.query('SELECT * FROM agregar_empresa($1, $2, $3)', [companyName, companyEmail, hashPassword])
        return ResponseUtil.success('Empresa registrada con éxito')
    }   

    /**
     * Verifica la existencia del nombre de la empresa en la base de datos
     * @param {*} companyEmail Email de empresa
     * @returns Valor booleano indicando si la empresa existe
     */
    async #verifyCompany(companyEmail) {
        const companyExist = await pool.query('SELECT * FROM obtener_empresa_por_correo($1)', [companyEmail])
        if (companyExist.rows.length > 0) {
            return true
        } else {
            return false
        }
    }
}

module.exports = AuthHelper