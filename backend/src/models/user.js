const mongoose = require("mongoose");
const Joi = require("joi");

const userSchema = new mongoose.Schema({
  //   username: {
  //     type: String,
  //     required: true,
  //     minlength: 3,
  //     maxlength: 50
  //   },
  email: {
    type: String,
    required: true,
    minlength: 5,
    maxlength: 255,
    unique: true,
  },
  password: {
    type: String,
    required: true,
    minlength: 8,
    maxlength: 1024,
  },
  role: {
    type: String,
    enum: ["renter", "landlord"],
    default: "renter",
  },
});

const User = mongoose.model("User", userSchema);

function validateUser(user) {
  const schema = Joi.object({
    // username: Joi.string().min(3).max(50).required(),
    email: Joi.string().min(5).max(255).required().email(),
    password: Joi.string().min(8).max(255).required(),
    role: Joi.string().valid("renter", "landlord").default("renter"),
  });
  return schema.validate(user);
}

module.exports = {
  User,
  validateUser,
};
