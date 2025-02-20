const AdminHelper = require('../helpers/admin.helper')

/**
 * EntPoint que permite listar los usuarios desde la BD
 * @param {*} req Petición
 * @param {*} res Respuesta
 */
const listUsers =async(req, res) => {
    const adminHelper = new AdminHelper()
    const users = await adminHelper.listUsers()
    res.json(users)
    
}

// /**
//  * EntPoint que permite eliminar usuario por su ID
//  * @param {*} req Petición 
//  * @param {*} res Respuesta
//  */
// const deleteUsers = async(req, res) => {
//     const adminHelper = new AdminHelper()
//     const deleteUser = await adminHelper.deleteUsers()
//     res.json(deleteUser)
// }

// /**
//  * EndPoint que permite crear usuario
//  * @param {*} req Petición
//  * @param {*} res Respuesta
//  */
// const createUsers = async(req, res) => {
//     const adminHelper =new AdminHelper()
//     const createUser =await adminHelper.createUsers()
//     res.json(createUser)
// }

module.exports = {
    listUsers,
//   deleteUsers, 
//   createUsers
};


