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
        const { _usu_id, _usu_nombre, _usu_activo, _rol_nombre, _emp_id, _emp_nombre} = req.user   
        const authHelper = new AuthHelper()
        const payload = {
            userId: _usu_id,
            role: _rol_nombre,
            company: _emp_id,
            companyName: _emp_nombre,
        }
        if (_rol_nombre === 'Superusuario' || _rol_nombre === 'Asesor') {
            return res.json(ResponseUtil.fail('No posee permisos para ingresar.'))
        }
        
        if (!_usu_activo) {
            return res.json(ResponseUtil.fail('Su cuenta se encuentra inactiva. Contacte con el administrador.'))
        }
        const expired = await authHelper.verifyCompanyPlanDate(_emp_id)
        if (expired) {
            return res.json(ResponseUtil.fail('Su plan ha expirado. Contacte con el administrador.'))
        }      
        const token = authHelper.generateToken(payload)
        res.json(ResponseUtil.success('Token generado exitosamente', {
            token,
            userId: _usu_id,
            username: req.user._usu_nombre,
            userRole: _rol_nombre,
            companyName: _emp_nombre,
        }))
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    login
}