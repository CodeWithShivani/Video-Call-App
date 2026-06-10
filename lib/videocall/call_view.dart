import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'call_controller.dart';

class CallScreen extends StatelessWidget {
  final controller = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: RTCVideoView(controller.remoteRenderer),
          ),
          Expanded(
            child: RTCVideoView(controller.localRenderer, mirror: true),
          ),
          ElevatedButton(
            onPressed: () => controller.createOffer(),
            child: Text("Start Call"),
          ),
        ],
      ),
    );
  }
}