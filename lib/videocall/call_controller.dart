import 'package:get/get.dart' hide navigator;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'socket_service.dart';

class CallController extends GetxController {
  final socketService = SocketService();

  final localRenderer = RTCVideoRenderer();
  final remoteRenderer = RTCVideoRenderer();

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;

  String roomId = "test-room";

  @override
  void onInit() {
    super.onInit();
    initCall();
  }

  Future<void> initCall() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();

    socketService.connect();
    socketService.joinRoom(roomId);

    _listenSocketEvents();
    await _getUserMedia();
    await _createPeerConnection();
  }

  void _listenSocketEvents() {
    socketService.socket.on("offer", (data) async {
      await handleOffer(data);
    });

    socketService.socket.on("answer", (data) async {
      await handleAnswer(data);
    });

    socketService.socket.on("ice-candidate", (data) async {
      await addCandidate(data);
    });
  }

  Future<void> _getUserMedia() async {
    final stream = await navigator.mediaDevices.getUserMedia({
      "audio": true,
      "video": true,
    });

    localStream = stream;
    localRenderer.srcObject = stream;
  }

  Future<void> _createPeerConnection() async {
    peerConnection = await createPeerConnection({
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"}
      ]
    });

    peerConnection!.onIceCandidate = (candidate) {
      if (candidate.candidate != null) {
        socketService.sendIceCandidate(roomId, candidate.toMap());
      }
    };

    peerConnection!.onTrack = (event) {
      remoteRenderer.srcObject = event.streams[0];
    };

    localStream!.getTracks().forEach((track) {
      peerConnection!.addTrack(track, localStream!);
    });
  }

  Future<void> createOffer() async {
    final offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);

    socketService.sendOffer(roomId, offer.toMap());
  }

  Future<void> handleOffer(Map data) async {
    await peerConnection!.setRemoteDescription(
      RTCSessionDescription(data["sdp"], data["type"]),
    );

    final answer = await peerConnection!.createAnswer();
    await peerConnection!.setLocalDescription(answer);

    socketService.sendAnswer(roomId, answer.toMap());
  }

  Future<void> handleAnswer(Map data) async {
    await peerConnection!.setRemoteDescription(
      RTCSessionDescription(data["sdp"], data["type"]),
    );
  }

  Future<void> addCandidate(Map data) async {
    await peerConnection!.addCandidate(
      RTCIceCandidate(
        data["candidate"],
        data["sdpMid"],
        data["sdpMLineIndex"],
      ),
    );
  }

  @override
  void onClose() {
    localRenderer.dispose();
    remoteRenderer.dispose();
    peerConnection?.close();
    super.onClose();
  }
}