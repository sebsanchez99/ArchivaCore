const AuthHelper = require('../helpers/auth.helper')
const ResponseUtil = require('../utils/response.util')

/**
 * @callback
 * Controlador que permite controlar la generación del token y enviarlo al usuario
 * @param {Object} req petición 
 * @param {Object} res respuesta
 */
const login = async (req, res) => {
    try {
        const { _usu_id, _rol_nombre } = req.user    
        const authHelper = new AuthHelper()
        const result = authHelper.generateToken(_usu_id, _rol_nombre)
        res.json(result)      
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    login
}