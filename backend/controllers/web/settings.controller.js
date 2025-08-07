const ResponseUtil = require('../../utils/response.util')
const AdminHelper = require('../../helpers/admin.helper')

const changeUserPassword = async (req, res) => {
    try {
        const { password } = req.body 
        const adminHelper = new AdminHelper()
        const result = await adminHelper.userUpdate(null, null, null, password)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const changeCompanyPassword = async (req, res) => {
    try {
        const { companyId, newPassword } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.changeCompanyPassword(companyId, newPassword)
        res.json(result)       
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const updateCompanyInfo = async (req, res) => {
    try {
        
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    changeCompanyPassword,
    updateCompanyInfo,
    changeUserPassword,
    updateUserInfo
}