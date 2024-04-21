const jwt = require("jsonwebtoken");
const { User } = require("../models/User");

const authenticate = (req, res, next) => {
  // Get the token from the request headers
  const token = req.header("Authorization");

  // Check if token is present
  if (!token) {
    return res
      .status(401)
      .json({ message: "Access denied. No token provided." });
  }

  try {
    // Verify the token
    const decoded = jwt.verify(token, "your_secret_key");

    // Check if decoded token contains userId
    if (!decoded.userId) {
      return res
        .status(401)
        .json({ message: "Invalid token. No userId found." });
    }

    // Find user by userId from decoded token
    User.findById(decoded.userId, (err, user) => {
      if (err || !user) {
        return res
          .status(401)
          .json({ message: "Invalid token. User not found." });
      }

      // Set authenticated user in request object
      req.user = user;
      next(); // Move to the next middleware or route handler
    });
  } catch (error) {
    return res.status(401).json({ message: "Invalid token." });
  }
};

module.exports = authenticate;
