import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/support_controller.dart';
import 'support_card.dart';

class SupportList extends GetView<SupportController> {
  const SupportList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return ListView.builder(
        itemCount: controller.items.length,
        itemBuilder: (_, i) => SupportCard(entity: controller.items[i]),
      );
    });
  }
}
