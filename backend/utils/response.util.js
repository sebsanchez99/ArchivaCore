/**
 * @namespace Utilidades
 * @description Grupo de utilidades para la aplicación.
 */

/**
 * @class Clase para construir respuestas estandarizadas en formato Json
 * @memberof Utilidades
 * @description ResponseUtil es una clase que proporciona métodos para construir respuestas JSON estandarizadas para operaciones exitosas y fallidas.
 */
class ResponseUtil {

    /**
     * Construye un Json con la respuesta exitosa 
     * @param {string} message Mensaje que se envía dentro de la respuesta
     * @param {Object} data Datos que se envían dentro de la respuesta
     * @returns {Object} Resultado Json con resultado exitoso
     */
    static success(message, data = null){
        return {result: true, message, data}
    } 

    /**
     * Construye un Json con la respuesta fallida
     * @param {string} message Mensaje que se envía dentro de la respuesta
     * @param {Object} data Datos que se envían dentro de la respuesta
     * @returns {Object} Resultado Json con resultado fallido
     */
    static fail(message, data = null){
        return {result: false, message, data}
    }
}

module.exports = ResponseUtil