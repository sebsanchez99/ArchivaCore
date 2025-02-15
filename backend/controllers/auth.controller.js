const AuthHelper = require('../helpers/auth.helper')

/**
 * EntPoint que permite controlar la generación del token y enviarlo al usuario
 * @param {} req petición 
 * @param {} res respuesta
 */
const login = async (req, res) => {
    const {username} = req.body
    const authHelper = new AuthHelper()
    const token = authHelper.generateToken(username)
    res.json(token)
}

module.exports = {
    login
}