const LocalStrategy = require("passport-local").Strategy;
const bcrypt = require("bcrypt");
const pool = require("../../../libs/postgres");

/**
 * Función reutilizable para validar entidades (usuarios/empresas)
 */
async function authenticateEntity({ query, identifier, password, fieldHash }, done) {
  try {
    const result = await pool.query(query, [identifier]);
    if (result.rows.length === 0) {
      return done(null, false, { message: "No encontrado" });
    }

    const entity = result.rows[0];
    const isMatch = await bcrypt.compare(password, entity[fieldHash]);
    if (!isMatch) {
      return done(null, false, { message: "Contraseña incorrecta" });
    }

    return done(null, entity);
  } catch (error) {
    return done(error);
  }
}

const localStrategy = new LocalStrategy(async (username, password, done) => {
  await authenticateEntity({
    query: "SELECT * FROM obtener_usuario($1)",
    identifier: username,
    password,
    fieldHash: "_usu_hash"
  }, done);
});

const localCompanyStrategy = new LocalStrategy(
  {
    usernameField: 'companyEmail',
    passwordField: 'password'
  },
  async (companyEmail, password, done) => {
    await authenticateEntity({
      query: "SELECT * FROM obtener_empresa_por_correo($1)",
      identifier: companyEmail,
      password,
      fieldHash: "_emp_hash"
    }, done);
  });

module.exports = {
  localStrategy,
  localCompanyStrategy
};
