const  { StorageClient } = require('@supabase/storage-js') 
const {configSupaBase} = require('../config/config')

const poolNewClient = new StorageClient(configSupaBase.supaBaseUrl, {
    apikey: configSupaBase.supaBaseKey,
    Authorization: `Bearer ${configSupaBase.supaBaseKey}`,})

module.exports = poolNewClient