const pool = require('../libs/postgres.js')

class ChatHelper {
  /**
   * Inserta un nuevo mensaje en el chat.
   * @param {UUID} senderId - ID del remitente.
   * @param {UUID} recipientId - ID del destinatario.
   * @param {string} message - Contenido del mensaje.
   * @param {UUID} companyId - ID de la empresa.
   * @param {string} room - Nombre del room (sala de chat).
   * @returns {Promise<UUID>} ID del mensaje insertado.
   */
   async insertMessage(senderId, recipientId, message, companyId, room) {
    const result = await pool.query(
      `SELECT insertar_chat_mensaje($1, $2, $3, $4, $5) AS chat_id`,
      [senderId, recipientId, message, companyId, room]
    )
    return result.rows[0].chat_id
  }

  /**
   * Lista todos los mensajes en un room (sala de chat).
   * @param {string} room - Nombre del room (sala).
   * @returns {Promise<Array>} Lista de mensajes.
   */
   async listMessages(room) {
    const result = await pool.query(
      `SELECT * FROM listar_chat_mensajes($1)`,
      [room]
    )
    return result.rows
  }

  /**
   * Lista los últimos mensajes por conversación de un usuario.
   * @param {UUID} userId - ID del usuario.
   * @param {UUID} companyId - ID de la empresa.
   * @returns {Promise<Array>} Lista de últimas conversaciones.
   */
   async listUserConversations(userId, companyId) {
    const result = await pool.query(
      `SELECT * FROM listar_ultimos_chats_usuario($1, $2)`,
      [userId, companyId]
    )
    return result.rows
  }

  /**
   * Elimina un mensaje específico por su ID.
   * @param {UUID} chatId - ID del mensaje a eliminar.
   * @returns {Promise<boolean>} TRUE si fue eliminado correctamente.
   */
   async deleteMessage(chatId) {
    const result = await pool.query(
      `SELECT eliminar_chat_mensaje($1) AS deleted`,
      [chatId]
    )
    return result.rows[0].deleted
  }

  /**
   * Elimina todos los mensajes de un room específico.
   * @param {string} room - Nombre del room.
   * @returns {Promise<number>} Cantidad de mensajes eliminados.
   */
   async deleteMessagesByRoom(room) {
    const result = await pool.query(
      `SELECT eliminar_mensajes_por_room($1) AS count`,
      [room]
    )
    return result.rows[0].count
  }

  /**
   * Lista todos los rooms donde ha participado un usuario.
   * @param {UUID} userId - ID del usuario.
   * @returns {Promise<Array>} Lista de rooms y fecha del último mensaje.
   */
   async listUserRooms(userId) {
    const result = await pool.query(
      `SELECT * FROM listar_rooms_usuario($1)`,
      [userId]
    )
    return result.rows
  }
}

module.exports = ChatHelper
