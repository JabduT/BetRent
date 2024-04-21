// controllers/propertyController.js

const { Property, validateProperty } = require("../models/property");
const Joi = require("joi");

const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

exports.createProperty = async (req, res) => {
  // Validate property input
  const { error } = validateProperty(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  try {
    const property = new Property(req.body);

    // Handle file uploads
    const uploadsDir = path.join(__dirname, '..', 'uploads');
    if (!fs.existsSync(uploadsDir)) {
      fs.mkdirSync(uploadsDir);
    }

    if (req.files && req.files.length > 0) {
      property.files = [];
      req.files.forEach(file => {
        const filename = uuidv4() + path.extname(file.originalname);
        const filePath = path.join(uploadsDir, filename);
        fs.writeFileSync(filePath, file.buffer);
        property.files.push(filename);
      });
    }

    await property.save();
    res.status(201).json(property);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

//Get All product
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

// Get all properties
exports.getAllProperties = async (req, res) => {
  try {
    const features = new APIfeatures(Property.find(), req.query)
      .multfilter()
      .filter()
      .sort()
      .limiting()
      .paginatinating();
    const properties = await features.query.select();
    // const properties = await Property.find();
    res.json(properties);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};


// Get property by ID
exports.getPropertyById = async (req, res) => {
  try {
    const property = await Property.findById(req.params.id);
    if (!property) {
      return res.status(404).json({ message: "Property not found" });
    }
    res.json(property);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Update property by ID
exports.updateProperty = async (req, res) => {
  // Validate property input
  const { error } = validateProperty(req.body);
  if (error) {
    return res.status(400).json({ message: error.details[0].message });
  }

  try {
    const property = await Property.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    if (!property) {
      return res.status(404).json({ message: "Property not found" });
    }
    res.json(property);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Delete property by ID
exports.deleteProperty = async (req, res) => {
  try {
    const property = await Property.findByIdAndDelete(req.params.id);
    if (!property) {
      return res.status(404).json({ message: "Property not found" });
    }
    res.json({ message: "Property deleted successfully" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
