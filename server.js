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

// health check
app.get("/", (req, res) => {
  res.send("🚀 Video Call Server Running");
});

io.on("connection", (socket) => {
  console.log("User Connected:", socket.id);

socket.on("join-room", (roomId) => {
  socket.join(roomId);
  socket.to(roomId).emit("user-joined", socket.id); // IMPORTANT FIX
});

socket.onConnect((_) => print("CONNECTED"));
socket.on("user-joined", (d) => print("USER JOINED"));
socket.on("offer", (d) => print("OFFER RECEIVED $d"));
socket.on("answer", (d) => print("ANSWER RECEIVED $d"));
socket.on("ice-candidate", (d) => print("ICE RECEIVED $d"));

socket.on("user-joined", (_) async {
  print("Someone joined → I AM CALLER");

  await createOffer(); // ONLY HERE
});

socket.on("offer", (data) {
  print("OFFER RECEIVED: $data");
});

socket.on("answer", (data) {
  print("ANSWER RECEIVED: $data");
});

socket.on("ice-candidate", (data) {
  print("ICE RECEIVED: $data");
});

socketService.socket.on("user-joined", (_) async {
  print("Someone joined → I AM CALLER");

  await createOffer(); // ONLY CALLER triggers offer
});

  // OFFER
  socket.on("offer", (data) => {
    socket.to(data.roomId).emit("offer", {
      sdp: data.sdp,
      type: data.type
    });
  });

  // ANSWER
  socket.on("answer", (data) => {
    socket.to(data.roomId).emit("answer", {
      sdp: data.sdp,
      type: data.type
    });
  });

  // ICE
  socket.on("ice-candidate", (data) => {
    socket.to(data.roomId).emit("ice-candidate", {
      candidate: data.candidate
    });
  });
});

socket.on("offer", (data) {
  print("Offer received: $data");
});

socket.on("answer", (data) {
  print("Answer received: $data");
});

socket.on("ice-candidate", (data) {
  print("ICE received: $data");
});

const PORT = process.env.PORT || 10000;

server.listen(PORT, () => {
  console.log("Server running on", PORT);
});