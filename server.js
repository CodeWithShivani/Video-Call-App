const express = require("express");
const http = require("http");
const { Server } = require("socket.io");

const app = express();
const server = http.createServer(app);

const io = new Server(server, {
  cors: {
    origin: "*"
  }
});

// 🔥 MUST HAVE ROUTE
app.get("/", (req, res) => {
  res.status(200).send("🚀 Video Call Server is Running");
});

io.on("connection", (socket) => {
  console.log("User Connected:", socket.id);

  socket.on("join-room", (roomId) => {
    socket.join(roomId);
    socket.to(roomId).emit("user-joined");
  });

  socket.on("offer", (data) => {
    socket.to(data.roomId).emit("offer", data);
  });

  socket.on("answer", (data) => {
    socket.to(data.roomId).emit("answer", data);
  });

  socket.on("candidate", (data) => {
    socket.to(data.roomId).emit("candidate", data);
  });
});

// 🔥 IMPORTANT FOR RENDER
const PORT = process.env.PORT || 10000;

server.listen(PORT, () => {
  console.log("Server Running on", PORT);
});