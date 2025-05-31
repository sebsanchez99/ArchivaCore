/**
 * @namespace Helpers
 * @description Grupo de helpers para la aplicación.
 */
const pool = require("../libs/postgres");
const bcrypt = require('bcrypt');
const ResponseUtil = require('../utils/response.util')

/**
 * @class Esta clase contiene métodos para la gestión de usuarios en la base de datos.
 * @memberof Helpers
 * @description AdminHelper es una clase que proporciona métodos para listar, crear, actualizar y eliminar usuarios en la base de datos.
 */
class AdminHelper{

    /**
     * Método que lista usuarios
     * @returns {ResponseUtil} Resultado de la operación en formato JSON
     */
    async listUsers(){
        const result = await pool.query(
            // 'SELECT listar_usuarios()'
            'SELECT * FROM listar_usuarios()',
        )
        const usersList = result.rows
        return ResponseUtil.success('La operación se realizó con éxito', usersList)
        
    }

    /**
     * Método que obtiene id de rol
     * @param {string} rolName Nombre de rol del usuario  
     * @returns {ResponseUtil} Resultado de la operación en formato JSON
     */
    async obtenerRol(rolName){
        const result = await pool.query(
            'SELECT * FROM obtener_id_rol($1)',
            [rolName]
        )
        const idRol = result.rows[0].obtener_id_rol 
        return idRol
    }

    /**
     * Método que crea usuario
     * @param {*} username Nombre de usuario
     * @param {*} password Hash de usuario
     * @param {*} rolUser Rol de usuario
     * @param {*} rolUser Rol de usuario
     * @param {*} idCompany Id que corresponde a empresa de usuario
     * @returns Resultado de la operación en formato JSON
     */
    async createUsers(username, password, rolUser, idCompany){
        const userExist = await this.#verifyUser(username)
        if (userExist) {
           return ResponseUtil.fail('El nombre de usuario ya existe, por favor modificarlo')
        }
        const hashPassword =  await bcrypt.hash( password ,  10 )
        await pool.query(            
            'SELECT * FROM agregar_usuario($1, $2, $3, $4)',
            [username, hashPassword, rolUser, idCompany]
        )
        return ResponseUtil.success('EL usuario se creó con éxito')
        
    }

    /**
     * Método que actualiza usuario
     * @param {*} id Id de usuario  
     * @param {*} username Nombre de usuario
     * @param {*} password Hash de usuario
     * @param {*} idCompany Empresa de usuario
     * @returns Resultado de la operación en formato JSON
     */
    async userUpdate(id, username, password, rolUser, idCompany){
        const hashPassword = await bcrypt.hash( password ,  10 )
        await pool.query(
            'SELECT * FROM actualizar_usuario( $1, $2, $3, $4, $5 )',
            [id, username, hashPassword, rolUser, idCompany]
        )
        return ResponseUtil.success('El usuario se actualizó con éxito')
    }

    /**
     * Método que elimina usuario
     * @param {string} id Id de usuario
     * @param {string} idUser Id del usuario que realiza la operación
     * @returns {ResponseUtil} Resultado de la operación en formato JSON
     */
    async deleteUsers(id, idUser){
        if(id==idUser){
            return ResponseUtil.fail('El usuario no se puede eliminar a si mismo, elija otro')
        }
        await pool.query(
            'SELECT * FROM eliminar_usuario($1)',
            [id]
        )
        return ResponseUtil.success('Usuario eliminado con éxito')

    }

    /**
     * @private
     * Verifica la existencia del nombre de usuario en la base de datos
     * @param {*} username Nombre de usuario
     * @returns {boolean} Valor booleano indicando si el usuario existe
     */
    async #verifyUser(username) {
        const userExist = await pool.query(
            'SELECT * FROM obtener_usuario($1)',
            [username]
        )
        if (userExist.rows.length > 0){
            return true
        } else {
            return false
        }
    }
        
}    

module.exports = AdminHelper