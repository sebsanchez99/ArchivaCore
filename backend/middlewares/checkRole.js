/**
 * Middleware que verifica rol de usuario
 * @param {*} req Petición
 * @param {*} res Respuesta
 * @param {*} next Función para pasar al siguiente middlware/controlador
 * @returns Respuesta HTTP en caso de que el usuario no tenga rol de administrador
 */
const checkRole = (req, res, next) => {
    if (req.user.role !== "Administrador") {
        return res.status(403).json({ message: "Acceso no autorizado" })
    }
    next()
}

module.exports = checkRole