import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController extends GetxController {
  final String appId = "1437b08b7eb44277bcddea333faa0def";

  late RtcEngine engine;
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
    final permissions = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (permissions[Permission.camera] != PermissionStatus.granted ||
        permissions[Permission.microphone] != PermissionStatus.granted) {
      print("Permissions not granted");
      return;
    }

    engine = createAgoraRtcEngine();
    await engine.initialize(RtcEngineContext(appId: appId));

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          print("Joined channel successfully");
          print("Local UID: ${connection.localUid}");
          localUserJoined.value = true;
        },

        onConnectionStateChanged: (connection, state, reason) {
          print("Connection state: $state");
          print("Connection reason: $reason");
        },

        onError: (err, msg) {
          print("Agora Error: $err");
          print("Agora Message: $msg");
        },

        onUserJoined: (connection, uid, elapsed) {
          print("Remote joined: $uid");
          remoteUid.value = uid;

          // Group call ke liye
          if (!remoteUids.contains(uid)) {
            remoteUids.add(uid);
          }

          print("Remote UIDs: $remoteUids");
        },
      ),
    );
    await engine.enableVideo();
    await engine.startPreview();
    print("Preview started");
    await engine.enableLocalVideo(true);
    isEngineReady.value = true;

    setCallType(false);
    try {
      print("Calling joinChannel");
      await engine.joinChannel(
        token:
            '007eJxTYFg165jAqfkX07RyEy5NO7v+wRm7wos6sr3RWdNTk6Kzee8pMBiaGJsnGVgkmacmmZgYmZsnJaekpCYaGxunJSYapKSmCfs4ZTUEMjLcaOVhYmSAQBCfg6EoPz833tDAkIEBAB8KIPQ=',
        channelId: channelName,
        uid: 1003,
        options: const ChannelMediaOptions(
          channelProfile: ChannelProfileType.channelProfileCommunication,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishCameraTrack: true,
          publishMicrophoneTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );
      print("joinChannel returned");
    } catch (e) {
      print("joinChannel exception: $e");
    }
  }

  void toggleMute() {
    isMuted.value = !isMuted.value;
    engine.muteLocalAudioStream(isMuted.value);
  }

  void toggleGroupCalling() {
    isGroup.value = !isGroup.value;
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
