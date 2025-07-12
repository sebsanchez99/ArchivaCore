const { Router } = require('express')
const { 
    listUsers, 
    createUsers, 
    userUpdate, 
    deleteUser, 
    getRoles, 
    changeUserState 
} = require('../../controllers/app/admin.controller.js')

const router = Router();

const adminRouter = router;

/**
 * @memberof Rutas.AdminRoutes
 * @name get/api/v1/admin/listUsers
 * @description Obtiene la lista de todos los usuarios.
 */
adminRouter.get('/listUsers', listUsers);

/**
 * @memberof Rutas.AdminRoutes
 * @name post/api/v1/admin/createUser
 * @description Crea un nuevo usuario en el sistema.
 */
adminRouter.post('/createUser', createUsers);

/**
 * @memberof Rutas.AdminRoutes
 * @name put/api/v1/admin/updateUser
 * @description Actualiza la información de un usuario existente.
 */
adminRouter.put('/updateUser', userUpdate);

/**
 * @memberof Rutas.AdminRoutes
 * @name delete/api/v1/admin/deleteUser
 * @description Elimina un usuario del sistema.
 */
adminRouter.delete('/deleteUser', deleteUser);

/**
 * @memberof Rutas.AdminRoutes
 * @name delete/api/v1/admin/getRoles
 * @description Obtiene los roles disponibles en el sistema.
 */
adminRouter.get('/getRoles', getRoles);

/**
 * @memberof Rutas.AdminRoutes
 * @name delete/api/v1/admin/changeUserState
 * @description Cambia el estado del usuario.
 */
adminRouter.put('/changeUserState', changeUserState);

module.exports = adminRouter;
