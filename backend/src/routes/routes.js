const express = require("express");
const {
  getAllUsers,
  getUserById,
  createUser,
  updateUser,
  deleteUser,
  Login,
} = require("../controllers/userController");
const {
  getAllProperties,
  getPropertyById,
  createProperty,
  updateProperty,
  deleteProperty,
} = require("../controllers/propertyController");
const authenticate = require("../middleware/authentication");
const {
  getAllFavorites,
  getFavoriteById,
  createFavorite,
  updateFavorite,
  deleteFavorite,
} = require("../controllers/favoriteController");
const router = express.Router();

//LOGIN
router.post("/login", Login);

//view
router.get("/users", getAllUsers);
router.get("/users/:id", getUserById);

router.post("/users", createUser);
router.put("/users/:id", updateUser);
router.delete("/users/:id", deleteUser);

//property || house
//view
router.get("/properties", getAllProperties);
router.get("/properties/:id", authenticate, getPropertyById);

router.post("/properties", createProperty);
router.put("/properties/:id", updateProperty);
router.delete("/properties/:id", deleteProperty);

// favorites
router.get("/favorites", getAllFavorites);
router.get("/favorites/:id", authenticate, getFavoriteById);

router.post("/favorites", createFavorite);
router.put("/favorites/:id", updateFavorite);
router.delete("/favorites/:id", deleteFavorite);

module.exports = router;
