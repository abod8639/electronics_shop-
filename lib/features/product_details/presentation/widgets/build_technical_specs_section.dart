import 'package:electronics_shop/features/product_details/presentation/widgets/expandable_description_card.dart';
import 'package:flutter/material.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';



Widget buildTechnicalSpecsSection(ProductModel product, bool isDark) {
  final dynamic technicalSpecs = product.technicalSpecifications;
  if (technicalSpecs == null || technicalSpecs is! Map || technicalSpecs.isEmpty) {
    return const SizedBox.shrink();
  }

  final specs = Map<String, dynamic>.from(technicalSpecs);

  return Builder(
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      // final theme = Theme.of(context);
      final cyan = const Color(0xFF00FBFF);

      return  ExpandableDescriptionCard(
        icon: Icon( Icons.token_outlined, ),
        title: l10n.technicalSpecifications.toUpperCase(),
        child: Column(
        children: specs.entries.indexed.map<Widget>((item) {
          final index = item.$1;
          final entry = item.$2;
          final isLast = index == specs.length - 1;
      
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _getSpecIcon(entry.key, cyan),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Text(
                        entry.key.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          letterSpacing: 0.5,
                          color: cyan.withValues(alpha: .8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        entry.value.toString(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'monospace',
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Opacity(
                    opacity: 0.1,
                    child: Divider(color: cyan, height: 1),
                  ),
                ),
            ],
          );
        }).toList(),
                )
      );
    },
  );
}

Widget _getSpecIcon(String key, Color cyan) {
  final lowerKey = key.toLowerCase();
  IconData iconData = Icons.info_outline;
  Color iconColor = cyan;

  if (lowerKey.contains('cpu') || lowerKey.contains('processor') || lowerKey.contains('chip')) {
    iconData = Icons.memory_rounded;
  } else if (lowerKey.contains('ram') || lowerKey.contains('memory')) {
    iconData = Icons.speed_rounded;
  } else if (lowerKey.contains('storage') || lowerKey.contains('ssd') || lowerKey.contains('hdd')) {
    iconData = Icons.storage_rounded;
  } else if (lowerKey.contains('battery')) {
    iconData = Icons.battery_charging_full_rounded;
  } else if (lowerKey.contains('screen') || lowerKey.contains('display')) {
    iconData = Icons.screenshot_rounded;
  } else if (lowerKey.contains('camera')) {
    iconData = Icons.camera_alt_rounded;
  } else if (lowerKey.contains('weight')) {
    iconData = Icons.monitor_weight_outlined;
  } else if (lowerKey.contains('os') || lowerKey.contains('system')) {
    iconData = Icons.computer_rounded;
  }

  return  Icon(iconData, size: 25, color: iconColor);
}

class CyberpunkIconClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 8);
    path.lineTo(size.width - 8, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

