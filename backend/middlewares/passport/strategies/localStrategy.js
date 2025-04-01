const LocalStrategy = require("passport-local").Strategy;
const bcrypt = require("bcrypt");
const pool = require("../../../libs/postgres");

/**  
 * @callback
 * @memberof Middlewares
 * @description Estrategia local de inicio de sesión que autentica usuario con bd
 * @param {string} username Nombre de usuario
 * @param {string} password Contraseña del usuario
 * @param {Function} done Callback para manejar el resultado de la autenticación
 * @returns {LocalStrategy} Configuración de estrategia local
 */
const localStrategy = new LocalStrategy(
  async (username, password, done) => {
    try {
      const result = await pool.query(
        "SELECT * FROM obtener_usuario($1)",
        [username]
      )

      if (result.rows.length === 0) {
        return done(null, false, { message: "Usuario no encontrado" })
      }
      const user = result.rows[0]
      const isMatch = await bcrypt.compare(password, user._usu_hash)

      if (!isMatch) {
        return done(null, false, { message: "Contraseña incorrecta" })
      }
      done(null,user)
    } catch (error) {
        return done(error)
    }
  }
)

module.exports= localStrategy