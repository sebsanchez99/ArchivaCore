const { Router } = require('express')
const { listUsers } = require('../controllers/admin.controller.js')



const router = Router()

// http://localhost:3000/api/v1/admin/listUsers
router.get('/listUsers', listUsers)

module.exports = router