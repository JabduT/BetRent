const { Favorite } = require('../models/Favorite');
const { User } = require('../models/User');
const { Property } = require('../models/property');

// Create a new favorite
exports.createFavorite = async (req, res) => {
  try {
    const { userId, propertyId } = req.body;

    // Check if user exists
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Check if property exists
    const property = await Property.findById(propertyId);
    if (!property) return res.status(404).json({ message: 'Property not found' });

    // Create new favorite
    const favorite = new Favorite({ userId, propertyId });
    await favorite.save();

    res.status(201).json(favorite);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get all favorites
exports.getAllFavorites = async (req, res) => {
  try {
    const favorites = await Favorite.find();
    res.json(favorites);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get a favorite by ID
exports.getFavoriteById = async (req, res) => {
  try {
    const favorite = await Favorite.findById(req.params.id);
    if (!favorite) return res.status(404).json({ message: 'Favorite not found' });

    res.json(favorite);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update a favorite
exports.updateFavorite = async (req, res) => {
  try {
    const { userId, propertyId } = req.body;

    // Check if user exists
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    // Check if property exists
    const property = await Property.findById(propertyId);
    if (!property) return res.status(404).json({ message: 'Property not found' });

    // Find and update the favorite
    const favorite = await Favorite.findByIdAndUpdate(req.params.id, { userId, propertyId }, { new: true });
    if (!favorite) return res.status(404).json({ message: 'Favorite not found' });

    res.json(favorite);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete a favorite
exports.deleteFavorite = async (req, res) => {
  try {
    const favorite = await Favorite.findById(req.params.id);
    if (!favorite) return res.status(404).json({ message: 'Favorite not found' });

    await favorite.remove();
    res.json({ message: 'Favorite deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
