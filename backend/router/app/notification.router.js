const { Router } = require('express')
const { 
    
    listUserNotifications,
    createNotification,
    deteleNotification,
    deleteAllNotification,
    markNotification

} = require('../../controllers/app/notification.controller')

const router = Router()

/**
 * @memberof Rutas.NotificationsUser
 * @name get/api/v1/notifications/notificationsList
 * @description Lista las notificaciones de usuario
 */
router.get('/notificationsList', listUserNotifications)

/**
 * @memberof Rutas.NotificationsUser
 * @name get/api/v1/notifications/createNotification
 * @description crear las notificaciones de usuario
 */
router.post('/createNotification', createNotification)

/**
 * @memberof Rutas.NotificationsUser
 * @name get/api/v1/notifications/deteleNotification
 * @description Eliminar las notificaciones de usuario
 */
router.delete('/deteleNotification', deteleNotification)

/**
 * @memberof Rutas.NotificationsUser
 * @name get/api/v1/notifications/deleteAllNotification
 * @description Eliminar todas las notificaciones de usuario
 */
router.delete('/deleteAllNotification', deleteAllNotification)

/**
 * @memberof Rutas.NotificationsUser
 * @name get/api/v1/notifications/markNotification
 * @description marcar las notificaciones de usuario como leídas
 */
router.put('/markNotification', markNotification)

module.exports = router