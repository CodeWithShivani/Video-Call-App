import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'data/model/product_model.dart';



class ScannerController extends GetxController {
  final products = <Product>[].obs;
  final productName = ''.obs;
  final mrp = ''.obs;
  final mfg = ''.obs;
  final exp = ''.obs;
  final picker = ImagePicker();
  double get totalPrice {
    double total = 0;
    for (var item in products) {
      total += item.mrp * item.quantity;
    }

    return total;
  }

  void addProduct() {
    products.add(
      Product(
        name: productName.value,
        mrp: double.parse(mrp.value),
        mfg: mfg.value,
        exp: exp.value,
      ),
    );

    clear();
  }

  void clear() {
    productName.value = "";
    mrp.value = "";
    mfg.value = "";
    exp.value = "";
  }



  Future<void> scanProduct() async {
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
      );

      if (image == null) {
        print("User cancelled.");
        return;
      }

      print("Image Path: ${image.path}");

      await recognizeText(File(image.path));
    } catch (e) {
      print("Camera Error: $e");
    }
  }

  Future<void> recognizeText(File file) async {
    final inputImage = InputImage.fromFile(file);
    final recognizer = TextRecognizer();
    final result = await recognizer.processImage(inputImage);

    String text = result.text;

    print(text);

    recognizer.close();

    extractData(text);
  }

  void extractData(String text) {

    final lines = text.split('\n');

    if(lines.isNotEmpty){
      productName.value = lines.first;
    }

    final mrpMatch =
    RegExp(r'MRP[: ]*₹?\s*(\d+)').firstMatch(text);

    if(mrpMatch != null){
      mrp.value = mrpMatch.group(1)!;
    }

    final mfgMatch =
    RegExp(r'MFG[: ]*([\d/-]+)').firstMatch(text);

    if(mfgMatch != null){
      mfg.value = mfgMatch.group(1)!;
    }

    final expMatch =
    RegExp(r'EXP[: ]*([\d/-]+)').firstMatch(text);

    if(expMatch != null){
      exp.value = expMatch.group(1)!;
    }

    if(productName.isNotEmpty && mrp.isNotEmpty){
      addProduct();
    }
  }
}