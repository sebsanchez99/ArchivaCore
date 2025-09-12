const  { createClient } = require('@supabase/supabase-js') 
const { configSupaBase } = require('../config/config.js')

const poolNewClient = createClient(configSupaBase.supaBaseUrl, configSupaBase.supaBaseKey, {
    auth: { persistSession: false },
})

module.exports = poolNewClient.storage