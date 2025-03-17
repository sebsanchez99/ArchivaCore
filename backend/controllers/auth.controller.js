const AuthHelper = require('../helpers/auth.helper')

/**
 * Controlador que permite controlar la generación del token y enviarlo al usuario
 * @param {} req petición 
 * @param {} res respuesta
 */
const login = async (req, res) => {
    try {
        const { _usu_id, _rol_nombre } = req.user    
        const authHelper = new AuthHelper()
        const token = authHelper.generateToken(_usu_id, _rol_nombre)
        res.json({
            result: true,
            message: 'Inicio de sesión exitoso',
            data: token
        })      
    } catch (error) {
        res.status(500).send({
            result: false,
            message: error.message
        })
    }
}

module.exports = {
    login
}