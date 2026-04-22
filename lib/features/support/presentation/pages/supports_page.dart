import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/support_controller.dart';
import '../widgets/support_list.dart';

class SupportsPage extends GetView<SupportController> {
  const SupportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Supports')),
      body: const SupportList(),
    );
  }
}
