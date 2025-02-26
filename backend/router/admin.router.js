const { Router } = require('express')
const { listUsers, createUsers, userUpdate, deleteUser } = require('../controllers/admin.controller.js')

const router = Router()

// http://localhost:3000/api/v1/admin/listUsers
router.get('/listUsers', listUsers)
// http://localhost:3000/api/v1/admin/createUser
router.post('/createUser', createUsers)
// http://localhost:3000/api/v1/admin/updateUser
router.put('/updateUser', userUpdate)
// http://localhost:3000/api/v1/admin/deleteUser
router.delete('/deleteUser', deleteUser)

module.exports = router