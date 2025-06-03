const { Router } = require('express')
const passport = require('passport')
const { getTotalStorage } = require('../../controllers/web/supabase.controller')

const router = Router()

// http://localhost:3000/api/v1/web/supabase/getTotalStore
router.get('/getTotalStorage', getTotalStorage)

module.exports = router