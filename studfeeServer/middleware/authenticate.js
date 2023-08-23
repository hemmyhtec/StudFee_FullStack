const passport = require('passport')

module.exports = (req, res, next)=> {
    passport.authenticate('jwt', function(err, user, info){
        if(err) return next(err)

        if(!user) return res.status(401).json({msg: 'Unauthorized Access - No token provided'})

        req.user = user.id
        req.token = token

        next()

    })(req, res, next)
}