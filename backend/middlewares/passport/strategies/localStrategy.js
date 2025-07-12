const LocalStrategy = require('passport-local').Strategy
const bcrypt = require('bcrypt')
const pool = require('../../../libs/postgres')

/**
 * Obtiene una entidad (usuario o empresa) desde la base de datos.
 */
async function getEntity(query, identifier) {
  const result = await pool.query(query, [identifier])
  return result.rows[0] || null
}

/**
 * Compara la contraseña con el hash almacenado.
 */
async function isPasswordValid(password, hash) {
  return await bcrypt.compare(password, hash)
}

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

/**
 * Autenticación para empresa o usuario soporte/superadmin.
 */
async function authenticateCompanyOrSpecialUser({ identifier, password }, done) {
  try {
    // 1. Buscar empresa
    let entity = await getEntity('SELECT * FROM obtener_empresa_por_correo($1)', identifier)
    if (entity) {
      const valid = await isPasswordValid(password, entity['_emp_hash'])
      if (!valid) return done(null, false, { message: 'Contraseña incorrecta' })
      entity.rol = 'Empresa'
      return done(null, entity)
    }

    // 2. Buscar usuario soporte o superadmin
    entity = await getEntity('SELECT * FROM obtener_usuario($1)', identifier)
    
    if (entity && ['Soporte', 'Superusuario'].includes(entity._rol_nombre)) {
      const valid = await isPasswordValid(password, entity['_usu_hash'])
      if (!valid) return done(null, false, { message: 'Contraseña incorrecta' })
      return done(null, entity)
    }

    // No encontrado
    return done(null, false, { message: 'No encontrado' })
  } catch (error) {
    return done(error)
  }
}

const localCompanyStrategy = new LocalStrategy(
  {
    usernameField: 'companyEmail',
    passwordField: 'password'
  },
  async (companyEmail, password, done) => {
    await authenticateCompanyOrSpecialUser({
      identifier: companyEmail,
      password
    }, done)
  }
)

const localStrategy = new LocalStrategy(async (username, password, done) => {
  await authenticateEntity({
    query: 'SELECT * FROM obtener_usuario($1)',
    identifier: username,
    password,
    fieldHash: '_usu_hash'
  }, done)
})

module.exports = {
  localStrategy,
  localCompanyStrategy
}