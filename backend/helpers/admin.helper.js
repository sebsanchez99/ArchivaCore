/**
 * @namespace Helpers
 * @description Grupo de helpers para la aplicación.
 */
const pool = require("../libs/postgres");
const bcrypt = require('bcrypt');
const ResponseUtil = require('../utils/response.util')

/**
 * @class Esta clase contiene métodos para la gestión de usuarios en la base de datos.
 * @memberof Helpers
 * @description AdminHelper es una clase que proporciona métodos para listar, crear, actualizar y eliminar usuarios en la base de datos.
 */
class AdminHelper{

    /**
     * Método que lista usuarios
     * @returns {ResponseUtil} Resultado de la operación en formato JSON
     */
    async listUsers(companyId){
        const result = await pool.query('SELECT * FROM listar_usuarios_por_empresa($1)', [companyId] )
        const usersList = result.rows
        return ResponseUtil.success('La operación se realizó con éxito.', usersList)
    }

    /**
     * Método que crea usuario
     * @param {*} username Nombre de usuario
     * @param {*} password Hash de usuario
     * @param {*} rolUser Rol de usuario
     * @param {*} rolUser Rol de usuario
     * @param {*} idCompany Id que corresponde a empresa de usuario
     * @returns Resultado de la operación en formato JSON
     */
    async createUsers(username, fullname, password, rolUser, idCompany){
        const userExist = await this.#verifyUser(username)
        const canAddAnUser = await this.#verifyTotalOfUsers(idCompany)
        if (!canAddAnUser) {
            return ResponseUtil.fail('No se puede agregar más usuarios a esta empresa, por favor actualice su plan.')
        }
        if (userExist) {
           return ResponseUtil.fail('El nombre de usuario ya existe, por favor elije otro.')
        }
        const hashPassword =  await bcrypt.hash( password ,  10 )
        await pool.query(   
            'SELECT * FROM agregar_usuario($1, $2, $3, $4, $5)',
            [username, fullname, hashPassword, rolUser, idCompany]
        )
        return ResponseUtil.success('EL usuario se creó con éxito.')
    }

    /**
     * Método que actualiza usuario
     * @param {*} id Id de usuario  
     * @param {*} username Nombre de usuario
     * @param {*} password Hash de usuario
     * @param {*} idCompany Empresa de usuario
     * @returns Resultado de la operación en formato JSON
     */
    async userUpdate(id, username, fullname, password, idRol, idCompany){
        const hashPassword = password != null ? await bcrypt.hash( password ,  10 ) : password
        await pool.query(
            'SELECT * FROM actualizar_usuario( $1, $2, $3, $4, $5, $6 )',
            [id, username, fullname, hashPassword, idRol, idCompany]
        )
        return ResponseUtil.success('El usuario se actualizó con éxito.')
    }

    /**
     * Método que elimina usuario
     * @param {string} id Id de usuario
     * @param {string} idUser Id del usuario que realiza la operación
     * @returns {ResponseUtil} Resultado de la operación en formato JSON
     */
    async deleteUsers(id, currentIdUser){
        if(id === currentIdUser){
            return ResponseUtil.fail('El usuario no se puede eliminar a si mismo, elija otro.')
        }
        await pool.query('SELECT * FROM eliminar_usuario($1)', [id])
        return ResponseUtil.success('Usuario eliminado con éxito.')

    }
    
    async getRoles() {
        const result = await pool.query('SELECT * FROM obtener_roles()')
        return ResponseUtil.success('Roles obtenidos con éxito.', result.rows)
    }
    
    async changeUserState(userId, currentIdUser, newState) {        
        if(userId === currentIdUser){
            return ResponseUtil.fail('Operación inválida.')
        }
        await pool.query('SELECT * FROM cambiar_estado_usuario($1, $2)', [userId, newState])
        return ResponseUtil.success('Estado de usuario actualizado con éxito.')
    }
    
    async getClients() {
        const result = await pool.query('SELECT * FROM listar_empresas()')
        const usersList = result.rows
        return ResponseUtil.success('La operación se realizó con éxito.', usersList)
    }
    
