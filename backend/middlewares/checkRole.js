/**
 * Middleware que verifica rol de usuario
 * @callback
 * @param {Object} req Petición
 * @param {Object} res Respuesta
 * @param {Function} next Función para pasar al siguiente middlware/controlador
 * @returns {Response} Respuesta HTTP en caso de que el usuario no tenga rol de administrador
 */
const checkRole = (req, res, next) => {
    if (req.user.role !== "Administrador") {
        return res.status(403).json({ message: "Acceso no autorizado" })
    }
    next()
}

module.exports = checkRole