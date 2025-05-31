/**
 * @namespace Controladores
 * @description Controladores de la API
 */
const AdminHelper = require('../../helpers/admin.helper')
const ResponseUtil = require('../../utils/response.util')

/**
 * @namespace AdminController
 * @memberof Controladores
 * @description Controladores de administración.
 */

/**
 * @memberof Controladores.AdminController
 * @function listUsers
 * @description Controlador que permite listar los usuarios desde la BD
 * @param {Object} req Petición
 * @param {Object} res Respuesta
 */
const listUsers = async(req, res) => {
    try {
        const adminHelper = new AdminHelper()
        const result = await adminHelper.listUsers()
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

/**
 * @memberof Controladores.AdminController
 * @function createUsers
 * @description Controlador que permite crear usuario
 * @param {*} req Petición
 * @param {*} res Respuesta
 */
const createUsers = async(req, res) => {
    try {
        const { username, password, rolUser, idCompany } = req.body
        const adminHelper = new AdminHelper()
        const idRol = await adminHelper.obtenerRol(rolUser)
        const result = await adminHelper.createUsers(username, password, idRol, idCompany)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}


/**
 * @memberof Controladores.AdminController
 * @function userUpdate
 * @description Controlador que permite Actualizar usuario
 * @param {Object} req Petición 
 * @param {Object} res Respuesta
 */
const userUpdate = async(req, res) => {
    try {
        const { id, username, password, rolUser, idCompany } = req.body
        const adminHelper = new AdminHelper()
        const idRol = await adminHelper.obtenerRol(rolUser)
        const result = await adminHelper.userUpdate(id, username, password, idRol, idCompany)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

/**
 * @function deleteUser
 * @memberof Controladores.AdminController
 * @description Controlador que permite eliminar usuario por id
 * @param {Object} req Petición
 * @param {Object} res Respuesta
 */
const deleteUser = async(req, res) => {
    try {
        const idUser = req.user.id
        const { id } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.deleteUsers(id,idUser)
        res.json(result)        
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    listUsers,
    createUsers, 
    userUpdate, 
    deleteUser
};


