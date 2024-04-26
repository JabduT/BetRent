const mongoose = require("mongoose");
const Joi = require("joi");

const propertySchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    title: {
      type: String,
      required: true,
      minlength: 5,
      maxlength: 255,
    },
    type: {
      type: String,
      enum: [
        "Apartment",
        "Condo",
        "House",
        "Studio Apartment",
        "Villa",
        "Bedsitter",
        "Block of Flats",
        "Chalet",
        "Duplex",
        "Farm House",
        "Mansion",
        "Penthouse",
        "Room & Parlour",
        "Shared Apartment",
        "Townhouse / Terrace",
      ],
      default: "House",
    },
    description: {
      type: String,
      minlength: 10,
      maxlength: 2000,
    },
    propertySize: { type: Number },
    roomNumber: { type: Number },
    bedRoomNum: { type: Number },
    address: {
      type: String,
      required: true,
      minlength: 10,
      maxlength: 1000,
    },
    files: {
      type: [String],
      required: true,
    },
    priceType: {
      type: String,
      enum: ["Per Day", "Per Month", "Per Year"],
    },
    price: {
      type: Number,
      required: true,
      min: 0,
    },
  },
  { timestamps: true }
);

const Property = mongoose.model("Property", propertySchema);

function validateProperty(property) {
  const schema = Joi.object({
    title: Joi.string().min(5).max(255).required(),
    type: Joi.string()
      .valid(
        "Apartment",
        "Condo",
        "House",
        "Studio Apartment",
        "Villa",
        "Bedsitter",
        "Block of Flats",
        "Chalet",
        "Duplex",
        "Farm House",
        "Mansion",
        "Penthouse",
        "Room & Parlour",
        "Shared Apartment",
        "Townhouse / Terrace"
      )
      .default("House"),
    description: Joi.string().min(5).max(2000).required(),
    roomNumber: Joi.number().integer().min(0),
    bedRoomNum: Joi.number().integer().min(0),
    address: Joi.string().min(5).max(1000),
    userId: Joi.string().required(),
    files: Joi.array().items(Joi.string()),
    price: Joi.number().min(0),
    priceType: Joi.string().valid("Per Day", "Per Month", "Per Year"),
    propertySize: Joi.number().min(0),
  //  imageFiles: Joi.array().items(Joi.string()),
  });
  return schema.validate(property);
}

module.exports = {
  Property,
  validateProperty,
};
