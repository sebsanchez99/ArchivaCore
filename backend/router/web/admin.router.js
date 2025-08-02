const { Router } = require('express')
const {
    getClients,
    changeCompanyPassword,
    deleteClient,
    updateState,
    getCompanyLogs,
    getLogs,
    deleteLogs,
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

module.exports = adminWebRouter