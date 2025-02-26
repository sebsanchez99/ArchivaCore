const checkRole = (req, res, next) => {
    console.log(req.user)
    
    if(req.user._rol_nombre != "Administrador"){
        return res.status(401)
    }
    next()
}

module.exports = checkRole