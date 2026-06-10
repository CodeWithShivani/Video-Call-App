import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(
      "http://YOUR_IP:3000",
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
  }

  void joinRoom(String roomId) {
    socket.emit("join-room", roomId);
  }

  void sendOffer(String roomId, Map offer) {
    socket.emit("offer", {"roomId": roomId, "offer": offer});
  }

  void sendAnswer(String roomId, Map answer) {
    socket.emit("answer", {"roomId": roomId, "answer": answer});
  }

  void sendIceCandidate(String roomId, Map candidate) {
    socket.emit("ice-candidate", {"roomId": roomId, "candidate": candidate});
  }
}