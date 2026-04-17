import 'package:flutter/material.dart';
import 'package:electronics_shop/core/constants/app_colors.dart';
import 'package:electronics_shop/features/product/data/models/product_model.dart';
import 'package:electronics_shop/l10n/generated/app_localizations.dart';

class CyberpunkSpecsClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double cut = 16.0;
    path.moveTo(cut, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - cut);
    path.lineTo(size.width - cut, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cut);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget buildTechnicalSpecsSection(ProductModel product, bool isDark) {
  final dynamic technicalSpecs = product.technicalSpecifications;
  if (technicalSpecs == null ||
      technicalSpecs is! Map ||
      technicalSpecs.isEmpty) {
    return const SizedBox.shrink();
  }

      final cyan = const Color(0xFF00FBFF);
      final magenta = const Color(0xFFFF00F7);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: cyan,
                    boxShadow: [BoxShadow(color: cyan.withValues(alpha: .5), blurRadius: 4)],
                  ),
                ),
                Text(
                  l10n.technicalSpecifications.toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontFamily: 'monospace',
                    color: isDark ? cyan : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: cyan.withValues(alpha: 0.05),
                  blurRadius: 15,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: ClipPath(
              clipper: CyberpunkSpecsClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? theme.colorScheme.surface : Colors.white,
                  border: Border(
                    left: BorderSide(color: cyan.withValues(alpha: .5), width: 3),
                    bottom: BorderSide(color: cyan.withValues(alpha: .3), width: 1),
                  ),
                ),
                child: Stack(
                  children: [
                    // Digital grid pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.03,
                        child: GridPaper(
                          color: cyan,
                          divisions: 1,
                          subdivisions: 1,
                          interval: 20,
                        ),
                      ),
                    ),
                    Column(
                      children: specs.entries.indexed.map<Widget>((item) {
                        final index = item.$1;
                        final entry = item.$2;
                        final isLast = index == specs.length - 1;

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _getSpecIcon(entry.key, isDark, cyan),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

Widget _getSpecIcon(String key, bool isDark) {
  final lowerKey = key.toLowerCase();
  IconData iconData = Icons.info_outline;
  Color iconColor = isDark ? Colors.grey[500]! : Colors.grey[400]!;

  if (lowerKey.contains('cpu') ||
      lowerKey.contains('processor') ||
      lowerKey.contains('chip')) {
    iconData = Icons.memory_rounded;
    iconColor = Colors.blue.withValues(alpha: .5);
  } else if (lowerKey.contains('ram') || lowerKey.contains('memory')) {
    iconData = Icons.speed_rounded;
    iconColor = Colors.orange.withValues(alpha: .5);
  } else if (lowerKey.contains('storage') ||
      lowerKey.contains('ssd') ||
      lowerKey.contains('hdd')) {
    iconData = Icons.storage_rounded;
    iconColor = Colors.amber.withValues(alpha: .5);
  } else if (lowerKey.contains('battery')) {
    iconData = Icons.battery_charging_full_rounded;
    iconColor = Colors.green.withValues(alpha: .5);
  } else if (lowerKey.contains('screen') || lowerKey.contains('display')) {
    iconData = Icons.screenshot_rounded;
    iconColor = Colors.purple.withValues(alpha: .5);
  } else if (lowerKey.contains('camera')) {
    iconData = Icons.camera_alt_rounded;
    iconColor = Colors.red.withValues(alpha: .5);
  } else if (lowerKey.contains('weight')) {
    iconData = Icons.monitor_weight_outlined;
    iconColor = Colors.teal.withValues(alpha: .5);
  } else if (lowerKey.contains('os') || lowerKey.contains('system')) {
    iconData = Icons.computer_rounded;
    iconColor = Colors.indigo.withValues(alpha: .5);
  }

  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: iconColor.withValues(alpha: 0.1),
      shape: BoxShape.circle,
    ),
    child: Icon(iconData, size: 18, color: iconColor),
  );
}
