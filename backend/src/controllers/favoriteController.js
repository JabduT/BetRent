const { Favorite } = require("../models/favorite");
const { User } = require("../models/user");
const { Property } = require("../models/property");

// Create a new favorite
exports.createFavorite = async (req, res) => {
  try {
    const { userId, propertyId } = req.body;
    // Check if user exists
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    // Check if property exists
    const property = await Property.findById(propertyId);
    if (!property)
      return res.status(404).json({ message: "Property not found" });

    // Create new favorite
    const favorite = new Favorite({ userId, propertyId });
    await favorite.save();

    res.status(201).json(favorite);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
class APIfeatures {
  constructor(query, queryString) {
    this.query = query;
    this.queryString = queryString;
  }
  multfilter() {
    const searchQuery = this.queryString.q || "";
    if (typeof searchQuery === "string") {
      const regexSearch = {
        $or: [
          { title: { $regex: searchQuery, $options: "i" } },
          { categories: { $regex: searchQuery, $options: "i" } },
        ],
      };
      this.query.find(regexSearch);
    }
    return this;
  }
  filter() {
    //1 build query
    const queryObj = { ...this.queryString };
    const excludedFields = ["page", "limit", "sort", "fields", "q"];
    excludedFields.forEach((el) => delete queryObj[el]);
    // advanced query
    let queryStr = JSON.stringify(queryObj);
    queryStr = queryStr.replace(
      /\b(gte|gt|lte|lt|eq)\b/g,
      (match) => `$${match}`
    );
    this.query = this.query.find(JSON.parse(queryStr));
    return this;
  }
  sort() {
    if (this.queryString.sort) {
      const sortBy = this.queryString.sort.split(",").join(" ");
      this.query = this.query.sort(sortBy);
    } else {
      this.query = this.query.sort("-createdAt");
    }
    return this;
  }
  limiting() {
    if (this.queryString.fields) {
      const selectedFields = this.queryString.fields.split(",").join(" ");
      this.query = this.query.select(selectedFields);
    } else {
      this.query = this.query.select("-__v");
    }
    return this;
  }
  paginatinating() {
    const page = this.queryString.page * 1 || 1;
    const limit = this.queryString.limit * 1 || 10;
    const skip = (page - 1) * limit;
    this.query = this.query.skip(skip).limit(limit);
    return this;
  }
}
// Get all favorites
// Get all favorites
exports.getAllFavorites = async (req, res) => {
  try {
    const userId = req.user ? req.user._id : "";
    const userFavorites = await Favorite.find({ userId });

    const favoritePropertyIds = new Set(
      userFavorites.map((favorite) => favorite.propertyId.toString())
    );

    const features = new APIfeatures(
      Property.find({ _id: { $in: Array.from(favoritePropertyIds) } }),
      req.query
    )
      .multfilter()
      .filter()
      .sort()
      .limiting()
      .paginatinating();

    const favoriteProperties = await features.query;

    const propertiesWithFavorites = favoriteProperties.map((property) => ({
      ...property.toObject(),
      favorite: true,
    }));

    res.json(propertiesWithFavorites);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


// Get a favorite by ID
exports.getFavoriteById = async (req, res) => {
  try {
    const favorite = await Favorite.findById(req.params.id);
    if (!favorite)
      return res.status(404).json({ message: "Favorite not found" });

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
    if (!user) return res.status(404).json({ message: "User not found" });

    // Check if property exists
    const property = await Property.findById(propertyId);
    if (!property)
      return res.status(404).json({ message: "Property not found" });

    // Find and update the favorite
    const favorite = await Favorite.findByIdAndUpdate(
      req.params.id,
      { userId, propertyId },
      { new: true }
    );
    if (!favorite)
      return res.status(404).json({ message: "Favorite not found" });

    res.json(favorite);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete a favorite
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
