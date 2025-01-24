const { Pool } = require('pg')
const { configDB } = require('../config/config')

const connectionString = `postgresql://${configDB.dbUser}:${configDB.dbPassword}@${configDB.dbHost}:${configDB.dbPort}/${configDB.dbName}`

//Se configura el pool de conexiones a la BBDD
const pool = new Pool({
    connectionString: connectionString,
    idleTimeoutMillis: 30000,
    connectionTimeoutMillis: 30000
})

module.exports = pool