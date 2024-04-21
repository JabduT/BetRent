const { User } = require("../models/user");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

exports.signToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET_KEY , {
    expiresIn: '1h',
  });
};

 exports.createSendToken =  (user, statusCode, res) => {
  const token = signToken(user._id);
  const cookieOptions = {
    expires: new Date(
      Date.now() +
        parseInt(process.env.JWT_COOKIE_EXPIRES_IN, 10) *
          24 *
          60 *
          60 *
          1000
    ),
    httpOnly: true,
  };
  if (process.env.NODE_ENV === 'production') {
    cookieOptions.secure = true;
  }
  res.cookie('jwt', token, cookieOptions);
  res.status(statusCode).json({
    status: 'success',
    token,
      user,
      });
};

// protect controller for authorization
exports.authenticate = async (req, res, next) => {
  let token;
  if (req.headers.authorization && req.headers.authorization.startsWith('Bearer')) {
    token = req.headers.authorization.split(' ')[1];
  } else if (req.cookies.jwt) {
    token = req.cookies.jwt;
  }

  try {
    if (!token) {
      throw new Error('You are not logged in! Please log in to get access.');
    }
    const decoded = await new Promise((resolve, reject) => {
      jwt.verify(token, process.env.JWT_SECRET_KEY, (err, decode) => {
        if (err) reject(err);
        else resolve(decoded);
      });
    });

    const currentUser = await User.findById(decoded.id);
    if (!currentUser) {
      throw new Error('No user belongs to this token');
    }

    req.user = currentUser;
    next();
  } catch (error) {
    return res.status(401).json({ error: error.message });
  }
};

