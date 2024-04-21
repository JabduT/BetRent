const mongoose = require("mongoose");
const Joi = require("joi");

const userSchema = new mongoose.Schema(
  {
    //   username: {
    //     type: String,
    //     required: true,
    //     minlength: 3,
    //     maxlength: 50
    //   },

    phoneNumber: {
      type: String,
      required: true,
      minlength: 10,
      maxlength: 15,
      unique: true,
      validate: {
        validator: function (v) {
          return /^\+[1-9]\d{1,14}$/.test(v);
        },
        message: (props) =>
          `${props.value} is not a valid phone number with prefix!`,
      },
    },
    PIN: {
      type: Number,
      required: true,
      min: 1000,
      max: 999999,
    },

    role: {
      type: String,
      enum: ["renter", "landlord"],
      default: "renter",
    },
  },
  { timestamps: true }
);

const User = mongoose.model("User", userSchema);

function validateUser(user) {
  const schema = Joi.object({
    // username: Joi.string().min(3).max(50).required(),
    email: Joi.string().min(5).max(255).email(),
    PIN: Joi.number().integer().required().min(1000).max(999999),
    role: Joi.string().valid("renter", "landlord").default("renter"),
    phoneNumber: Joi.string()
      .min(10)
      .max(15)
      .required()
      .regex(/^\+[1-9]\d{1,14}$/),
  });
  return schema.validate(user);
}

module.exports = {
  User,
  validateUser,
};
