const mongoose = require("mongoose");
const Joi = require("joi");
const bcrypt = require("bcrypt");

const favoriteSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    propertyId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Property",
      required: true,
    },
  },
  { timestamps: true }
);

const Favorite = mongoose.model("Favorite", favoriteSchema);

module.exports = {
  Favorite,
};
