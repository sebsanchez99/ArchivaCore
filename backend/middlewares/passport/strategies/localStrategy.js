const LocalStrategy = require("passport-local").Strategy;
const bcrypt = require("bcrypt");
const pool = require("../../../libs/postgres");

/**
 * Estrategia local de inicio de sesión que autentica usuario con bd*/
const localStrategy = new LocalStrategy(
  {
    usernameField: "username",
    passwordField: "password",
  },
  async (username, password, done) => {
    try {
      const result = await pool.query(
        "SELECT * FROM usuarios WHERE usu_nombre = $1",
        [username]
      );
      if (result.rows.length === 0) {
        return done(null, false, { message: "Usuario no encontrado" });
      }
      const user = result.rows[0];
      const isMatch = await bcrypt.compare(password, usu_Hash);

      if (!isMatch) {
        return done(null, false, { message: "Contraseña incorrecta" });
      }
    } catch (error) {
        return done(err)
    }
  }
)

module.exports= localStrategy