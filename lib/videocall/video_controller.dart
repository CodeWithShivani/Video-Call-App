import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  // Replace with your Agora App ID from the Agora Console
  final String appId = "1437b08b7eb44277bcddea333faa0def";

  late RtcEngine engine;

  // Reactive variables for GetX to observe
  var localUserJoined = false.obs;
  var remoteUid = 0.obs; // 0 means no remote user has connected yet
  var isMuted = false.obs;
  var isGroup = false.obs;
  var isCameraOff = false.obs;
  // group call
  RxList<int> remoteUids = <int>[].obs;
  RxBool isGroupCall = false.obs;
  RxBool isEngineReady = false.obs;

  void setCallType(bool groupCall) {
    isGroupCall.value = groupCall;
  }



  Future<void> initAgora(String channelName) async {
    // 1. Request device permissions
    await [Permission.camera, Permission.microphone].request();

    // 2. Create the RTC Engine
    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));

    // 3. Register Event Handlers to update state reactively
    engine.registerEventHandler(
      RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            localUserJoined.value = true;

            print("Joined");
            print("Channel : ${connection.channelId}");
            print("UID : ${connection.localUid}");
          },

        onUserJoined: (connection, uid, elapsed) {
          print("Remote Joined : $uid");
          // remoteUid.value = uid;

          if (isGroupCall.value) {
            if (!remoteUids.contains(uid)) {
              remoteUids.add(uid);
            }

          } else {
            remoteUid = uid.obs;
          }

        },

        onUserOffline: (connection, uid, reason) {
          print("Remote Left");
        },

        onConnectionStateChanged: (connection, state, reason) {
          print("State : $state");
          print("Reason : $reason");
        },

        onError: (err, msg) {
          print("ERROR : $err");
          print(msg);
        },
      ),
    );

//grouping call
 /*   await engine.startScreenCapture(
      const ScreenCaptureParameters2(
        captureVideo: true,
        captureAudio: true,
      ),
    );

    await engine.stopScreenCapture();

    FirebaseFirestore.instance
        .collection("meetings")
        .doc("room_101")
        .collection("chat")
        .add({
      "msg": "jj",
      "sender": 1001,
      "time": Timestamp.now(),
    });*/


    await engine.enableVideo();

    await engine.setChannelProfile(
      ChannelProfileType.channelProfileCommunication,
    );

    await engine.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );

    // 4. Enable video and join the simultaneous channel
    await engine.enableVideo();
    await engine.startPreview();


    // =======================
    await engine.enableVideo();
    await engine.setChannelProfile(
    ChannelProfileType.channelProfileCommunication,
    );

    await engine.setClientRole(
    role: ClientRoleType.clientRoleBroadcaster,
    );

    isEngineReady.value = true;

    // In a production app, fetch a dynamic token. For testing, use null or a temp token.
    setCallType(false);
    await engine.joinChannel(
      token: '007eJxTYKj9H2K29EFyveHMD5UhZv9ZjO9fETi/PGVfjLx2TX/F9AgFBkMTY/MkA4sk89QkExMjc/Ok5JSU1ERjY+O0xESDlNS0OZP0sxoCGRm2swUxMzJAIIjPwVCUn58bb2hgyMAAAPXIIL8=',
      channelId: channelName,
      uid: 1001, // 0 lets Agora auto-assign a UID
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  // Toggles
  void toggleMute() {
    isMuted.value = !isMuted.value;
    engine.muteLocalAudioStream(isMuted.value);
  }
  void toggleGroupCalling() {
    isGroup.value = !isGroup.value;
    engine.muteLocalAudioStream(isGroup.value);
  }

  void toggleCamera() {
    isCameraOff.value = !isCameraOff.value;
    engine.muteLocalVideoStream(isCameraOff.value);
  }

  @override
  void onClose() {
    engine.leaveChannel();
    engine.release();
    super.onClose();
  }

  Future<void> endCall() async {
    try {
      await engine.leaveChannel();
      await engine.stopPreview();
      await engine.release();

      remoteUid.value = 0;
      localUserJoined.value = false;
      isMuted.value = false;
      isCameraOff.value = false;
    } catch (e) {
      print("Error ending call: $e");
    }
  }
}