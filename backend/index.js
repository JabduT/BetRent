const express = require("express");
const dotenv = require("dotenv");
const router = require("./src/routes/routes");
const bodyParser = require("body-parser");
const cors = require('cors');
// Load environment variables
dotenv.config();


// Create Express app
const app = express();

app.use(cors());
app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.json());

require("./src/config/db");
// Routes
app.use("/api", router);


// Set port
const PORT = process.env.PORT || 5000;

app.use(express.static("uploads"));

app.use(express.static("src/uploads"));
// Start server
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
