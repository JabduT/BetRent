
const { Favorite } = require('../models/Favorite');
const { User } = require('../models/User');
const { Property } = require('../models/Property');

// Function to create a new favorite
exports.createFavorite = async (req, res) => {
  try {
    // Check if user exists
    const user = await User.findById(req.body.userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    // Check if property exists
    const property = await Property.findById(req.body.propertyId);
    if (!property)
      return res.status(404).json({ message: "Property not found" });

    // Create new favorite
    const favorite = new Favorite(req.body);
    await favorite.save();

    res.status(201).json(favorite);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Function to get all favorites
exports.getAllFavorites = async (req, res) => {
  try {
    const favorites = await Favorite.find();
    res.json(favorites);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Function to delete a favorite
exports.deleteFavorite = async (req, res) => {
  try {
    const favorite = await Favorite.findById(req.params.id);
    if (!favorite)
      return res.status(404).json({ message: "Favorite not found" });

    await favorite.remove();
    res.json({ message: "Favorite deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
