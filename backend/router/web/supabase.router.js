const { Router } = require('express')
const { getTotalStorage, createCompanyBucket } = require('../../controllers/web/supabase.controller')

const router = Router()

// http://localhost:3000/api/v1/web/supabase/getTotalStorage
router.get('/getTotalStorage', getTotalStorage)

// http://localhost:3000/api/v1/web/supabase/createCompanyBucket
router.post('/createCompanyBucket', createCompanyBucket)

module.exports = router