require('dotenv').config

const jwt = require('jsonwebtoken');

const secretCode = process.env.SECRET_CODE

function verifyToken(req, res, next) {
  try {
    const token = req.cookies.token || req.headers.cookie?.split('=')[1];

    if (!token) {
      return res.status(401).send('Unauthorized');
    }
  
    try {
      const user = jwt.verify(token, secretCode);
      req.user = user;
      next();
    } catch (err) {
      return res.status(401).send('Unauthorized');
    }
  } catch (err) {
    console.log(err)
    res.status(401).json({ message: 'Token is not valid' });
  }
}


module.exports = verifyToken
