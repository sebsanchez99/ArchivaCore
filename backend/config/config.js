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

// Configura las variables de SupaBase
const configSupaBase = {
    supaBaseUrl: process.env.SUPABASE_URL,
    supaBaseKey: process.env.SUPABASE_API_KEY,
}

//Configurar servicio de Gemini
const configGPT = {
    gptApiKey: process.env.GPT_API_KEY
}


module.exports = {
    configServer,
    configDB,
    configToken,
    configSupaBase,
    configGPT
}

