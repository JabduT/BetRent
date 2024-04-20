// models/Property.js

const mongoose = require('mongoose');
const Joi = require('joi');

const propertySchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    minlength: 5,
    maxlength: 255
  },
  description: {
    type: String,
    required: true,
    minlength: 10,
    maxlength: 2000
  },
  address: {
    type: String,
    required: true,
    minlength: 10,
    maxlength: 1000
  },
  files: {
    type: [String],
    required: true
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  // Additional attributes can be added as needed
});

const Property = mongoose.model('Property', propertySchema);

function validateProperty(property) {
  const schema = Joi.object({
    title: Joi.string().min(5).max(255).required(),
    description: Joi.string().min(10).max(2000).required(),
    address: Joi.string().min(10).max(1000).required(),
    files: Joi.array().items(Joi.string()).required(),
    price: Joi.number().min(0).required()
  });
  return schema.validate(property);
}

module.exports = {
  Property,
  validateProperty
};
