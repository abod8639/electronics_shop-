import 'package:flutter/material.dart';

class SupportSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SupportSearchBar({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: const InputDecoration(
        hintText: 'Search...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
