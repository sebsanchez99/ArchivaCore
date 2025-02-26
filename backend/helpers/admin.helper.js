const jwt = require('jsonwebtoken')
const { configToken } = require("../config/config")
const pool = require("../libs/postgres");
const bcrypt = require('bcrypt');


class AdminHelper{

    /**
     * Endpoint con query para listar usuarios
     * @returns  usuarios listados
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
     * Endpoint con query para obtener el rol del usuario
     * @param {*} rolName Rol del usuario  
     * @returns Rol del usuario
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
     * Endpoint con query para obtener usuario, compararlo  y crear usuario si es posible
     * @param {*} username Nombre de usuario
     * @param {*} password Hash de usuario
     * @param {*} rolUser Rol de usuario
     * @returns Usuario creado 
     */
    async createUsers(username, password, rolUser){
        const userExist = await pool.query(
            'SELECT * FROM obtener_usuario($1)',
            [username]
        )
        if (userExist.rows.length > 0){
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
     * Endpoint con query para actualizar usuario por id
     * @param {*} id Id de usuario  
     * @param {*} username Nombre de usuario
     * @param {*} password Hash de usuario
     * @param {*} rolUser Rol de usuario
     * @returns Usuario Actualizado
     */
    async userUpdate(id, username, password, rolUser){
        const hashPassword = await bcrypt.hash( password ,  10 )
        const userExist = await pool.query(
            'SELECT * FROM obtener_usuario($1)',
            [username]
        )
        if (userExist.rows.length > 0){
            throw new Error('El usuario ya existe')
        }

        const updateUser = await pool.query(
            'SELECT * FROM actualizar_usuario( $1, $2, $3, $4 )',
            [id, username, hashPassword, rolUser]
        )
        return updateUser
    }

    /**
     * Endpoint con query para eliminar usuario por id
     * @param {*} id Id de usuario
     * @returns Usuario eliminado
     */
    async deleteUsers(id){
        const userDelete = await pool.query(
            'SELECT * FROM eliminar_usuario($1)',
            [id]
        )
        return userDelete
    }

        
}

    

module.exports = AdminHelper