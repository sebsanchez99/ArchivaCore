const jwt = require('jsonwebtoken')
const bcrypt = require('bcrypt');
const { configToken } = require("../config/config");
const ResponseUtil = require('../utils/response.util');
const pool = require('../libs/postgres');

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

    async registerCompany(companyName, companyEmail, password){
        const companyExist = await this.#verifyCompany(companyName)
        if (companyExist) {
            return ResponseUtil.fail('El nombre de empresa ya existe. Seleccione otro.')
        }
        const hashPassword = await bcrypt.hash(password, 10)
        await pool.query('SELECT * FROM agregar_empresa($1, $2, $3)', [companyName, companyEmail, hashPassword])
        return ResponseUtil.success('Empresa registrada con éxito')
    }   

    /**
     * Verifica la existencia del nombre de la empresa en la base de datos
     * @param {*} companyName Nombre de empresa
     * @returns Valor booleano indicando si la empresa existe
     */
    async #verifyCompany(companyName) {
        const companyExist = await pool.query('SELECT * FROM obtener_empresa($1)', [companyName])
        if (companyExist.rows.length > 0) {
            return true
        } else {
            return false
        }
    }
}

module.exports = AuthHelper