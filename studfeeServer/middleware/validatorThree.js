const { validationResult } = require('express-validator')


module.exports = (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.render('admin/create-form', { errors: errors.array() });
      }
    next()
}