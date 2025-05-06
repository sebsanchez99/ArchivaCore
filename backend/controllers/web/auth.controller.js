const AuthHelper = require('../../helpers/auth.helper')
const ResponseUtil = require('../../utils/response.util')

const register =  async (req, res) => {
    try {
        const { companyName, companyEmail, password } = req.body
        const authHelper = new AuthHelper()
        const result = await authHelper.registerCompany(companyName, companyEmail, password)
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}

const login = async (req, res) => {
    try {
        const{} = req.body
    
    } catch (error) {
        
    }
}

module.exports = {
    register
}