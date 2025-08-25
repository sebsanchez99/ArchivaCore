const ResponseUtil = require('../../utils/response.util')
const SupaBaseHelper = require('../../helpers/supabase.helper ')

const getTotalStorage = async (req, res) => {
    try {
        const { companyName } = req.user
        const supabaseHelper = new SupaBaseHelper()
        const result = await supabaseHelper.calculateTotalStorage(companyName)
        res.json(result)
    } catch (error) {
       res.status(500).send(ResponseUtil.fail(error.message))
    }
}

module.exports = {
    getTotalStorage
}