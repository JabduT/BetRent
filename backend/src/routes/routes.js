const express = require("express");
const {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  Login,
  getMe
} = require("../controllers/userController");
const {
  getAllProperties,
  getPropertyById,
  createProperty,
  updateProperty,
  deleteProperty,
} = require("../controllers/propertyController");
const {authenticate} = require("../middleware/authentication");
const router = express.Router();

//LOGIN
router.post("/login", Login);
router.post('/users/create',createUser);
//view
router.get("/users", authenticate, getAllUsers);
router.get("/users/:id", getUserById);
router.route("users/profile").get(getMe,getUserById).put(getMe,updateUser);
router.put("/users/:id", updateUser);
router.delete("/users/:id", deleteUser);

//property || house
//view
router.get("/properties", getAllProperties);
router.get("/properties/:id", authenticate, getPropertyById);
router.post("/properties", createProperty);
router.put("/properties/:id", updateProperty);
router.delete("/properties/:id", deleteProperty);

module.exports = router;
