/**
 * @module router/admin
 * @description Rutas de administración de usuarios
 */
const { Router } = require('express')
const { listUsers, createUsers, userUpdate, deleteUser } = require('../controllers/admin.controller.js')

const router = Router()

/**
 * @name get/api/v1/admin/listUsers
 * @memberof module:router/admin~AdminRouter
 * @inner
 * @description Obtiene la lista de todos los usuarios.
 */
router.get('/listUsers', listUsers)

/**
 * @name post/api/v1/admin/createUser
 * @memberof module:router/admin~AdminRouter
 * @inner
 * @description Crea un nuevo usuario en el sistema.
 */
router.post('/createUser', createUsers)

/**
 * @name put/api/v1/admin/updateUser
 * @memberof module:router/admin~AdminRouter
 * @inner
 * @description Actualiza la información de un usuario existente.
 */
router.put('/updateUser', userUpdate)

/**
 * @name delete/api/v1/admin/deleteUser
 * @memberof module:router/admin~AdminRouter
 * @inner
 * @description Elimina un usuario del sistema.
 */
router.delete('/deleteUser', deleteUser)

module.exports = router
