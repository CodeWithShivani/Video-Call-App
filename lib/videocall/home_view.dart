import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'call_controller.dart';
import 'call_view.dart';


class HomeView extends StatelessWidget {
  final controller = Get.put(CallController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Call App")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.to(() => CallScreen());
          },
          child: Text("Start Call"),
        ),
      ),
    );
  }
}