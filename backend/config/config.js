// Llama las variables de entorno
require('dotenv').config()

// Configura las variables de servidor
const configServer = {
    port: process.env.PORT
}

// Configura las variables de base de datos
const configDB = {
    dbUser: process.env.DB_USER,
    dbPassword: process.env.DB_PASSWORD,
    dbHost: process.env.DB_HOST,
    dbName: process.env.DB_NAME,
    dbPort: process.env.DB_PORT
}

// Cofigura las variables de token de sesión
const configToken = {
    secretKey: process.env.SECRET_KEY,
    expireToken: process.env.EXPIRE_TOKEN
}

module.exports = {
    configServer,
    configDB,
    configToken
}

