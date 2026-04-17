import 'package:electronics_shop/core/utils/components/cyberpunk_clippers.dart';
import 'package:flutter/material.dart';

class CyberpunkSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool readOnly;
  final bool autofocus;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback? onTap;

  const CyberpunkSearchField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onSubmitted,
    this.readOnly = false,
    this.autofocus = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 56,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FBFF).withOpacity(0.2),
            blurRadius: 15,
          ),
        ],
      ),
      child: ClipPath(
        clipper: CyberpunkShapeClipper(),
        child: Container(
          color: theme.colorScheme.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF00FBFF)),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: readOnly,
                  autofocus: autofocus,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  onTap: onTap,
                  decoration: const InputDecoration.collapsed(
                    hintText: "SEARCH_",
                  ),
                ),
              ),
              if (controller.text.isNotEmpty && !readOnly)
                IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Color(0xFFFF00F7),
                    size: 18,
                  ),
                  onPressed: () {
                    controller.clear();
                    onChanged("");
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
