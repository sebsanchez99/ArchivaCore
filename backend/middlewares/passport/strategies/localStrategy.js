const LocalStrategy = require("passport-local").Strategy;
const bcrypt = require("bcrypt");
const pool = require("../../../libs/postgres");

/**
 * Estrategia local de inicio de sesión que autentica usuario con bd*/
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

const localCompanyStrategy = new LocalStrategy(
  async (companyName, password, done) => {
    const result = await pool.query(
      'SELECT * FROM obtener_empresa($1)',
      [companyName]
    )
    const company = result.rows[0]
    const isMatch = await bcrypt.compare(password, company._company_)
  }
)

module.exports= localStrategy