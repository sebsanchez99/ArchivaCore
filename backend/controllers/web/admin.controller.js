const AdminHelper = require('../../helpers/admin.helper.js')
const SupaBaseHelper = require('../../helpers/supabase.helper.js')
const ResponseUtil = require('../../utils/response.util.js')

const getClients = async (req, res) => {
    try {
        const adminHelper = new AdminHelper()
        const result = await adminHelper.getClients()
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

const deleteClient = async (req, res) => {
    try {
        const { companyId, companyName } = req.body
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

const updateState = async (req, res) => {
    try {
        const { companyId, newState } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.changeCompanyState(companyId, newState)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const getCompanyLogs = async (req, res) => {
    try {
        const { companyId } = req.query
        const adminHelper = new AdminHelper()
        const result = await adminHelper.getCompanyLogs(companyId)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const getLogs = async (req, res) => {
    try {
        const adminHelper = new AdminHelper()
        const result = await adminHelper.getLogs()
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const deleteLogs = async (req, res) => {
    try {
        const { date } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.deleteLogs(date)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const getAdminUsers = async (req, res) => {
    try {
        const adminHelper = new AdminHelper()
        const result = await adminHelper.getAdminUsers()
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const createSuperuser = async (req, res) => {
    try {
        const { username, fullname, password } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.createSuperuser(username, fullname, password)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const createSupportUser = async (req, res) => {
    try {
        const { username, fullname, password } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.createSupportUser(username, fullname, password)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const updateAdminUser = async (req, res) => {
    try {
        const { userId, username, fullname, password } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.userUpdate(userId, username, fullname, password)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))

    }
}

const changeStateAdminUser = async (req, res) => {
    try {
        const currentUserId = req.user.userId
        const { userId, newState } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.changeUserState(userId, currentUserId, newState)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const deleteAdminUser = async (req, res) => {
    try {
        const currentUserId = req.user.userId
        const { userId } = req.body
        const adminHelper = new AdminHelper()
        const result = await adminHelper.deleteUsers(userId, currentUserId)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}


module.exports = {
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
    deleteAdminUser
}