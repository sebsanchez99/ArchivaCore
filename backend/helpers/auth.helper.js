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
            ...options 
        }
        const token = jwt.sign(payload, configToken.secretKey, tokenOptions)
        return token
    }

    async verifyCompanyPlanDate(companyId) {
        const result = await pool.query('SELECT * FROM obtener_dias_restantes_por_empresa($1)', [companyId])
        const days = result.rows[0].obtener_dias_restantes_por_empresa
        const expired = days === 0 ? true : false
        return expired
    }

    async registerCompany(companyName, fullname, companyEmail, password){
        const companyEmailExist = await this.#verifyCompanyEmail(companyEmail)
        const companyNameExist = await this.#verifyCompanyName(companyName)
        if (companyEmailExist) {
            return ResponseUtil.fail('Este correo ya se encuentra registrado. Seleccione otro.')
        }
        if (companyNameExist) {
            return ResponseUtil.fail('Este nombre ya se encuentra registrado. Seleccione otro.')
        }
        const hashPassword = await bcrypt.hash(password, 10)
        await pool.query('SELECT * FROM agregar_empresa($1, $2, $3, $4)', [companyName, fullname, companyEmail, hashPassword])
        return ResponseUtil.success('Empresa registrada con éxito')
    }   

    /**
     * Verifica la existencia del correo de la empresa en la base de datos
     * @param {*} companyEmail Email de empresa
     * @returns Valor booleano indicando si el correo de la empresa existe
     */
    async #verifyCompanyEmail(companyEmail) {
        const companyEmailExist = await pool.query('SELECT * FROM obtener_empresa_por_correo($1)', [companyEmail])
        return companyEmailExist.rows.length > 0
    }

    /**
     * Verifica la existencia del nombre de la empresa en la base de datos
     * @param {*} companyName Nombre de la empresa
     * @returns Valor booleano indicando si el nombre de la empresa existe
     */
    async #verifyCompanyName(companyName) {
        const companyNameExist = await pool.query('SELECT * FROM obtener_empresa_por_nombre($1)', [companyName])
        return companyNameExist.rows.length > 0
    }
}

module.exports = AuthHelper