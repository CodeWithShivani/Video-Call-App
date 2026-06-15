import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videocallapp/floating_bubble/floating_bubble_controller.dart';
import 'package:videocallapp/product_profit_calculator/billingScreen.dart';
import 'package:videocallapp/videocall/home_view.dart';
import 'package:videocallapp/videocall/video_page.dart';

import 'floating_bubble/floating_bubble_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(FloatingBubbleController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoCallPage(channelName: "room_101"),
      // home: FloatingBubbleScreen(),
    );
  }
}

