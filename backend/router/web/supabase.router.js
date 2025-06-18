const { Router } = require('express')
const { getTotalStorage } = require('../../controllers/web/supabase.controller')

const router = Router()

// http://localhost:3000/api/v1/web/supabase/getTotalStorage
router.get('/getTotalStorage', getTotalStorage)

module.exports = router