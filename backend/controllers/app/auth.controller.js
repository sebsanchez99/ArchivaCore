const AuthHelper = require('../../helpers/auth.helper')
const ResponseUtil = require('../../utils/response.util')

/**
 * Controlador que permite controlar la generación del token y enviarlo al usuario
 * @param {} req petición 
 * @param {} res respuesta
 */
const login = async (req, res) => {
    try {
        const { _usu_id, _rol_nombre, _emp_nombre } = req.user    
        const authHelper = new AuthHelper()
        const result = authHelper.generateToken(_usu_id, _rol_nombre, _emp_nombre)
        res.json(result)      
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    login
}