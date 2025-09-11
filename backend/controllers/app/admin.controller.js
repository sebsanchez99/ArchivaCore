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
        const { company } = req.user
        const adminHelper = new AdminHelper()
        const result = await adminHelper.listUsers(company)
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
        const{ company } = req.user
        const { username, fullname, password, idRol } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.createUsers(username, fullname, password, idRol, company)
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
        const{ company } = req.user
        const { id, fullname, username, password, idRol } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.userUpdate(id, fullname, username, password, idRol, company)
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
        const currentIdUser = req.user.userId
        const { id } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.deleteUsers(id, currentIdUser)
        res.json(result)        
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const getRoles = async (req, res) => {
    try {
        const adminHelper = new AdminHelper()
        const result = await adminHelper.getRoles()
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const changeUserState = async (req, res) => {
    try {
        const { userId } = req.user
        const { idRol, newState } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.changeUserState(idRol, userId, newState)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    listUsers,
    createUsers, 
    userUpdate, 
    deleteUser,
    getRoles,
    changeUserState
};


