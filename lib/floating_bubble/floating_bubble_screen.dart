import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'floating_bubble_controller.dart';

class FloatingBubbleScreen extends GetView<FloatingBubbleController> {
  const FloatingBubbleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Floating Bubble Example"),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const Text('Your Screen Content'),
                ElevatedButton(
                  onPressed: () => controller.pickMonth(context),
                  child: const Text("Pick Month"),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 200,
                height: 200,
                child:CircularMenu(
                  alignment: Alignment.bottomCenter,
                  radius: 100,
                  startingAngleInRadian: 3.14,
                  endingAngleInRadian: 6.28,
                  toggleButtonColor: Colors.blue,
                  toggleButtonIconColor: Colors.white,
                  toggleButtonSize: 40,

                  items: [
                    CircularMenuItem(
                      icon: Icons.language,
                      color: Colors.blue,
                      iconColor: Colors.white,
                      onTap: () {
                        print("Language clicked");
                      },
                    ),
                    CircularMenuItem(
                      icon: Icons.copy,
                      color: Colors.blue,
                      iconColor: Colors.white,
                      onTap: () {
                        print("Copy clicked");
                      },
                    ),
                    CircularMenuItem(
                      icon: Icons.share,
                      color: Colors.blue,
                      iconColor: Colors.white,
                      onTap: () {
                        print("Share clicked");
                      },
                    ),
                    CircularMenuItem(
                      icon: Icons.undo,
                      color: Colors.blue,
                      iconColor: Colors.white,
                      onTap: () {
                        print("Undo clicked");
                      },
                    ),
                  ],
                )
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*Obx(() {
return IndexedStack(
index: tabs.indexOf(controller.selectedTab.value),
children: [
Tab1View(),
Tab2View(),
Tab3View(),
Tab4View(),
],
);
})*/



/*Expanded(
child: Obx(() {
switch (controller.selectedTab.value) {
case "Tab1":
return Tab1Screen();

case "Tab2":
return Tab2Screen();

case "Tab3":
return Tab3Screen();

case "Tab4":
return Tab4Screen();

default:
return const SizedBox();
}
}),
),*/
