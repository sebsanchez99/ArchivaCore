const jwt = require('jsonwebtoken')
const { configToken } = require("../config/config")
const pool = require("../libs/postgres");
const bcrypt = require('bcrypt');


class AdminHelper{

    async listUsers(){
        const result = await pool.query(
            // 'SELECT listar_usuarios()'
            'SELECT * FROM listar_usuarios()'
        )
        const usersList = result
        return usersList
      
    }

    async DeleteUsers(){
        const userDelete = await pool.query(
            'DELETE FROM usuario WHERE usu_id = ? '
        )
        return userDelete
    }

    async CreateUsers(){
        const createUser = await pool.query(
            ''
        )
        return createUser
    }
        
}

    

module.exports = AdminHelper