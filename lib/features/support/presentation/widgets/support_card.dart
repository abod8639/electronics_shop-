import 'package:flutter/material.dart';
import '../../domain/entities/support_entity.dart';

class SupportCard extends StatelessWidget {
  final SupportEntity entity;

  const SupportCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(entity.name),
        subtitle: Text(entity.id),
      ),
    );
  }
}
