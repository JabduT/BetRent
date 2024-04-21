const { User, validateUser } = require("../models/user");
const Joi = require("joi");

// controllers/authController.js

const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

exports.Login = async (req, res) => {
  try {
    const { phoneNumber, PIN } = req.body;
console.log(PIN);
    const user = await User.findOne({ PIN });
    if (!user) {
      return res.status(400).json({ message: "Invalid phone number or PIN" });
    }

    // Compare hashed PIN
    const validPin = await bcrypt.compare(PIN, user.PIN);
    if (!validPin) {
      return res.status(400).json({ message: "Invalid phone number or PIN" });
    }

    // Generate JWT token
    const token = jwt.sign({ userId: user._id }, "your_secret_key", {
      expiresIn: "1h",
    });
    res.json({ token });
  } catch (error) {
    console.error('Error logging in:', error);
    res.status(500).json({ message: 'Server error' });
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


