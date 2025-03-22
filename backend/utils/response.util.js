
class ResponseUtil {

    /**
     * Construye un Json con Respuesta exitosa 
     * @param {*} message mensaje que se envía dentro de la respuesta
     * @param {*} data datos que se envían dentro de la respuesta
     * @returns Resultado Json con resultado exitoso
     */
    static success(message, data = null){
        return {result: true, message, data}
    } 

    /**
     * Construye un Json con Respuesta fallido
     * @param {*} message mensaje que se envía dentro de la respuesta
     * @param {*} data datos que se envían dentro de la respuesta
     * @returns Resultado Json con resultado fallido
     */
    static fail(message, data = null){
        return {result: false, message, data}
    }
}

module.exports = ResponseUtil