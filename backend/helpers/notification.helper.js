const path = require('path')
const poolNewClient = require('../libs/postgres')
const ResponseUtil = require('../utils/response.util')
const { log } = require('console')

class NotificationsUser {
    async listUserNotifications(userId) {
        const { rows } = await poolNewClient.query(
            'SELECT * FROM listar_notificaciones_usuario($1)',
            [userId]
        )
        return ResponseUtil.success('Notificaciones listadas correctamente', rows)
    }

    async createNotification(userId, title, message) {
        await poolNewClient.query(
            'SELECT * FROM insertar_notificacion($1,$2,$3)',
            [title, message, userId]
        )
        return ResponseUtil.success('Notificación creada correctamente')
    }

    async deteleNotification(userId, notificationId) {
        const result = await poolNewClient.query(
            'SELECT * FROM eliminar_notificacion_usuario($1,$2)',
            [notificationId, userId]

        )
        return ResponseUtil.success('Notificación eliminada correctamente')

    }

    async deleteAllNotification(userId) {
        await poolNewClient.query(
            'SELECT * FROM eliminar_notificaciones_usuario($1)',
            [userId]
        )
        return ResponseUtil.success('Notificaciones eliminadas correctamente')
    }

    async markNotification(notificationId, userId) {
        await poolNewClient.query(
            'SELECT * FROM marcar_notificacion_recibida($1,$2)',
            [notificationId, userId]
        )
        return ResponseUtil.success('notificaciones recibida marcada correctamente')
    }

    async markAllNotifications(userId) {
        await poolNewClient.query(
            'SELECT * FROM marcar_notificaciones_recibidas($1)',
            [userId]
        )
        return ResponseUtil.success('notificaciones recibida marcada correctamente')
    }

}




module.exports = NotificationsUser
