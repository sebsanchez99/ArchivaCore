/**
 * Middleware que verifica el rol del usuario
 * @param {...string} allowedRoles Roles permitidos para acceder a la ruta
 * @returns Middleware que verifica si el usuario tiene uno de los roles permitidos
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