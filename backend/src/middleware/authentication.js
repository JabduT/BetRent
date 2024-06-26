const jwt = require("jsonwebtoken");
const { promisify } = require("util");
const bcrypt = require("bcrypt");
const { User } = require("../models/user");

signToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET_KEY, {
    expiresIn: "1h",
  });
};

exports.createSendToken = (user, statusCode, res) => {
  const token = signToken(user._id);
  const cookieOptions = {
    expires: new Date(
      Date.now() +
        parseInt(process.env.JWT_COOKIE_EXPIRES_IN, 10) * 24 * 60 * 60 * 1000
    ),
    httpOnly: true,
  };
  if (process.env.NODE_ENV === "production") {
    cookieOptions.secure = true;
  }
  // res.cookie('jwt', token, cookieOptions);
  res.status(statusCode).json({
    status: "success",
    token,
    user,
  });
};

// protect controller for authorization
exports.authenticate = async (req, res, next) => {
  try {
    let token;
    console.log("upper", token);
    if (
      req.headers.authorization &&
      req.headers.authorization.startsWith("Bearer")
    ) {
      token = req.headers.authorization.split(" ")[1];
      console.log(token);
    } else if (req.cookies.jwt) {
      token = req.cookies.jwt;
    }
    if (!token) {
      return res.status(401).json({
        message: "You are not logged in! Please log in to get access.",
      });
    }
    const decoded = await promisify(jwt.verify)(
      token,
      process.env.JWT_SECRET_KEY
    );
    const currentUser = await User.findById(decoded.id);
    if (!currentUser) {
      return res.status(403).json({
        message: "access denied",
      });
    }
    req.user = currentUser;
    next();
  } catch (error) {
    return res.status(500).json({
      message: "server error",
    });
  }
};
