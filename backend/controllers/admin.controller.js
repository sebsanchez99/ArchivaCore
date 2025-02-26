const AdminHelper = require('../helpers/admin.helper')

/**
 * Controlador que permite listar los usuarios desde la BD
 * @param {*} req Petición
 * @param {*} res Respuesta
 */
const listUsers = async(req, res) => {
    try {
        const adminHelper = new AdminHelper()
        const usersList = await adminHelper.listUsers()
        res.json({
            result: true,
            message: "Usuarios listados exitosamente",
            data: usersList
        })
    } catch (error) {
        res.status(500).send({
            result: false,
            message: error.message
        })
    }
}

/**
 * Controlador que permite crear usuario
 * @param {*} req Petición
 * @param {*} res Respuesta
 */
const createUsers = async(req, res) => {
    try {
        const { username, password, rolUser } = req.body
        const adminHelper = new AdminHelper()
        const idRol = await adminHelper.obtenerRol(rolUser)
        await adminHelper.createUsers(username, password, idRol)
        res.json({
            result: true,
            message: "Usuario creado exitosamente"
        })
    } catch (error) {
        const status = error.message == 'El usuario ya existe' ? 400 : 500
        res.status(status).send({
            result: false,
            message: error.message
        })
    }
}


/**
 * Controlador que permite Actualizar usuario
 * @param {*} req Petición 
 * @param {*} res Respuesta
 */
const userUpdate = async(req, res) => {
    try {
        const { id, username, password, rolUser } = req.body
        const adminHelper = new AdminHelper()
        const idRol = await adminHelper.obtenerRol(rolUser)
        await adminHelper.userUpdate(id, username, password, idRol)
        res.json({
            result: true,
            message: "usuario actualizado exitosamente"
            
        })
    } catch (error) {
        res.status(500).send({
            result: false,
            message: error.message
        })
    }
}

/**
 * Controlador que permite eliminar usuario por id
 * @param {*} req Petición
 * @param {*} res Respuesta
 */
const deleteUser = async(req, res) => {
    try {
        const { id } = req.body
        const adminHelper = new AdminHelper()
        await adminHelper.deleteUsers(id)
        res.json({
            result: true,
            message: "Usuario eliminado exitosamente"
        })        
    } catch (error) {
        res.status(500).send({
            result: false,
            message: error.message
        })
    }
}

module.exports = {
    listUsers,
    createUsers, 
    userUpdate, 
    deleteUser
};


