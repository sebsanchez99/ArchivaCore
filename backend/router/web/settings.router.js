const { Router } = require('express')
const checkRole = require('../../middlewares/checkRole')
const {  
    changeCompanyPassword,
    changeUserPassword,
    updateUserInfo,
    deleteCompanyAccount
} = require('../../controllers/web/settings.controller.js')

const router = Router()

// http://localhost:3000/api/v1/web/settings/changeCompanyPassword
router.put('/changeCompanyPassword', checkRole('Empresa'), changeCompanyPassword)

// http://localhost:3000/api/v1/web/settings/changeUserPassword
router.put('/changeUserPassword', checkRole('Superusuario', 'Asesor'), changeUserPassword)

// http://localhost:3000/api/v1/web/settings/updateUserInfo
router.put('/updateUserInfo', checkRole('Superusuario', 'Asesor'), updateUserInfo)

// http://localhost:3000/api/v1/web/settings/deleteCompanyAccount
router.delete('/deleteCompanyAccount', checkRole('Empresa'), deleteCompanyAccount)

module.exports = router