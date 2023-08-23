require('dotenv').config

const jwt = require('jsonwebtoken')
const secretCode = process.env.SECRET_CODE

const userAuthentication = async (req, res, next) => {

    try {
        const token = req.header('x-auth-token')
        if(!token) return res.status(403).json({msg: 'No auth token, access denied'})

        const verified = jwt.verify(token, secretCode)
        if(!verified) return res.status(403).json({msg: 'Invalid auth token'})

        req.user = verified.id
        req.token = token
 
        next()
    } catch (error) {

        res.status(500).json({msg: error.message})
    }
}

module.exports = userAuthentication