const mongoose = require("mongoose");
const Joi = require("joi");
const bcrypt = require("bcrypt");

const userSchema = new mongoose.Schema(
  {
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
      type: String,
      required: true,
    },
    role: {
      type: String,
      enum: ["renter", "landlord"],
      default: "renter",
    },
    verified: { type: Boolean, default: false },
    
  },
  { timestamps: true }
);

// Hash the PIN before saving the user
userSchema.pre("save", async function (next) {
  // Only hash the PIN if it's modified or is new
  if (!this.isModified("PIN")) return next();

  try {
    const salt = await bcrypt.genSalt(10);
    this.PIN = await bcrypt.hash(this.PIN, salt);
    next();
  } catch (error) {
    next(error);
  }
});
// Define instance method to compare PIN
userSchema.methods.checkPIN = async function (candidatePIN, userPIN) {
  return await bcrypt.compare(candidatePIN, userPIN);
};
const User = mongoose.model("User", userSchema);

function validateUser(user) {
  const schema = Joi.object({
    email: Joi.string().min(5).max(255).email(),
    PIN: Joi.string().min(4).max(6).required(),
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
