const pool = require("../libs/postgres");
const bcrypt = require('bcrypt');

class AdminHelper{

    /**
     * Método que lista usuarios
     * @returns Lista de usuarios con datos 
     */
    async listUsers(){
        const result = await pool.query(
            // 'SELECT listar_usuarios()'
            'SELECT * FROM listar_usuarios()',
        )
        const usersList = result.rows
        return usersList
    }

    /**
     * Método que obtiene id de rol
     * @param {*} rolName Nombre de rol del usuario  
     * @returns Id de rol
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
     * @returns Resultado de query 
     */
    async createUsers(username, password, rolUser){
        const userExist = await this.#verifyUser(username)
        if (userExist) {
            throw new Error('El usuario ya existe')
        }
        const hashPassword =  await bcrypt.hash( password ,  10 )
        const createUser = await pool.query(            
            'SELECT * FROM agregar_usuario($1, $2, $3)',
            [username, hashPassword, rolUser]
        )
        return createUser
    }

    /**
     * Método que actualiza usuario
     * @param {*} id Id de usuario  
     * @param {*} username Nombre de usuario
     * @param {*} password Hash de usuario
     * @param {*} rolUser Rol de usuario
     * @returns Resultado de query
     */
    async userUpdate(id, username, password, rolUser){
        const userExist = await this.#verifyUser(username)
        if (userExist) {
            throw new Error('El usuario ya existe')
        }
        const hashPassword = await bcrypt.hash( password ,  10 )
        const updateUser = await pool.query(
            'SELECT * FROM actualizar_usuario( $1, $2, $3, $4 )',
            [id, username, hashPassword, rolUser]
        )
        return updateUser
    }

    /**
     * Método que elimina usuario
     * @param {*} id Id de usuario
     * @returns Resultado de query
     */
    async deleteUsers(id){
        const userDelete = await pool.query(
            'SELECT * FROM eliminar_usuario($1)',
            [id]
        )
        return userDelete
    }

    /**
     * Verifica la existencia del nombre de usuario en la base de datos
     * @param {*} username Nombre de usuario
     * @returns Valor booleano indicando si el usuario existe
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