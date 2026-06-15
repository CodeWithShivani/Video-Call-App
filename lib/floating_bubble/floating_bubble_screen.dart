import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'floating_bubble_controller.dart';

class FloatingBubbleScreen extends GetView<FloatingBubbleController> {
  const FloatingBubbleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
      FloatingActionButtonLocation.endFloat,

      floatingActionButton: Obx(
            () => FloatingActionBubble(
              animation: controller.animation,
              onPress: controller.toggleBubble,
              iconColor: Colors.white,
              backGroundColor: Colors.blue,
              iconData: Icons.text_fields,
              items: <Bubble>[

            Bubble(
              title: "Language",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.language,
              titleStyle: const TextStyle(
                  color: Colors.white),
              onPress: () {
                controller.toggleBubble();
                print("Language");
              },
            ),

            Bubble(
              title: "Copy",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.copy,
              titleStyle: const TextStyle(
                  color: Colors.white),
              onPress: () {
                controller.toggleBubble();
                print("Copy");
              },
            ),

            Bubble(
              title: "Share",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.share,
              titleStyle: const TextStyle(
                  color: Colors.white),
              onPress: () {
                controller.toggleBubble();
                print("Share");
              },
            ),

            Bubble(
              title: "Undo",
              iconColor: Colors.white,
              bubbleColor: Colors.blue,
              icon: Icons.undo,
              titleStyle: const TextStyle(
                  color: Colors.white),
              onPress: () {
                controller.toggleBubble();
                print("Undo");
              },
            ),
          ],
        ),
      ),
    );
  }
}
