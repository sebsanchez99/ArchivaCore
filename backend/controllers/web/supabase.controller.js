const ResponseUtil = require('../../utils/response.util')
const SupabaseHelper = require('../../helpers/supabase.helper')

const getTotalStorage = async (req, res) => {
    try {
        const { companyName } = req.body
        const supabaseHelper = new SupabaseHelper()
        const result = await supabaseHelper.calculateTotalStorage(companyName)
        res.json(result)
    } catch (error) {
       res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    getTotalStorage
}