/**
 * @namespace Middlewares
 * @description Grupo de middlewares de la API.
 */

/**
 * @callback
 * @memberof Middlewares
 * @description Verifica si el usuario tiene el rol de administrador.
 * @param {Object} req Petición
 * @param {Object} res Respuesta
 * @param {Function} next Función para pasar al siguiente middlware/controlador
 * @returns {Response} Respuesta HTTP en caso de que el usuario no tenga rol de administrador
 */
const checkRole = (...allowedRoles) => {
    return (req, res, next) => {
      // Verificar si el rol del usuario está en la lista de roles permitidos
      if (!allowedRoles.includes(req.user.role)) {
        return res.status(403).json({ message: "Acceso no autorizado" });
      }
      next();
    };
  };
  
  module.exports = checkRole;