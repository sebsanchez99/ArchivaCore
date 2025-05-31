const AuthHelper = require('../../helpers/auth.helper')
const ResponseUtil = require('../../utils/response.util')

/**
 * @namespace AuthController
 * @memberof Controladores
 * @description Controladores de autenticación.
 */

/**
 * @function login
 * @memberof Controladores.AuthController
 * @description Controlador que permite controlar la generación del token y enviarlo al usuario
 * @param {Object} req petición 
 * @param {Object} res respuesta
 */
const login = async (req, res) => {
    try {
        const { _usu_id, _rol_nombre, _emp_nombre } = req.user    
        const authHelper = new AuthHelper()
        const payload = {
            userId: _usu_id,
            role: _rol_nombre,
            company: _emp_nombre
        }
        const result = authHelper.generateToken(payload)
        res.json(result)      
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    login
}