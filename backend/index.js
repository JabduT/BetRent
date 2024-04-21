const express = require("express");
const dotenv = require("dotenv");
const router = require("./src/routes/routes");
const bodyParser = require("body-parser");

// Load environment variables
dotenv.config();

// Create Express app
const app = express();
app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.json());

require("./src/config/db");
// Routes
app.use("/api", router);
app.use((req, res, next) => {
  console.log('Incoming request:', req.method, req.url);
  console.log('Request body:', req.body);
  next();
});

// Set port
const PORT = process.env.PORT || 5000;

// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
