const { User, validateUser } = require("../models/user");
const Joi = require("joi");
const bcrypt = require("bcrypt");

const authentication=require("../middleware/authentication");
// create new user controller
exports.createUser = async (req, res) => {
  // Validate user input
  const { error } = validateUser(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

// login
exports.Login = async (req, res) => {
  try {
  const { phoneNumber, PIN } = req.body;
const user=await User.findOne({phoneNumber})
  const isMatch=await user.checkPIN(PIN, user.PIN)
  console.log(isMatch);
    if (!isMatch) {
      return res.status(400).json({ message: 'In correct PIN' });
    }
    if (!user) {
      return res.status(400).json({ message: "Invalid phone number or PIN" });
    }
    // Authentication logic (createSendToken function) goes here
    authentication.createSendToken(user,200,res);
    
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
// Create a new user
exports.createUser = async (req, res) => {
  // Validate user input
  const { error } = validateUser(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  try {
    const user = new User(req.body);
    await user.save();

    res.status(201).json(user);
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

// Delete user by ID
exports.deleteUser = async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    res.json({ message: 'User deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
