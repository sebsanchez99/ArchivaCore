const { Router } = require('express')
const {
    getClients,
    changeCompanyPassword,
    deleteClient,
    updateState,
    getCompanyLogs,
    getLogs,
    deleteLogs,
    getAdminUsers,
    createSuperuser,
    createSupportUser,
    updateAdminUser,
    changeStateAdminUser,
    deleteAdminUser,
} = require('../../controllers/web/admin.controller.js')

const router = Router()

const adminWebRouter = router

// http://localhost:3000/api/v1/web/admin/getClients
adminWebRouter.get('/getClients', getClients)

// http://localhost:3000/api/v1/web/admin/changeCompanyPassword
adminWebRouter.put('/changeCompanyPassword', changeCompanyPassword)

// http://localhost:3000/api/v1/web/admin/deleteClient
adminWebRouter.delete('/deleteClient', deleteClient)

// http://localhost:3000/api/v1/web/admin/updateState
adminWebRouter.put('/updateState', updateState)

// http://localhost:3000/api/v1/web/admin/getCompanyLogs
adminWebRouter.get('/getCompanyLogs', getCompanyLogs)

// http://localhost:3000/api/v1/web/admin/getLogs
adminWebRouter.get('/getLogs', getLogs)

// http://localhost:3000/api/v1/web/admin/deleteLogs
adminWebRouter.delete('/deleteLogs', deleteLogs)

// http://localhost:3000/api/v1/web/admin/getAdminUsers
adminWebRouter.get('/getAdminUsers', getAdminUsers)

// http://localhost:3000/api/v1/web/admin/createSuperuser
adminWebRouter.post('/createSuperuser', createSuperuser)

// http://localhost:3000/api/v1/web/admin/createSupportUser
adminWebRouter.post('/createSupportUser', createSupportUser)

// http://localhost:3000/api/v1/web/admin/updateAdminUser
adminWebRouter.put('/updateAdminUser', updateAdminUser)

// http://localhost:3000/api/v1/web/admin/changeStateAdminUser
adminWebRouter.put('/changeStateAdminUser', changeStateAdminUser)

// http://localhost:3000/api/v1/web/admin/deleteAdminUser
adminWebRouter.delete('/deleteAdminUser', deleteAdminUser)

module.exports = adminWebRouter