const ResponseUtil = require('../../utils/response.util')
const AdminHelper = require('../../helpers/admin.helper')
const SupaBaseHelper = require('../../helpers/supaBase.helper')

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

const deleteCompanyAccount = async (req, res) => {
    try {
        const { companyId, companyName } = req.user
        const adminHelper = new AdminHelper()
        const supabaseHelper = new SupaBaseHelper()
        const result = await adminHelper.deleteCompany(companyId);
        const emptyBucketResult = await supabaseHelper.deleteAllFiles(companyName);
        if (!emptyBucketResult.result) {
            return res.json(ResponseUtil.fail('Error al eliminar los archivos del bucket.'));
        }
        await new Promise(resolve => setTimeout(resolve, 2000));
        const deleteBucketResult = await supabaseHelper.deleteCompany(companyName);
        if (!deleteBucketResult.result || !result.result) {
            return res.json(ResponseUtil.fail('Error al eliminar la cuenta.'));
        }
        return res.json(result);
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    changeCompanyPassword,
    changeUserPassword,
    updateUserInfo,
    deleteCompanyAccount
}