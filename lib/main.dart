import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:videocallapp/floating_bubble/floating_bubble_controller.dart';
import 'package:videocallapp/videocall/video_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
    );
  }
}

