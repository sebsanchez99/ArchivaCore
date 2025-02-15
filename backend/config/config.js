// Llama las variables de entorno
require('dotenv').config()

const configServer = {
    port: process.env.PORT
}

const configDB = {
    dbUser: process.env.DB_USER,
    dbPassword: process.env.DB_PASSWORD,
    dbHost: process.env.DB_HOST,
    dbName: process.env.DB_NAME,
    dbPort: process.env.DB_PORT
}

const configToken = {
    secretKey: process.env.SECRET_KEY,
    expireToken: process.env.EXPIRE_TOKEN
}

module.exports = {
    configServer,
    configDB,
    configToken
}

