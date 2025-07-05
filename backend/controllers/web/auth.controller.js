const AuthHelper = require('../../helpers/auth.helper')
const SupaBaseHelper = require('../../helpers/supaBase.helper')
const ResponseUtil = require('../../utils/response.util')

const login = async (req, res) => {
    try {
        const authHelper = new AuthHelper()
        const user = req.user

        if (user._emp_id) {
            if (!user._emp_activo) {
                return res.json(ResponseUtil.fail('Su cuenta se encuentra inactiva. Contacte con soporte.'))
            }
            const planStartDate = new Date(user._emp_fechainicioplan)
            const payload = {
                companyId: user._emp_id,
                companyName: user._emp_nombre,
                active: user._emp_activo,
                planName: user._plan_nombre,
                planDuration: user._plan_duracion,
                rol: "Empresa"
            }
            const token = authHelper.generateToken(payload)
            return res.json(ResponseUtil.success('Usuario autenticado con éxito', {
                token,
                companyId: user._emp_id,
                companyName: user._emp_nombre,
                active: user._emp_activo,
                planName: user._plan_nombre,
                planDuration: user._plan_duracion,
                planStartDate: planStartDate,
                rol: "Empresa"
            }))
        }

        if (user._usu_id && user._rol_nombre) {
            const payload = {
                userId: user._usu_id,
                fullname: user._usu_nombre,
                email: user._usu_correo,
                rol: user._rol_nombre
            }
            const token = authHelper.generateToken(payload)
            return res.json(ResponseUtil.success('Usuario autenticado con éxito', {
                userId: user._usu_id,
                token,
                fullname: user._usu_nombre,
                rol: user._rol_nombre
            }))
        }

        // Si no es ninguno de los anteriores
        return res.status(401).json(ResponseUtil.fail('No tiene permisos para acceder'))
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