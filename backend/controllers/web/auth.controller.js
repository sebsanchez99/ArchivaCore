const AuthHelper = require('../../helpers/auth.helper')
const SupaBaseHelper = require('../../helpers/supaBase.helper')
const ResponseUtil = require('../../utils/response.util')

const login = async (req, res) => {
    try {
        const { _emp_id, _emp_nombre, _emp_activo, _plan_nombre, _plan_duracion  } = req.user
        const authHelper = new AuthHelper()
        if (!_emp_activo) {
            return res.json(ResponseUtil.fail('Su cuenta se encuentra inactiva. Contacte con soporte.'))
        }
        const payload = {
            companyId: _emp_id,
            companyName: _emp_nombre,
            active: _emp_activo,
            planName: _plan_nombre,
            planDuration: _plan_duracion
        }
        const token = authHelper.generateToken(payload)
        res.json(ResponseUtil.success('Usuario autenticado con éxito', token))
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}


const register =  async (req, res) => {
    try {
        const { companyName, fullname, companyEmail, password } = req.body
        const authHelper = new AuthHelper()
        const supabaseHelper = new SupaBaseHelper()
        const result = await authHelper.registerCompany(companyName, fullname, companyEmail, password)
        if (!result.result) {
            return res.json(result)
        }      
        const bucketResult = await supabaseHelper.createCompanyBucket(companyName)
        if (!bucketResult) {
            return res.status(400).send(ResponseUtil.fail('No se pudo registrar la empresa'))
        }           
        res.json(result)
    } catch (error) {
        res.status(500).send(ResponseUtil.fail(error.message))
    }
}


module.exports = {
    register,
    login
}