import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:videocallapp/product_profit_calculator/scanner_controller.dart';

class ScannerPage extends GetView<ScannerController> {

  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("AI Inventory Scanner"),
      ),

      body: Padding(

        padding: const EdgeInsets.all(15),

        child: Column(

          children: [

            Container(

              height: 250,

              decoration: BoxDecoration(

                color: Colors.black12,

                borderRadius: BorderRadius.circular(15),
              ),

              child: const Center(

                child: Icon(

                  Icons.camera_alt,

                  size: 70,
                ),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: () {

                controller.scanProduct();

              },

              child: const Text("Scan Product"),
            ),

            const SizedBox(height: 25),

            Obx(() {

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name : ${controller.productName.value}"),
                  Text("MRP : ₹${controller.mrp.value}"),
                  Text("MFG : ${controller.mfg.value}"),
                  Text("EXP : ${controller.exp.value}"),
                ],
              );
            }),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: controller.addProduct,

              child: const Text("Add Inventory"),
            ),

            const SizedBox(height: 20),

            Expanded(

              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.products.length,
                  itemBuilder: (_, index) {
                    final item = controller.products[index];
                    return Card(
                      child: ListTile(
                        title: Text(item.name),
                        subtitle: Text(
                          "MRP ₹${item.mrp}\nEXP ${item.exp}",
                        ),
                        trailing: Text("₹${item.mrp * item.quantity}",
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            Obx(() {
              return Text(
                "Total : ₹${controller.totalPrice}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}