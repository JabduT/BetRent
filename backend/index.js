const express = require("express");
const dotenv = require("dotenv");
const router = require("./src/routes/routes");
const bodyParser = require("body-parser");
const cors = require("cors");
const http = require("http");
const socketIo = require("socket.io");
const Message = require("./src/models/Message");

// Load environment variables
dotenv.config();

// Create Express app
const app = express();
const server = http.createServer(app);
const io = socketIo(server);

app.use(cors());
app.use(express.json());
app.use(bodyParser.json());
app.use(bodyParser.json());

require("./src/config/db");
app.use("/api", router);

// Socket.IO events
io.on("connection", (socket) => {
  console.log("A user connected with socket ID:", socket.id);

  // Join room
  socket.on("join room", (roomId) => {
    console.log("User joined room:", roomId);
    socket.join(roomId);
  });

  // Handle private chat messages
  socket.on("private message", async (data) => {
    console.log("Private Message:", data);

    try {
      // Create a new message instance
      const newMessage = new Message({
        text: data.text,
        sender: data.senderId,
        receiver: data.receiverId,
      });

      // Save the message to the database
      await newMessage.save();

      // Emit the message to the room corresponding to the chat session ID
      io.to(data.roomId).emit("private message", data);
    } catch (error) {
      console.error("Error saving private message:", error);
    }
  });

  // Handle disconnection
  socket.on("disconnect", () => {
    console.log("User disconnected with socket ID:", socket.id);
  });
});

// Set port
const PORT = process.env.PORT || 5000;

// Start server
server.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
