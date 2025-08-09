const { Router } = require('express')
const checkRole = require('../../middlewares/checkRole')
const {  
    changeCompanyPassword,
    updateCompanyInfo,
    changeUserPassword,
    updateUserInfo
} = require('../../controllers/web/settings.controller')

const router = Router()

// http://localhost:3000/api/v1/web/settings/changeCompanyPassword
router.put('/changeCompanyPassword', checkRole('Empresa'), changeCompanyPassword)

// http://localhost:3000/api/v1/web/settings/updateCompanyInfo
router.put('/updateCompanyInfo', checkRole('Empresa'), updateCompanyInfo)

// http://localhost:3000/api/v1/web/settings/changeUserPassword
router.put('/changeUserPassword', checkRole('SuperUsuario', 'Asesor'), changeUserPassword)

// http://localhost:3000/api/v1/web/settings/updateUserInfo
router.put('/updateUserInfo', checkRole('SuperUsuario', 'Asesor'), updateUserInfo)

module.exports = router