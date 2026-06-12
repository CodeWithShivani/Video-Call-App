import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videocallapp/product_profit_calculator/billingScreen.dart';
import 'package:videocallapp/product_profit_calculator/scanner_controller.dart';
import 'package:videocallapp/product_profit_calculator/scanner_page.dart';
import 'package:videocallapp/videocall/home_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(ScannerController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BillingScreen(),
    );
  }
}

