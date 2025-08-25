
const NotificationHelper = require('../../helpers/notification.helper')
const ResponseUtil = require('../../utils/response.util')

const listUserNotifications = async (req, res) => {
  try {
    const { userId } = req.user
    const notificationHelper = new NotificationHelper()
    const result = await notificationHelper.listUserNotifications(userId)
    res.json(result)
  } catch (error) {
    return res.status(500).json(
      ResponseUtil.fail('Error interno al listar las notificaciones.', error.message)
    )
  }
}


const createNotification = async (req, res) => {
  try {
    const { userId } = req.user
    const { title, message  } = req.body
    const notificationHelper = new NotificationHelper()
    const result = await notificationHelper.createNotification(userId, title, message)
    res.json(result)
  } catch (error) {
      res.status(500).send(ResponseUtil.fail(error.message))
      
  }
}

const deteleNotification = async (req, res) => {
  try {
    const { userId } = req.user
    const { notificationId } = req.body
    const notificationHelper = new NotificationHelper()
    const result = await notificationHelper.deteleNotification(userId, notificationId)
    res.json(result)
  } catch (error) {
      res.status(500).send(ResponseUtil.fail(error.message))
      
  }
}

const deleteAllNotification = async (req, res) => {
  try {
    const { userId } = req.user
    const notificationHelper = new NotificationHelper()
    const result = await notificationHelper.deleteAllNotification(userId)
    res.json(result)
  } catch (error) {
      res.status(500).send(ResponseUtil.fail(error.message))
  }
}

const markNotification = async (req, res) => {
  try {
    const { userId } = req.user
    const { notificationId } = req.body
    const notificationHelper = new NotificationHelper()
    const result = await notificationHelper.markNotification(notificationId, userId)
    res.json(result)
  } catch (error) {
      res.status(500).send(ResponseUtil.fail(error.message))
  }
}

const markAllNotifications = async (req, res) => {
  try {
    const { userId } = req.user
    const notificationHelper = new NotificationHelper()
    const result = await notificationHelper.markAllNotifications(userId)
    res.json(result)
  } catch (error) {
      res.status(500).send(ResponseUtil.fail(error.message))
  }
}

module.exports = {
  listUserNotifications,
  createNotification,
  deteleNotification,
  deleteAllNotification,
  markNotification,
  markAllNotifications
}