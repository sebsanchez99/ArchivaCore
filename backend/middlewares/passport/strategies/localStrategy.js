const { Strategy: LocalStrategy } = require('passport-local');
const bcrypt = require('bcrypt');
const pool = require('../../../libs/postgres.js');

const QUERIES = {
  EMPRESA: 'SELECT * FROM obtener_empresa_por_correo($1)',
  USUARIO: 'SELECT * FROM obtener_usuario($1)',
};

const HASH_FIELDS = {
  EMPRESA: '_emp_hash',
  USUARIO: '_usu_hash',
};

/**
 * Ejecuta un query y devuelve la primera fila o null.
 */
async function fetchEntity(query, identifier) {
  const result = await pool.query(query, [identifier]);
  return result.rows[0] || null;
}

/**
 * Verifica una contraseña contra un hash.
 */
async function verifyPassword(plain, hash) {
  return bcrypt.compare(plain, hash);
}

/**
 * Autentica una entidad usando query dinámico y campo hash.
 */
async function authenticateEntity({ query, identifier, password, hashField }, done) {
  try {
    const entity = await fetchEntity(query, identifier);
    if (!entity) return done(null, false, { message: 'No encontrado' });

    const isValid = await verifyPassword(password, entity[hashField]);
    if (!isValid) return done(null, false, { message: 'Contraseña incorrecta' });

    return done(null, entity);
  } catch (err) {
    return done(err);
  }
}

/**
 * Autenticación de empresas o usuarios especiales (Soporte / Superusuario).
 */
async function authenticateCompanyOrSpecialUser({ identifier, password }, done) {
  try {
    // 1. Buscar empresa
    let entity = await fetchEntity(QUERIES.EMPRESA, identifier);
    if (entity) {
      const isValid = await verifyPassword(password, entity[HASH_FIELDS.EMPRESA]);
      if (!isValid) return done(null, false, { message: 'Contraseña incorrecta' });

      entity.rol = 'Empresa';
      return done(null, entity);
    }

    // 2. Buscar usuario Soporte o Superusuario
    entity = await fetchEntity(QUERIES.USUARIO, identifier);
    if (entity && ['Asesor', 'Superusuario'].includes(entity._rol_nombre)) {
      const isValid = await verifyPassword(password, entity[HASH_FIELDS.USUARIO]);
      if (!isValid) return done(null, false, { message: 'Contraseña incorrecta' });

      return done(null, entity);
    }

    return done(null, false, { message: 'No encontrado' });
  } catch (err) {
    return done(err);
  }
}

// Estrategia para usuarios normales
const localStrategy = new LocalStrategy(async (username, password, done) => {
  await authenticateEntity({
    query: QUERIES.USUARIO,
    identifier: username,
    password,
    hashField: HASH_FIELDS.USUARIO,
  }, done);
});

// Estrategia para empresa o usuario soporte/superadmin
const localCompanyStrategy = new LocalStrategy(
  {
    usernameField: 'companyEmail',
    passwordField: 'password',
  },
  async (companyEmail, password, done) => {
    await authenticateCompanyOrSpecialUser({ identifier: companyEmail, password }, done);
  }
);

module.exports = {
  localStrategy,
  localCompanyStrategy,
};
