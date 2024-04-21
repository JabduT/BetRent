const mongoose = require("mongoose");
const Joi = require("joi");

const notificationSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "User",
    required: true,
  },
  content: {
    type: String,
    required: true,
  },
  timestamp: {
    type: Date,
    default: Date.now,
  },
  read: {
    type: Boolean,
    default: false,
  },
});

const Notification = mongoose.model("Notification", notificationSchema);

function validateNotification(notification) {
  const schema = Joi.object({
    userId: Joi.string().required(),
    content: Joi.string().required(),
    read: Joi.boolean(),
  });
  return schema.validate(notification);
}

module.exports = {
  Notification,
  validateNotification,
};
