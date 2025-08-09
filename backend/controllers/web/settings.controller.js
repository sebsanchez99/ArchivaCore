const ResponseUtil = require('../../utils/response.util')
const AdminHelper = require('../../helpers/admin.helper')

const changeUserPassword = async (req, res) => {
    try {
        const { userId } = req.user
        const { newPassword } = req.body 
        const adminHelper = new AdminHelper()
        const result = await adminHelper.userUpdate(userId, null, null, newPassword, null, null)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const updateUserInfo = async (req, res) => {
    try {
        const { userId } = req.user
        const { username, fullname } = req.body 
        const adminHelper = new AdminHelper()
        const result = await adminHelper.userUpdate(userId, username, fullname, null, null, null)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const changeCompanyPassword = async (req, res) => {
    try {
        const { companyId } = req.user
        const { newPassword } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.changeCompanyPassword(companyId, newPassword)
        res.json(result)       
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const updateCompanyInfo = async (req, res) => {
    try {
        const { companyId } = req.user
        const { companyName, fullname } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.updateCompanyInfo(companyId, companyName, fullname)
        res.json(result)
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