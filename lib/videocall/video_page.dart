import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:videocallapp/videocall/video_controller.dart';

class VideoCallPage extends StatelessWidget {
  final String channelName;
  final VideoCallController controller = Get.put(VideoCallController());

  VideoCallPage({super.key, required this.channelName}) {
    controller.initAgora(channelName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child:
            Obx(() {
              if (controller.isGroup.value) {
                debugPrint("Group video call");
                return GridView.builder(
                  itemCount: controller.remoteUids.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (context, index) {
                    final uid = controller.remoteUids[index];
                    return AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: controller.engine,
                        canvas: VideoCanvas(uid: uid),
                        connection: RtcConnection(channelId: channelName),
                      ),
                    );
                  },
                );
              } else {
                debugPrint("single video call");
                if (controller.remoteUid.value == 0) {
                  return const Text(
                    "Waiting for the other device to connect...",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  );
                }

                return AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: controller.engine,
                    canvas: VideoCanvas(uid: controller.remoteUid.value),
                    connection: RtcConnection(channelId: channelName),
                  ),
                );
              }
            }),


          ),
          Positioned(
            top: 50,
            right: 20,
            width: 120,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.grey[900],
                child: Obx(() {
                  if (!controller.isEngineReady.value) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  // controller.localUserJoined.value &&

                  if (!controller.isCameraOff.value) {
                    return AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: controller.engine,
                        canvas: const VideoCanvas(
                          uid: 0,
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Icon(Icons.videocam_off, color: Colors.white),
                    );
                  }
                }),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mute/Unmute Button
                  CircleAvatar(
                    backgroundColor: controller.isMuted.value
                        ? Colors.red
                        : Colors.grey[800],
                    radius: 24,
                    child: IconButton(
                      icon: Icon(
                        controller.isMuted.value ? Icons.mic_off : Icons.mic,
                      ),
                      color: Colors.white,
                      onPressed: controller.toggleMute,
                    ),
                  ),
                  const SizedBox(width: 20),

                  // End Call Button
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 28, // Slightly bigger for the primary action
                    child: IconButton(
                      icon: const Icon(Icons.call_end),
                      color: Colors.white,
                      onPressed: () async {
                        final confirm = await Get.dialog<bool>(
                          AlertDialog(
                            title: const Text("End Call?"),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(result: false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Get.back(result: true),
                                child: const Text("End"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await controller.endCall();
                          SystemNavigator.pop();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Camera On/Off Button
                  CircleAvatar(
                    backgroundColor: controller.isCameraOff.value
                        ? Colors.red
                        : Colors.grey[800],
                    radius: 24,
                    child: IconButton(
                      icon: Icon(
                        controller.isCameraOff.value
                            ? Icons.videocam_off
                            : Icons.videocam,
                      ),
                      color: Colors.white,
                      onPressed: controller.toggleCamera,
                    ),
                  ),
                  const SizedBox(width: 20),
                  CircleAvatar(
                    backgroundColor: controller.isGroup.value
                        ? Colors.grey[800]
                        : Colors.red,
                    radius: 24,
                    child: IconButton(
                      icon: Icon(
                        controller.isGroup.value
                            ? Icons.group
                            : Icons.group_off,
                      ),
                      color: Colors.white,
                      onPressed: controller.toggleGroupCalling,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
