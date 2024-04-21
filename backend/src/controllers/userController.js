// controllers/userController.js

const { User, validateUser } = require("../models/User");
const Joi = require("joi");

// controllers/authController.js

const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");


export const signToken = (id) => {
  return jwt.sign({ id }, process.env.JWT_SECRET_KEY , {
    expiresIn: '1h',
  });
};

export const createSendToken =  (user, statusCode, res) => {
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
    data: {
      user,
    },
  });
};

// create new user controller
export const createUser = async (req, res) => {
  // Validate user input
  const { error } = validateUser(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  try {
    const user = new User(req.body);
    await user.save();
    createSendToken(user,201,res);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// login
export const loginUser = async (req, res) => {
  try {
    const { phoneNumber, PIN } = req.body;

    const user = await User.findOne({ PIN });
    if (!user) {
      return res.status(400).json({ message: 'Invalid phoneNumber or PIN' });
    }
    createSendToken(user, 200, res);
  } catch (error) {
    console.error('Error logging in:', error);
    res.status(500).json({ message: 'Server error' });
  }
};
// protect controller for authorization
export const protect = async (req, res, next) => {
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
// Get all users
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.status(200).json(users);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create a new user
exports.createUser = async (req, res) => {

};

// Get user by ID
exports.getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update user by ID
exports.updateUser = async (req, res) => {
  // Validate user input
  const { error } = validateUser(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  try {
    const user = await User.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete user by ID
exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
