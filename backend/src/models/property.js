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
    numOfRooms: { type: Number },
    numOfBathrooms: { type: Number },
    exactLocation: {
      type: String,
      required: true,
      minlength: 10,
      maxlength: 1000,
    },
    imageFiles: {
      type: [String],
      required: true,
    },
    priceType: {
      type: String,
      enum: [
        "Per Day",
        "Per month",
        "per year"]
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
    description: Joi.string().min(10).max(2000).required(),
    numOfRoom: Joi.number().integer().min(0).required(),
    numOfBathroom: Joi.number().integer().min(0).required(),
    address: Joi.string().min(10).max(1000).required(),
    userId: Joi.string().required(),
    files: Joi.array().items(Joi.string()).required(),
    pricePerDay: Joi.number().min(0).required(),
    pricePerMonth: Joi.number().min(0).required(),
    pricePerYear: Joi.number().min(0).required(),
    propertySize: Joi.number().min(0).required(),

  });
  return schema.validate(property);
}

module.exports = {
  Property,
  validateProperty,
};
