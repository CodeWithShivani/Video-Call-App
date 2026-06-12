import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    socket = IO.io(
      "https://video-call-app-aj8l.onrender.com/",
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


  void sendOffer(String roomId, dynamic offer) {
    socket.emit("offer", {
      "roomId": roomId,
      "sdp": offer.sdp,
      "type": offer.type
    });
  }

  void sendAnswer(String roomId, dynamic answer) {
    socket.emit("answer", {
      "roomId": roomId,
      "sdp": answer.sdp,
      "type": answer.type
    });
  }

  void sendIceCandidate(String roomId, dynamic candidate) {
    socket.emit("ice-candidate", {
      "roomId": roomId,
      "candidate": {
        "candidate": candidate.candidate,
        "sdpMid": candidate.sdpMid,
        "sdpMLineIndex": candidate.sdpMLineIndex
      }
    });
  }
}