    async changeCompanyPassword(companyId, newPassword) {
        const hashPassword = await bcrypt.hash( newPassword ,  10 )
        await pool.query('SELECT * FROM cambiar_contrasena_empresa($1, $2)', [companyId, hashPassword])
        return ResponseUtil.success('Se ha actualizado la contraseña de la empresa correctamente.')
    }

    async updateCompanyInfo(companyId, companyName, fullname) {
        await pool.query('SELECT * FROM actualizar_empresa($1, $2, $3, $4, $5, $6, $7)', [companyId, companyName, fullname, null, null, null, null])
        return ResponseUtil.success('La información se actualizó con éxito.')
    }

    async changeCompanyState(companyId, newState) {
        await pool.query('SELECT * FROM cambiar_estado_empresa($1, $2)', [companyId, newState])
        const resultPhrase = newState ? 'activado' : 'desactivado' 
        return ResponseUtil.success(`Se ha ${resultPhrase} la empresa con éxito.`)
    }

    async deleteCompany(companyId) {
        await pool.query('SELECT * FROM eliminar_empresa($1)', [companyId])
        return ResponseUtil.success('Se ha eliminado la empresa con éxito.')
    }

    async getLogs() {
        const result = await pool.query('SELECT * FROM obtener_historial_actividad()')
        const logs = result.rows
        return ResponseUtil.success('Historial obtenido con éxito.', logs)
    }

    async getCompanyLogs(companyId) {
        const result = await pool.query('SELECT * FROM obtener_historial_auditoria_empresa($1)', [companyId])
        const companyLogs = result.rows
        return ResponseUtil.success('Historial de empresa obtenido con éxito.', companyLogs)
    }

    async deleteLogs(date) {
        const result = await pool.query('SELECT * FROM eliminar_logs_actividad_antiguos($1)', [date])
        const deletedRecords = result.rows[0].eliminar_logs_actividad_antiguos
        return ResponseUtil.success(`Se han eliminado ${deletedRecords} registros desde la fecha ${date} con éxito.`)
    }

    async getAdminUsers() {
        const result = await pool.query('SELECT * FROM listar_usuarios_superusuario_asesor()')
        const adminUsers = result.rows
        return ResponseUtil.success('Usuarios listados con éxito.', adminUsers)
    }

    async createSuperuser(username, fullname, password) {
        const userExist = await this.#verifyUser(username)
        if (userExist) {
           return ResponseUtil.fail('El nombre de usuario ya existe, por favor elije otro.')
        }
        const hashPassword =  await bcrypt.hash( password ,  10 )
        await pool.query(   
            'SELECT * FROM crear_usuario_superusuario($1, $2, $3)',
            [username, fullname, hashPassword]
        )
        return ResponseUtil.success('EL usuario se creó con éxito.')
    }

    async createSupportUser(username, fullname, password) {
        const userExist = await this.#verifyUser(username)
        if (userExist) {
           return ResponseUtil.fail('El nombre de usuario ya existe, por favor elije otro.')
        }
        const hashPassword =  await bcrypt.hash( password ,  10 )
        await pool.query(   
            'SELECT * FROM crear_usuario_asesor($1, $2, $3)',
            [username, fullname, hashPassword]
        )
        return ResponseUtil.success('EL usuario se creó con éxito.')
    }

    /**
     * @private
     * Verifica la existencia del nombre de usuario en la base de datos
     * @param {*} username Nombre de usuario
     * @returns {boolean} Valor booleano indicando si el usuario existe
     */
    async #verifyUser(username) {
        const userExist = await pool.query('SELECT * FROM obtener_usuario($1)', [username])
        return userExist.rows.length > 0
    }

    async #verifyTotalOfUsers(companyId) {
        const result = await pool.query('SELECT * FROM empresa_puede_registrar_usuario($1)', [companyId])
        return result.rows[0].empresa_puede_registrar_usuario;
    }
}    

module.exports = AdminHelper